shader_type canvas_item;

uniform float amplitude = 2.75F;
uniform float speed = 0.9F;

void vertex() {
	VERTEX.x += amplitude * cos(UV.x * speed * TIME);
	VERTEX.y += amplitude * sin(UV.y * speed * TIME);
}