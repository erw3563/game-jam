shader_type canvas_item;
render_mode blend_mix;

uniform bool is_hit = false;
uniform vec4 flash_color = vec4(1.0,1.0,1.0,0.3);

void fragment() {
	if (is_hit){
		vec4 tex = texture(TEXTURE, UV);
		COLOR = is_hit ? tex *flash_color : tex;
	}
}