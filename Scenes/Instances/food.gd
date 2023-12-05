extends CharacterBody2D

func _ready() -> void:
	$Sprite2D.frame = randi_range(0, 71)
