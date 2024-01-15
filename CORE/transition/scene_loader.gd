extends CanvasLayer

var _scene_path : String
var SCENE2D : PackedScene = preload("res://CORE/transition/transition.tscn")
const TRANSITION_RECTANGLE = preload("res://CORE/transition/transition_rectangle.tscn")
var sub_viewport : SubViewport
var rect : TransitionRectangle
var transitioning = false;

func _ready() -> void:
	sub_viewport = SubViewport.new()
	sub_viewport.size = get_viewport().size
	add_child(sub_viewport)
	sub_viewport.add_child(SCENE2D.instantiate())
	rect = TRANSITION_RECTANGLE.instantiate()
	rect.visible = false
	add_child(rect)
	rect.set_viewportA(sub_viewport)

func load_scene(scene_path: String) -> void:
	if transitioning:
		return
	transitioning = true
	rect.visible = true
	rect.play()
	_scene_path = scene_path
	ResourceLoader.load_threaded_request(_scene_path)
	await rect.anim.animation_finished
	check_loading_status()

func check_loading_status() -> void:
	var progress : Array = []
	var status = ResourceLoader.load_threaded_get_status(_scene_path, progress)
	match status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			print("invalid resource '%s'" % _scene_path)
		ResourceLoader.THREAD_LOAD_FAILED:
			print("loading failed")
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			print("loading %d%%" % progress[0])
			await get_tree().create_timer(0.5).timeout
			check_loading_status()
		ResourceLoader.THREAD_LOAD_LOADED:
			var new_scene = ResourceLoader.load_threaded_get(_scene_path).instantiate()
			get_tree().current_scene.queue_free()
			get_tree().root.call_deferred("add_child", new_scene)
			get_tree().set_deferred("current_scene", new_scene)
			rect.play_backwards()
			await rect.anim.animation_finished
			transitioning = false
			rect.visible = false

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	check_loading_status()
