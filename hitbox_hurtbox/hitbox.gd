extends Area2D
class_name Hitbox

signal impact

@export var dmg := 1
@export var knockback := 0.0
var attacker: Node2D

func _ready() -> void:
	area_entered.connect(_on_impact)
	body_entered.connect(_on_impact)

func _on_impact(target: Node2D):
	impact.emit()
	if not target is Hurtbox:
		return
	target.call(&"hit", self)
