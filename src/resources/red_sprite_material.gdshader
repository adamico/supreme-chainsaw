shader_type canvas_item;

void fragment() {
	if (COLOR != vec4(0.0, 0.0, 0.0, 1.0)) {
		COLOR = vec4(1.0, 0.0, 0.0, texture(TEXTURE, UV).a);
	}
}