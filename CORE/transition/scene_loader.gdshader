shader_type canvas_item;

uniform sampler2D texture_a : hint_default_white;
uniform sampler2D texture_b : hint_default_black;
uniform float amount : hint_range(0.0, 1.0, 0.01) = 0.0;

void fragment() {
	float x = UV.x * 0.8 + 0.1;
	COLOR.rgb = texture(texture_a, UV).rgb;
	COLOR.a = 1.0 - smoothstep(amount, amount, x + UV.y * .1);
}
