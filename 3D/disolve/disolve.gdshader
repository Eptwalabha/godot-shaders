shader_type spatial;
render_mode depth_prepass_alpha, cull_disabled;

uniform sampler2D gradient : repeat_disable;
uniform sampler2D noise : hint_default_black;
uniform float threshold : hint_range(0.0, 1.0, 0.001);
uniform float burn_size : hint_range(0.0, 0.2, 0.001);
uniform float time_factor : hint_range(0.0, 1.0, 0.001);
uniform vec2 ratio = vec2(1.0);
uniform float scale : hint_range(0.0, 10.0, 0.001) = 1.0;

void fragment() {
	float level = texture(noise, UV * ratio * scale).b;
	float b = fract(threshold + TIME * time_factor);
	float mask = smoothstep(b, b + 0.005, level);
	float v = pow(smoothstep(b, min(1.0, b + burn_size), level), .6);
	ALBEDO = texture(gradient, vec2(v, 0.0)).rgb;
	ALPHA = mask;
}
