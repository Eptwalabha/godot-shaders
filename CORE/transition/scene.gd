extends Node3D

@export var path : String
@onready var mesh: MeshInstance3D = $MeshInstance3D

func _process(delta: float) -> void:
	mesh.rotate(Vector3.UP, delta * PI)

func _on_next_scene_pressed() -> void:
	SceneLoader.load_scene(path)
