extends Node2D

var pan_pos = Vector2.ZERO
var pan_cam_pos = Vector2.ZERO

var last_window_position = Vector2.ZERO

func _physics_process(delta: float) -> void:
#	OS.window_fullscreen = false
	var spd = 5
	
	if Input.is_action_just_pressed("MIDCLICK"):
		pan_pos = get_global_mouse_position() * spd
		pan_cam_pos = $cam.position 

	if Input.is_action_pressed("MIDCLICK") and Input.is_action_pressed("ui_accept"):
		$cam.position = (pan_pos - (get_global_mouse_position() * spd)+ pan_cam_pos ) 
