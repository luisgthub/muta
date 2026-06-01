extends CanvasLayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	final_score()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func final_score():
	$CenterContainer/score.text ="FINAL SCORE: "+str(Gmanager.points)
	
func _on_try_again_pressed() -> void:
	get_tree().paused = false
	Gmanager.points = 0
	get_tree().change_scene_to_file("res://main.tscn")
	self.queue_free()
