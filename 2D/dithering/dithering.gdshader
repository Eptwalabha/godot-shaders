shader_type canvas_item;

uniform float dithering_order : hint_range(0.0, 3.0, 1.0) = 2.0;
uniform float grayscale_amount : hint_range(0.0, 1.0) = 0.0;

const float[64] dither_pattern = {
	     0.0,      0.5,    0.125,    0.625,  0.03125,  0.53125,  0.15625,  0.65625,
	    0.75,     0.25,    0.875,    0.375,  0.78125,  0.28125,  0.90625,  0.40625,
	  0.1875,   0.6875,   0.0625,   0.5625,  0.21875,  0.71875,  0.09375,  0.59375,
	  0.9375,   0.4375,   0.8125,   0.3125,  0.96875,  0.46875,  0.84375,  0.34375,
	0.046875, 0.546875, 0.171875, 0.671875, 0.015625, 0.515625, 0.140625, 0.640625,
	0.796875, 0.296875, 0.921875, 0.421875, 0.765625, 0.265625, 0.890625, 0.390625,
	0.234375, 0.734375, 0.109375, 0.609375, 0.203125, 0.703125, 0.078125, 0.578125,
	0.984375, 0.484375, 0.859375, 0.359375, 0.953125, 0.453125, 0.828125, 0.328125
};

float dither_value(vec2 coord) {
	return dither_pattern[int(coord.x) + int(coord.y) * 8];
}

float grayscale(vec4 color) {
	return 0.3 * color.r + 0.59 * color.g + 0.11 * color.b;
}

void fragment() {
	vec4 pixel_color = texture(TEXTURE, UV);
	pixel_color.rgb = mix(pixel_color.rgb, vec3(grayscale(pixel_color)), grayscale_amount);
	vec2 coord = mod(FRAGCOORD.xy, vec2(pow(2.0, dithering_order)));
	float dither_value = dither_value(coord);
	COLOR.r = float(pixel_color.r > dither_value);
	COLOR.g = float(pixel_color.g > dither_value);
	COLOR.b = float(pixel_color.b > dither_value);
	COLOR.a = pixel_color.a;
}
