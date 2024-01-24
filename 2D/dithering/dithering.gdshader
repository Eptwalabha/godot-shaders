shader_type canvas_item;

uniform float dithering_order : hint_range(1.0, 4.0, 1.0) = 2.0;

const mat4 dither_matrix4 = mat4(
	vec4(0.0, 0.5, 0.125, 0.625),
	vec4(0.75, 0.25, 0.875, 0.375),
	vec4(0.1875, 0.6875, 0.0625, 0.5625),
	vec4(0.9375, 0.4375, 0.8125, 0.3125)
);

float grayscale(vec4 color) {
	return 0.3 * color.r + 0.59 * color.g + 0.11 * color.b;
}

void fragment() {
	vec4 pixel_color = texture(TEXTURE, UV);
	float gray = grayscale(pixel_color);
	vec2 dither_coord = mod(FRAGCOORD.xy, vec2(dithering_order));
	float dither_value = dither_matrix4[int(dither_coord.x)][int(dither_coord.y)];
	COLOR = vec4(vec3(float(gray > dither_value)), pixel_color.a);
}
