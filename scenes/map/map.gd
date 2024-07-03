class_name Map
extends Node2D

const SCROLL_SPEED := 15
const MAP_ROOM = preload("res://scenes/map/map_room.tscn")
const MAP_LINE = preload("res://scenes/map/map_line.tscn")

@onready var visuals: Node2D = $Visuals
@onready var lines: Node2D = %Lines
@onready var rooms: Node2D = %Rooms
@onready var camera_2d: Camera2D = $Camera2D
@onready var map_generator: MapGenerator = $MapGenerator

var map_data: Array[Array]
var floors_claimed: int
var last_room: Room
var camera_edge_y: float


func _ready() -> void:
	camera_edge_y = MapGenerator.Y_DIST * (MapGenerator.FLOORS - 1) #y-size of map


func _input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("scroll_up"):
		camera_2d.position.y -= SCROLL_SPEED
	elif event.is_action_pressed("scroll_down"):
		camera_2d.position.y += SCROLL_SPEED
	
	camera_2d.position.y = clamp(camera_2d.position.y, -camera_edge_y, 0)


func generate_new_map() -> void:
	floors_claimed = 0
	map_data = map_generator.generate_map()
	create_map()


func create_map() -> void:
	#Iterate through all rooms
	for current_floor: Array in map_data:
		for room: Room in current_floor:
			#check is it is valid room
			if room.type != Room.Type.NOT_ASSIGNED:
				_spawn_room(room)
	
	var map_width_pixels := MapGenerator.X_DIST * (MapGenerator.MAP_WIDTH - 1)
	visuals.position.x = (get_viewport_rect().size.x - map_width_pixels) / 2
	visuals.position.y = get_viewport_rect().size.y / 2


func unlock_floor(which_floor: int = floors_claimed) -> void:
	for map_room: MapRoom in rooms.get_children():
		if map_room.room.row == which_floor:
			map_room.available = true


func unlock_next_rooms() -> void:
	for map_room: MapRoom in rooms.get_children():
		if last_room.next_rooms.has(map_room.room):
			map_room.available = true


func show_map() -> void:
	show()
	camera_2d.enabled = true


func hide_map() -> void:
	hide()
	camera_2d.enabled = false


func _spawn_room(room: Room) -> void:
	var new_map_room := MAP_ROOM.instantiate() as MapRoom
	rooms.add_child(new_map_room)
	new_map_room.room = room
	new_map_room.selected.connect(_on_map_room_selected)
	new_map_room.animation_finished.connect(_on_map_room_animation_finished)
	_connect_lines(room)
	
	if room.selected and room.row < floors_claimed:
		new_map_room.show_selected()


func _connect_lines(room: Room) -> void:
	if room.next_rooms.is_empty():
		return
	
	for next: Room in room.next_rooms:
		var new_map_line := MAP_LINE.instantiate() as Line2D
		new_map_line.add_point(room.position)
		new_map_line.add_point(next.position)
		lines.add_child(new_map_line)

#This is needed to disable starting rooms once we selected one
func _on_map_room_selected(room: Room) -> void:
	for map_room: MapRoom in rooms.get_children():
		if map_room.room.row == room.row:
			map_room.available = false
	
	last_room = room
	floors_claimed += 1

func _on_map_room_animation_finished(room: Room) -> void:
	Events.map_exited.emit(room)
