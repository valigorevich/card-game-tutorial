class_name MapGenerator
extends Node

#We have a grid of nodes with N rows and M columns
#We define a base distance in pixels between rows and columns for visualisation
const X_DIST := 30.0
const Y_DIST := 25.0
#We can add some randomness in grid position to make it look more organic.
const PLACE_RANDOMNESS := 5
#We need to define number of columns and rows we have on a map
const FLOORS := 15
const MAP_WIDTH := 7
#Define a maximum nubmber of paths we want to generate. Some on them can start from same room.
const PATHS := 6
const MINIMUM_STARTING_POINTS := 3
const MAXIMUM_STARTING_POINTS := 4
#Define a base weights of room types that can be generated through map
const MONSTER_ROOM_WEIGHT := 10.0
const CAMPFIRE_ROOM_WEIGHT := 4.0
const SHOP_ROOM_WEIGHT := 2.5
const MIN_FLOOR_CAMPFIRE_APPEAR := 4


@export var battle_stats_pool: BattleStatsPool

#Variable to store accumulated roomtype weights to roll from
var random_room_type_weights = {
	Room.Type.MONSTER: 0.0,
	Room.Type.CAMPFIRE: 0.0,
	Room.Type.SHOP: 0.0
}
#Store total weight
var random_room_type_total_weight := 0
#Store the map as an array of rows. Each of them is an array of rooms.
var map_data: Array[Array]

#Main function to generate map
func generate_map() -> Array[Array]:
	#prepare initial grid
	map_data = _generate_initial_grid()
	#choose starting points
	var starting_points := _get_random_starting_points()
	#iterate through map_data to setup connections (generate paths)
	for j in starting_points:
		var current_j := j
		for i in FLOORS - 1:
			current_j = _setup_connection(i, current_j)
	
	battle_stats_pool.setup()
	
	_setup_boss_room()
	_setup_random_rooms_weights()
	_setup_room_types()
	
	return map_data
	
func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	
	#generate floors
	for i in FLOORS:
		#store rooms on a floor
		var adjacent_rooms: Array[Room] = []
		
		#generate rooms
		for j in MAP_WIDTH:
			var current_room := Room.new()
			var offset := Vector2(randf(), randf()) * PLACE_RANDOMNESS
			current_room.position = Vector2(j * X_DIST, i * -Y_DIST) + offset
			current_room.row = i
			current_room.column = j
			current_room.next_rooms = []
			
			#Boss room has a nont-random Y-position and elevated on grid
			if i == FLOORS - 1:
				current_room.position.y = (i + 1) * -Y_DIST
			#Fill adjacent rooms array
			adjacent_rooms.append(current_room)
			
		result.append(adjacent_rooms)
		
	return result

func _get_random_starting_points() -> Array[int]:
	#we pick random number of unique points
	var unique_points := randi_range(MINIMUM_STARTING_POINTS, MAXIMUM_STARTING_POINTS)
	
	#Populate array of unique ints
	var available_starting_point: Array[int] = []
	for i in MAP_WIDTH:
		available_starting_point.append(i)
	
	#Erase all but unique number of points
	for i in MAP_WIDTH - unique_points:
		var point_to_erase = available_starting_point.pick_random()
		available_starting_point.erase(point_to_erase)
	
	if available_starting_point.size() < PATHS:
		var additional_points: Array[int] = []
		for i in PATHS - available_starting_point.size():
			var point_to_add = available_starting_point.pick_random()
			additional_points.append(point_to_add)
		available_starting_point = available_starting_point + additional_points
	
	return available_starting_point
	
func _setup_connection(i: int, j: int) -> int:
	var next_room: Room
	var current_room := map_data[i][j] as Room
	
	while not next_room or _would_cross_existing_path(i, j, next_room):
		var random_j := randi_range(max(j - 1, 0), min(j + 1, MAP_WIDTH - 1))
		next_room = map_data[i + 1][random_j]
		#When we find a valid next room and it does not cross a path, we break a loop
	
	current_room.next_rooms.append(next_room)
	
	return next_room.column

func _would_cross_existing_path(i: int, j: int, room: Room) -> bool:
	#We need to check if our connection crosses another connection
	#So we take current room coords and check for the next room if there are any crossing from neighbours
	var left_neighbour: Room
	var right_neighbour: Room
	
	if j > 0:
		#check if we not at left edge
		left_neighbour = map_data[i][j - 1]
	if j < MAP_WIDTH - 1:
		#check if we not at right edge
		right_neighbour = map_data[i][j + 1]
	
	#can't cross in right dir if right neighbour goes to left
	if right_neighbour and room.column > j: #next room above right neighbour
		for next_room in right_neighbour.next_rooms: #iterate through right neighbour connections
			if next_room.column < room.column: #connected room has less column than next room
				return true #cross found. Invalid path
	
	#can't cross in left dir if left neighbour goes to right
	if left_neighbour and room.column < j: #next room above left neighbour
		for next_room in left_neighbour.next_rooms: #iterate through left neighbour connections
			if next_room.column > room.column: #connected room has more column than next room
				return true #cross found. Invalid path
	
	return false

