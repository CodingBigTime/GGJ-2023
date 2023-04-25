shader_type canvas_item;

uniform float amplitude = 2.75F;
uniform float speed = 0.9F;

void vertex() {
	VERTEX.x += amplitude * sin(UV.x + UV.y * TIME * speed)*2.0F;
}