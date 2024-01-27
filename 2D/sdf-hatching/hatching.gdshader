shader_type canvas_item;

uniform sampler2D sdf : hint_default_black, filter_linear, repeat_enable;
uniform float sdf_threshold : hint_range(0.0, 1.0) = 0.5;
uniform float sdf_border_width : hint_range(0.0, 1.0) = 0.02;

uniform float scale = 3.0;
uniform float screen_ratio = 1.778;

uniform float hatch_width : hint_range(0.0, 0.3) = 0.1;
uniform float hatch_angle : hint_range(0.0, 2.0) = 0.0;
uniform float hatch_density : hint_range(0.0, 1000) = 500.0;
uniform float hash_pow : hint_range(0.0, 10.0) = 2.0;

float sub(float d1, float d2) {
	return max(d1, d2);
}

vec2 rotate(vec2 uv, float angle, float mid) {
	angle *= PI;
	uv -= mid;
	return vec2(
		cos(angle) * uv.x + sin(angle) * uv.y,
		cos(angle) * uv.y - sin(angle) * uv.x
	) + mid;
}

float hash(vec2 uv, float angle, float density, float power) {
	vec2 uv_hash = vec2(sin(rotate(uv, angle, 0.5) * density * 10.0));
	return pow((uv_hash.x + 1.0) / 2.0, 1.0 / power);
}

void fragment() {
	vec2 uv = fract(vec2(UV.x * screen_ratio, UV.y) * scale);
	uv = uv * .5 + vec2(0.5, 0.0);
	float color = texture(sdf, uv).r;
	float sdf_amount = step(sdf_threshold, color);
	float dist = abs(sdf_threshold - color);
	float hatch_falloff = 1.0 - dist / hatch_width;
	float hatch_mask = step(hatch_width, sdf_threshold - color);
	hatch_mask = (1. - sub(hatch_mask, sdf_amount)) * hatch_falloff;
	float hash = hash(UV, hatch_angle, hatch_density, hash_pow);
	float sdf_border = 1.0 - step(sdf_border_width, dist);
	COLOR.rgb = mix(vec3(hash * hatch_mask), vec3(1.0), sdf_border);
}
