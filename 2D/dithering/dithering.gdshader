shader_type canvas_item;

uniform sampler2D screen : hint_screen_texture;

const mat4 dither_matrix = mat4(
	vec4(0.0, 0.5, 0.125, 0.625),
	vec4(0.75, 0.25, 0.875, 0.375),
	vec4(0.1875, 0.6875, 0.0625, 0.5625),
	vec4(0.9375, 0.4375, 0.8125, 0.3125)
);

void fragment() {
	vec2 col = texture(screen, SCREEN_UV).ra;
	vec2 dither_coord = mod(FRAGCOORD.xy, vec2(4.0));
	float dither_value = dither_matrix[int(dither_coord.x)][int(dither_coord.y)];
	COLOR = vec4(vec3(float(col.x >= dither_value)), col.y);
}
