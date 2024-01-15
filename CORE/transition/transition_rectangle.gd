class_name TransitionRectangle
extends ColorRect

@onready var anim: AnimationPlayer = $AnimationPlayer

func set_viewportA(viewport: Viewport) -> void:
	material.set("shader_parameter/texture_a", viewport.get_texture())

func set_viewportB(viewport: Viewport) -> void:
	material.set("shader_parameter/texture_b", viewport.get_texture())

func play() -> void:
	visible = true
	anim.play("fade")

func play_backwards() -> void:
	anim.play_backwards("fade")
