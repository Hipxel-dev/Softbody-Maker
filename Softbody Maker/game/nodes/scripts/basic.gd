extends Sprite

var connections = []
var parents = []

var vel = Vector2.ZERO
onready var starting_position = position

func _draw() -> void:
	
	for i in connections:
		vel += (i.global_position - position)
		draw_line(Vector2.ZERO, i.global_position - position , Color.white, 1.0)
	for i in range(connections.size()):
		draw_circle(Vector2(cos(i), sin(i)) * 8, 2, Color.white)
	
func _physics_process(delta: float) -> void:
#	modulate = Color.white
	position += vel * delta
	vel += (starting_position - position) 
	vel.y += 6
	vel *= 0.9
	update()
	
	
