class_name RelicControl
extends Control

const RELIC_PER_PAGE := 5
const TWEEN_SCROLL_DURATION := 0.2

@onready var left_button: TextureButton = %LeftButton
@onready var right_button: TextureButton = %RightButton
@onready var relics: HBoxContainer = %Relics

@onready var page_width = self.custom_minimum_size.x

var num_of_relics := 0
var current_page := 1
var max_page := 0
var tween: Tween
var relics_position: float


func _ready() -> void:
	#Delete all testing relics from UI scene. So we still can keep them for design reasons, but they are deleted in game.
	for relic_ui: RelicUI in relics.get_children():
		relic_ui.free()
	
	relics_position = relics.position.x
	relics.child_order_changed.connect(_on_relics_child_order_changed)
	

#Called when we add or remove relic to recalculade UI stuff
func update() -> void:
	#Safety check for buttons being valid instances.
	#Without this check the game will crash on closing because it calls this method when relics leave scene tree.
	if not is_instance_valid(left_button) or not is_instance_valid(right_button):
		return
	
	num_of_relics = relics.get_child_count()
	max_page = ceili(num_of_relics / float(RELIC_PER_PAGE))
	
	left_button.disabled = current_page <= 1
	right_button.disabled = current_page >= max_page


#Function to animate pagination
func _tween_to(x_position: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(relics, "position:x", x_position, TWEEN_SCROLL_DURATION)


func _on_relics_child_order_changed() -> void:
		update()


func _on_left_button_pressed() -> void:
	if current_page > 1:
		current_page -= 1
		relics_position += page_width
		update()
		_tween_to(relics_position)


func _on_right_button_pressed() -> void:
	if current_page < max_page:
		current_page += 1
		relics_position -= page_width
		update()
		_tween_to(relics_position)
