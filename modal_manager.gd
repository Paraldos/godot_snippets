extends CanvasLayer

# Simple manager for opening and closing Modal scenes.
#
# Intended to be registered as an Autoload named ModalManager:
# - Keeps one modal active at a time.
# - Pauses the game while a modal is open.
# - Manages the background overlay.
# - Provides the shared ANIMATION_DURATION.
#
# Modal scenes must have a root node that inherits from Modal.
#
# Optional: preload frequently used modals here.
# Example:
# var example_modal := preload("uid://example")
# ModalManager.open_modal(ModalManager.example_modal)

const ANIMATION_DURATION = 0.4

@export_group("background")
@export var background_color := Color("Black")
@export var background_opacity := 0.4

var background: ColorRect
var modal: Modal = null
var opening_modal := false
var closing_modal := false

func _ready() -> void:
	_add_background()
	process_mode = Node.PROCESS_MODE_ALWAYS

# Optional: listen for input to close modal
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close_current_modal()

# ================================================== open / close logic
func open_modal(modal_scene: PackedScene, properties: Dictionary = { }) -> void:
	if opening_modal or closing_modal:
		return
	opening_modal = true
	get_tree().paused = true
	await close_current_modal()

	_fade_background(background_opacity)

	modal = modal_scene.instantiate() as Modal
	modal.layer = layer + 1
	for property in properties:
		modal.set(property, properties[property])
	get_tree().current_scene.add_child(modal)
	await modal.open()

	opening_modal = false

func close_current_modal() -> void:
	if modal == null or closing_modal:
		return
	closing_modal = true
	await modal.close()
	modal = null
	if !opening_modal:
		await _fade_background(0.0)
		get_tree().paused = false
	closing_modal = false
	return

# ================================================== background
func _add_background() -> void:
	background = ColorRect.new()
	add_child(background)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.color = background_color
	background.modulate.a = 0.0
	background.mouse_filter = Control.MOUSE_FILTER_STOP
	background.gui_input.connect(_on_click_background)
	background.z_index = -5

func _fade_background(target_alpha: float) -> void:
	var t := create_tween()
	t.tween_property(background, "modulate:a", target_alpha, ANIMATION_DURATION)
	await t.finished

func _on_click_background(event: InputEvent) -> void:
	if not event is InputEventMouseButton or event.button_index != MOUSE_BUTTON_LEFT:
		return
	close_current_modal()
