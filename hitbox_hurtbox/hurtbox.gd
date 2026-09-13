extends Area2D
class_name Hurtbox

signal hit_received(hitbox: Hitbox)

func hit(hitbox):
	hit_received.emit(hitbox)
