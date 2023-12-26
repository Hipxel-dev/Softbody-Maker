extends Node2D

var node_collections = [preload("res://game/nodes/basic.tscn")]
var index = 0

var nodes = []

var closest_node = self
var closest_node_dist = INF

var selected_node_to_connect = self
var invalid_connection = false


func get_closest_node():
	nodes = get_tree().get_nodes_in_group("node")
	closest_node_dist = INF
	for i in nodes:
		i.modulate = Color.white
		var dist = i.global_position.distance_squared_to(get_global_mouse_position())
		if dist < closest_node_dist:
			closest_node = i
			closest_node_dist = dist
			
func _ready() -> void:
	$closest_select/trail.set_as_toplevel(true)
	
func _physics_process(delta: float) -> void:
	$line.width = 1
	

	if $closest_select/trail.get_point_count() < 5:
		$closest_select/trail.add_point($closest_select.global_position, 5)
	else:
		$closest_select/trail.remove_point(0)
	
	if Input.is_action_pressed("MAKE") or Input.is_action_pressed("CONNECT"):
		$line.show()
	else:
		$line.hide()

	
	$closest_select.modulate = Color.white
	if not Input.is_action_pressed("CONNECT"):
		if Input.is_action_pressed("MAKE"):
			if closest_node != self:
				closest_node.vel += (get_global_mouse_position() - closest_node.position) * 0.1
			$closest_select.position += (get_global_mouse_position() - $closest_select.position) * 0.3
			$preview.position = get_global_mouse_position()
		else:
			$closest_select.position += (closest_node.position - $closest_select.position) * 0.3

		$line.points[0] = $closest_select.position
		$line.points[1] = closest_node.position
		$line.modulate = Color.green
		$closest_select.modulate = Color.green
	else:
		if selected_node_to_connect != closest_node:
			
			$closest_select.position += (closest_node.position - $closest_select.position) * 0.3
			
			if closest_node != self and selected_node_to_connect != self and is_instance_valid(closest_node) and is_instance_valid(selected_node_to_connect):
				if selected_node_to_connect.connections.find(closest_node) == -1 and closest_node.connections.find(selected_node_to_connect) == -1:
					$line.modulate = Color.cyan
					$line.width = 1.5
					$closest_select.modulate = Color.cyan
				else:
					$line.modulate = Color.red
					$closest_select.modulate = Color.red
			if is_instance_valid(selected_node_to_connect):
				$line.points[0] = selected_node_to_connect.position
			$line.points[1] = $closest_select.position
		else:
			$closest_select.position += (get_global_mouse_position() - $closest_select.position) * 0.3
			$line.modulate = Color.darkgray
			$line.points[0] = selected_node_to_connect.position
			$line.points[1] += (get_global_mouse_position() - $line.points[1]) * 0.3
	

	$line2.points[0] = $preview.position
	$line2.points[1] = $closest_select.position
	$preview.position += (get_global_mouse_position() - $preview.position) * 0.3
	if not Input.is_action_pressed("MAKE") and not Input.is_action_just_released("MAKE") and not Input.is_action_pressed("MIDCLICK") or Input.is_action_pressed("CONNECT"):
		get_closest_node()
		$preview.hide()
	elif not Input.is_action_pressed("MIDCLICK"):
		$preview.show()
		
	
	if nodes == []:
		if Input.is_action_just_pressed("MAKE"):
			var node_inst = node_collections[index].instance()
			node_inst.position = get_global_mouse_position()
			get_parent().add_child(node_inst)
	else:
		if Input.is_action_pressed("MIDCLICK") and not Input.is_action_pressed("ui_accept"):
			closest_node.position += (get_global_mouse_position() - closest_node.position) * 0.3
			closest_node.selected = true


		
		if Input.is_action_just_released("MAKE"):
			var node_inst = node_collections[index].instance()
			node_inst.position = get_global_mouse_position()
			
			closest_node.connections.append(node_inst)
			node_inst.connections.append(closest_node)
			get_parent().add_child(node_inst)
			closest_node = node_inst
			

		if Input.is_action_just_pressed("CONNECT"):
			selected_node_to_connect = closest_node
		if Input.is_action_pressed("CONNECT"): 
			selected_node_to_connect.vel += (get_global_mouse_position() - selected_node_to_connect.position) * 0.1
		if Input.is_action_just_released("CONNECT"):
			if closest_node != selected_node_to_connect and selected_node_to_connect.connections.find(closest_node) == -1 and closest_node.connections.find(selected_node_to_connect) == -1:
				selected_node_to_connect.connections.append(closest_node)
				closest_node.connections.append(selected_node_to_connect)
				
		if Input.is_action_pressed("CONNECT") and Input.is_action_pressed("ui_accept"):
			
			for i in range(closest_node.connections.size()):
				closest_node.connections[i].remove_from_group("node")
				closest_node.connections[i].connections = []
				
			closest_node.connections = []
			
			closest_node.remove_from_group("node")
			closest_node.health = 0
			
			closest_node = self
	
		
