@tool
extends CanvasLayer
class_name Modal

# Simple modal template that slides in from a selected screen edge.
#
# Designed for use with ModalManager:
# - The background overlay is managed by ModalManager.
# - ANIMATION_DURATION is provided by ModalManager.
#
# When used without ModalManager:
# - Add your own background overlay if needed.
# - Replace ModalManager.ANIMATION_DURATION with a local constant.

enum Directions {
	TOP,
	BOTTOM,
	LEFT,
	RIGHT,
}

@export var opening_from := Directions.LEFT
@export var closing_to := Directions.RIGHT
var screen_width: Vector2
var opening_from_pos: Vector2
var closing_to_pos: Vector2
var content_container: Control
var is_closing := false

func _ready() -> void:
	_add_content_container()
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	screen_width = get_viewport().get_visible_rect().size
	opening_from_pos = _get_position_for_direction(opening_from)
	closing_to_pos = _get_position_for_direction(closing_to)
	open()

# ====================================== helper
func _add_content_container():
	content_container = get_node_or_null("ContentContainer") as Control
	if content_container == null:
		content_container = Control.new()
		content_container.name = "ContentContainer"
		content_container.unique_name_in_owner = true
		add_child(content_container)
		content_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		if Engine.is_editor_hint():
			content_container.owner = get_tree().edited_scene_root
	content_container.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _get_position_for_direction(direction: Directions) -> Vector2:
	match direction:
		Directions.TOP:
			return Vector2(0.0, -screen_width.y)
		Directions.BOTTOM:
			return Vector2(0.0, screen_width.y)
		Directions.LEFT:
			return Vector2(-screen_width.x, 0.0)
		Directions.RIGHT:
			return Vector2(screen_width.x, 0.0)
	return Vector2.ZERO

# ====================================== animation
func open():
	content_container.position = opening_from_pos
	await _move_content(Vector2.ZERO, Tween.EASE_OUT)
	return

func close() -> void:
	if is_closing:
		if is_inside_tree():
			await tree_exited
		return
	is_closing = true
	await _move_content(closing_to_pos, Tween.EASE_IN)
	queue_free()
	await tree_exited
	return

func _move_content(target_pos: Vector2, ease_type: Tween.EaseType):
	var t := create_tween()
	t.set_trans(Tween.TRANS_BACK)
	t.set_ease(ease_type)
	t.tween_property(content_container, 'position', target_pos, ModalManager.ANIMATION_DURATION)
	await t.finished
