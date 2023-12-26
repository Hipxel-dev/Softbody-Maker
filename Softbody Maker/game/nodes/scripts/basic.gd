extends Sprite

var connections = []
var parents = []

var selected = false

var vel = Vector2.ZERO
onready var starting_position = position

var health = 100
var blobtex = preload("res://art/blob.png")

var blink = 0.2
var count = 0

func _draw() -> void:
	count += 0.01667
	
	for i in connections:
		vel += (i.global_position - position)
		draw_line((i.global_position - position).normalized() * 5, (i.global_position - position) - (i.global_position - position).normalized() * 5, modulate, 1)
		
#	for i in range(connections.size()): 
#		draw_texture(blobtex, Vector2(sin(i), cos(i)) * 7) 
#		draw_circle(Vector2(cos(i), sin(i)) * 8, 2, Color.white)
	
func _physics_process(delta: float) -> void:
	if selected:
		starting_position += (position - starting_position) * 0.2
		selected = false
			
	position += vel * delta

	vel += (starting_position - position)
	vel *= 0.9
	update() 
	
	
	
	if blink > 0:
		blink -= delta
		modulate = Color8(255,255,255,sin(OS.get_ticks_msec() * 0.1) * 255)
	
	
	if health <= 0:
		health -= delta
		if health < -1:
			queue_free()
	
