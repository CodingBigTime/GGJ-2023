shader_type canvas_item;

uniform float amplitude = 3.0F;
uniform float speed = 1.25F;

void vertex() {
	VERTEX.x += amplitude * sin(UV.y * speed * TIME);
}