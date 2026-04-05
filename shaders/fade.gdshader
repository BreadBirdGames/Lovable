shader_type canvas_item;

uniform float fade_width = 0.995;
uniform float threshold = 0.5;
uniform bool flip = false;

void fragment() {
	float px = 1.0;
	
	if (flip) {
		px = UV.x / (fade_width + threshold);
	} else {
		px = (1.0 - UV.x) / (fade_width + threshold);
	}
	COLOR.w *= px;
}
