extends Node2D
class_name HitEffect

# shakes and changes the color of a character on hit.
# add a sound effect and/or particle effects if needed.
# add node to a player, enemy or whatever (right under the parent) and acll "play()".

@export var actor: Node2D

@export_group("Shake")
@export var shake_distance := 1.2
@export var shake_duration := 0.05

@export_group("Blink")
@export var blink_color := Color("black")
@export var blink_duration := 0.08

var shake_tween: Tween
var blink_tween: Tween

var original_position: Vector2
var original_modulate: Color

func _ready() -> void:
	if !actor:
		actor = get_parent()
	original_position = actor.position
	original_modulate = actor.modulate

func play() -> void:
	_shake()
	_blink()

func _shake() -> void:
	if shake_tween:
		shake_tween.kill()
	actor.position = original_position
	shake_tween = create_tween()
	shake_tween.set_trans(Tween.TRANS_SINE)
	shake_tween.set_ease(Tween.EASE_IN_OUT)
	shake_tween.tween_property(
		actor,
		"position",
		original_position + Vector2.RIGHT * shake_distance,
		shake_duration,
	)
	shake_tween.tween_property(
		actor,
		"position",
		original_position + Vector2.LEFT * shake_distance,
		shake_duration,
	)
	shake_tween.tween_property(actor, "position", original_position, shake_duration)

func _blink() -> void:
	if blink_tween:
		blink_tween.kill()
	actor.modulate = blink_color
	blink_tween = create_tween()
	blink_tween.tween_property(actor, "modulate", original_modulate, blink_duration)
