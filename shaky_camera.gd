extends Camera2D
class_name MainCamera

# Camera with support for globally triggered screen shake.
#
# Requires a SignalsManager containing a shake_camera signal:
# signal shake_camera(strength: float, duration: float)
#
# Trigger a shake from anywhere, e.g.:
# SignalsManager.shake_camera.emit(5.0, 0.2)
#
# Use camera shake sparingly!

var shake_strength: float
var shake_duration: float

func _ready() -> void:
	SignalsManager.shake_camera.connect(_on_shake_camera)

func _process(delta: float) -> void:
	_shake(delta)

func _shake(delta: float) -> void:
	if shake_duration <= 0.0:
		offset = Vector2.ZERO
		return
	shake_duration -= delta
	offset = Vector2(
		randf_range(-shake_strength, shake_strength),
		randf_range(-shake_strength, shake_strength),
	)

func _on_shake_camera(strength := 0.5, duration := 0.2) -> void:
	shake_strength = strength
	shake_duration = duration