func _setup_boss_room() -> void:
	var middle := floori(MAP_WIDTH * 0.5)
	var boss_room := map_data[FLOORS - 1][middle] as Room
	
	#Connect all rooms below Boss room to Boss room
	for j in MAP_WIDTH:
		var current_room = map_data[FLOORS - 2][j] as Room
		if current_room.next_rooms:
			current_room.next_rooms = [] as Array[Room]
			current_room.next_rooms.append(boss_room)
	
	boss_room.type = Room.Type.BOSS
	boss_room.battle_stats = battle_stats_pool.get_random_battle_for_tier(2)

func _setup_random_rooms_weights() -> void:
	random_room_type_weights[Room.Type.MONSTER] = MONSTER_ROOM_WEIGHT
	random_room_type_weights[Room.Type.CAMPFIRE] = CAMPFIRE_ROOM_WEIGHT + random_room_type_weights[Room.Type.MONSTER]
	random_room_type_weights[Room.Type.SHOP] = SHOP_ROOM_WEIGHT + random_room_type_weights[Room.Type.CAMPFIRE]
	
	random_room_type_total_weight = random_room_type_weights[Room.Type.SHOP]

func _setup_room_types() -> void:
	#first floor always a battle
	for room: Room in map_data[0]:
		if room.next_rooms:
			room.type = Room.Type.MONSTER
			room.battle_stats = battle_stats_pool.get_random_battle_for_tier(0)
	
	#9-th floor is always a treasure
	for room: Room in map_data[8]: #should be referenced constant
		if room.next_rooms:
			room.type = Room.Type.TREASURE
	
	#last floor before the boss is always campfire
	for room: Room in map_data[FLOORS - 2]:
		if room.next_rooms:
			room.type = Room.Type.CAMPFIRE
			
	#rest of rooms
	#store reversed map_data
	map_data.reverse()
	for current_floor in map_data: #grab floor
		for room: Room in current_floor: #grab each room
			if room.next_rooms and room.type == Room.Type.NOT_ASSIGNED:
				_set_room_randomly(room) #set random room type
	map_data.reverse()

func _set_room_randomly(room_to_set: Room) -> void:
	#Procedural generation rues:
	#We can't have campfires below certain floor (MIN_FLOOR_CAMPFIRE_APPEAR)
	var campfire_below_min := true
	#We can't have consecutive capfires
	var consecutive_campfire := true
	#We cant have consecutive shops
	var consecutive_shops := true
	
	var type_candidate: Room.Type
	
	#while loop until we meet all rules
	while campfire_below_min or consecutive_campfire or consecutive_shops:
		type_candidate = _get_random_room_type_by_weight() #Get a random Type
		
		var is_campfire := type_candidate == Room.Type.CAMPFIRE
		var has_campfire_parent := _room_has_next_room_of_type(room_to_set, Room.Type.CAMPFIRE)
		var is_shop := type_candidate == Room.Type.SHOP
		var has_shop_parent := _room_has_next_room_of_type(room_to_set, Room.Type.SHOP)
		
		campfire_below_min = is_campfire and room_to_set.row < MIN_FLOOR_CAMPFIRE_APPEAR
		consecutive_campfire = is_campfire and has_campfire_parent
		consecutive_shops = is_shop and has_shop_parent
	
	room_to_set.type = type_candidate
	
	#Set battle stats for MONSTER rooms
	if room_to_set.type == Room.Type.MONSTER:
		var tier_for_monster_room := 0
		if room_to_set.row > 2:
			tier_for_monster_room = 1
		
		room_to_set.battle_stats = battle_stats_pool.get_random_battle_for_tier(tier_for_monster_room)

func _room_has_next_room_of_type(room: Room, type: Room.Type) -> bool:
	for next_room in room.next_rooms:
		if next_room.type == type:
			return true
	
	return false

func _get_random_room_type_by_weight() -> Room.Type:
	var roll := randf_range(0.0, random_room_type_total_weight)
	
	for type: Room.Type in random_room_type_weights:
		if random_room_type_weights[type] > roll:
			return type
			
	return Room.Type.MONSTER
