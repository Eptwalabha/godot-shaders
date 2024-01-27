shader_type canvas_item;

uniform sampler2D sdf : hint_default_black, filter_linear_mipmap_anisotropic, repeat_enable;
uniform float sdf_threshold : hint_range(0.0, 1.0) = 0.5;
uniform float sdf_border_width : hint_range(0.001, 0.25) = 0.015;
uniform vec4 sdf_outer_border_color : source_color;
uniform vec4 sdf_inner_border_color : source_color;
uniform vec4 sdf_color : source_color;
uniform vec4 bg_color: source_color;

uniform float uv_shift : hint_range(0.0, 1.0) = 0.0;

uniform vec2 uv_shadow_shift = vec2(0.0);
uniform float shadow_size : hint_range(0.0, 1.0) = 0.15;
uniform vec4 shadow_color : source_color;

const float screen_ratio = 1.778;

float opSub(float distA, float distB) {
	return distA * (1.0 - distB);
}

float opIntersect(float distA, float distB) {
	return distA * distB;
}

void fragment() {
	vec2 uv = fract(vec2(UV.x * screen_ratio, UV.y) * 2.0);
	float sdf_dist = texture(sdf, uv).r;
	float sdf_mask = step(sdf_threshold, sdf_dist);
	COLOR = mix(bg_color, sdf_color, sdf_mask);
	
	// shadows
	sdf_dist = texture(sdf, uv - uv_shadow_shift).r;
	float shadow_mask = smoothstep(shadow_size, 0.0, sdf_threshold - sdf_dist);
	shadow_mask = opSub(shadow_mask, sdf_mask);
	COLOR = mix(COLOR, shadow_color, shadow_mask);
	
	// borders
	sdf_dist = texture(sdf, uv + uv_shift).r;
	float border_dist = sdf_threshold - sdf_dist;
	float border_mask = 1.0 - step(sdf_border_width, abs(border_dist));
	float outer_border_mask = opSub(border_mask, sdf_mask);
	float inner_border_mask = opIntersect(border_mask, sdf_mask);
	COLOR = mix(COLOR, sdf_outer_border_color, outer_border_mask);
	COLOR = mix(COLOR, sdf_inner_border_color, inner_border_mask);
}
