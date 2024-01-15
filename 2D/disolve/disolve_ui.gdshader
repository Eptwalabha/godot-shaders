shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, fract(UV * 2.0));
	COLOR.rg = fract(UV * 2.0);
}
