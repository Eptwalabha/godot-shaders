shader_type canvas_item;

uniform float scale : hint_range(0.0, 20.0) = 4.0;
uniform float shift : hint_range(0.0, 1.0) = 0.5;
uniform float inner_scale : hint_range(0.0, 1.0) = 1.0;
uniform float angle_pi : hint_range(0.0, 2.0) = 0.0;
uniform float speed;

uniform sampler2D sdf : hint_default_black, filter_linear_mipmap_anisotropic, repeat_enable;
uniform float sdf_threshold : hint_range(0.0, 1.0) = 0.5;

uniform vec4 sdf_color : source_color = vec4(1.0);
uniform vec4 bg_color: source_color;

vec2 rotate_uv(vec2 uv, float a, float mid) {
	a *= PI;
	uv -= mid;
	return vec2(
		cos(a) * uv.x + sin(a) * uv.y,
		cos(a) * uv.y - sin(a) * uv.x
	) + mid;
}

void fragment() {
	vec2 uv = rotate_uv(vec2(UV.x * 1.778, UV.y) * scale, angle_pi, 0.0);
	float i = floor(uv.x);
	float odd = step(0.5, fract(uv.x / 2.0)) * 2.0 - 1.0;
	uv.y += speed * odd * TIME - i * shift;
	uv = fract(uv);
	uv = rotate_uv(uv, -angle_pi, 0.5);
	uv -= (1.0 - inner_scale) / 2.0;
	uv /= inner_scale;
	uv = clamp(uv, vec2(0.0), vec2(1.0));

	float sdf_dist = texture(sdf, fract(uv * .5)).r;
	float sdf_mask = step(sdf_threshold, sdf_dist);
	COLOR = mix(bg_color, sdf_color, sdf_mask);
}
