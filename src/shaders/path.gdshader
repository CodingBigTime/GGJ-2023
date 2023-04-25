shader_type canvas_item;

uniform float amplitude = 3.4F;
uniform float speed = 1.5F;

void vertex() {
	VERTEX.x += amplitude * sin(UV.y * speed * TIME);
}