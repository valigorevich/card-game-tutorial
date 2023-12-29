#A basic function to shake anything.
extends Node

func shake(thing: Node2D, strength: float, duration := 0.2) -> void:
	if not thing:
		return
	
	var orig_pos := thing.position
	var shake_count := 10
	var tween := create_tween()
	
	for i in shake_count:
		var shake_offset := Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		var target := orig_pos + strength * shake_offset
		#Every even step reset target pos to origiginal pos
		if i % 2 == 0:
			target = orig_pos
		tween.tween_property(thing, "position", target, duration / float(shake_count))
		#Ease out shake strength 25% each step
		strength *= 0.75
	
	tween.finished.connect(func(): thing.position = orig_pos)
