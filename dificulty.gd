extends Label
var count = 0
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 50, 0.8)
	
	# 2. Faz o texto sumir (modulate.a é a transparência)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.5)
	
	# 3. Apaga o nó da cena quando o efeito terminar
	tween.tween_callback(queue_free)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
