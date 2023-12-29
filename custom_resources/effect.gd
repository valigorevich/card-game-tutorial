class_name Effect
extends RefCounted

var sound: AudioStream

#A virtual function for every effect that must be defined in subclasses
func execute(_targets: Array[Node]) -> void:
	pass

#based on this abstract class we will create different subclasses with different effects.
#RefCounted means that all instances ofthis class will be destroyed in memory if there are no references.
