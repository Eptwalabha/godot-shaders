shader_type canvas_item;

uniform sampler2D sdf : hint_default_black, filter_linear_mipmap_anisotropic, repeat_enable;
uniform float sdf_threshold : hint_range(0.0, 1.0) = 0.5;
uniform float sdf_border_width : hint_range(0.001, 0.25) = 0.01;

uniform vec4 sdf_border_color : source_color;
uniform vec4 sdf_color : source_color = vec4(1.0);
uniform vec4 smooth_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 bg_color: source_color;

uniform float time_speed : hint_range(0.0, 1.0);
uniform float time_shift : hint_range(0.0, 1.0);
uniform float smin_k : hint_range(0.001, 1.0);

// polynomial smooth min 2 (k=0.1)
// from http://iquilezles.org/articles/smin/
float smin(float a, float b, float k) {
	float h = max(k - abs(a - b), 0.0) / k;
	return min(a, b) - h * h * k * 0.25;
}

void fragment() {
	vec2 uv = vec2(UV.x * 1.778, UV.y) * 3.0;

	float dist = - (sin(TIME * time_speed + time_shift));
	float sdf_dist_a = texture(sdf, uv).r;
	float sdf_dist_b = texture(sdf, uv - vec2(dist, 0.0)).r;
	
	float a = abs(sdf_dist_a - sdf_threshold);
	float b = abs(sdf_dist_b - sdf_threshold);
	float m = smin(a, b, smin_k) + sdf_threshold;
	
	float sdf_smooth_mask = 1.0 - smoothstep(sdf_threshold, sdf_threshold, m);
	float sdf_mask_a = smoothstep(sdf_threshold, sdf_threshold, sdf_dist_a);
	float sdf_mask_b = smoothstep(sdf_threshold, sdf_threshold, sdf_dist_b);
	float sdf_mask = clamp(sdf_mask_a + sdf_mask_b, 0.0, 1.0);
	sdf_smooth_mask = clamp(sdf_smooth_mask - sdf_mask, 0.0, 1.0);
	COLOR = mix(bg_color, sdf_color, sdf_mask);
	COLOR = mix(COLOR, vec4(1.0, 0.0, 0.0, 1.0), sdf_smooth_mask);

	// border
	float border_dist = abs(sdf_threshold - max(sdf_dist_a, sdf_dist_b));
	float border_mask = 1.0 - smoothstep(sdf_border_width, sdf_border_width, border_dist);
	COLOR = mix(COLOR, sdf_border_color, border_mask);
}
