extends Node2D

func _ready():
	$Particles.emitting = true

func _on_particles_finished() -> void:
	queue_free()
