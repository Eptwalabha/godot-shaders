shader_type canvas_item;

uniform sampler2D sdf : hint_default_black, filter_linear_mipmap_anisotropic, repeat_enable;
uniform float sdf_threshold : hint_range(0.0, 1.0) = 0.5;
uniform float sdf_border_width : hint_range(0.001, 0.25) = 0.01;

uniform vec4 sdf_border_color : source_color;
uniform vec4 sdf_color : source_color = vec4(1.0);
uniform vec4 bg_color: source_color;

void fragment() {
	vec2 uv = fract(vec2(UV.x * 1.778, UV.y) * 3.0);
	vec2 uv1 = uv * .5 + vec2(0.0, 0.0);
	vec2 uv2 = uv * .5 + vec2(0.5, 0.0);

	float morph = (sin(TIME * 2.0) + 1.0) / 2.0;
	float sdf_dist = mix(texture(sdf, uv1).r, texture(sdf, uv2).r, morph);
	float sdf_mask = smoothstep(sdf_threshold, sdf_threshold, sdf_dist);
	COLOR = mix(bg_color, sdf_color, sdf_mask);

	// border
	float border_dist = abs(sdf_threshold - sdf_dist);
	float border_mask = 1.0 - smoothstep(sdf_border_width, sdf_border_width, border_dist);
	COLOR = mix(COLOR, sdf_border_color, border_mask);
}
