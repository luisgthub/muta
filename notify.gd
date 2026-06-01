extends Label
var count = 0
func _ready() -> void:
	Gmanager.points += 1*Gmanager.multiplier
	print(count)
	var tween = create_tween()
	text = "+" + str(1+Gmanager.multiplier)
	# 1. Faz o texto subir (move para cima)
		#sound
	$notify.pitch_scale = randf_range(0.9, 1.1)
	# Opcional: Se o som for curto, você pode resetar antes de tocar
	$notify.stop() 
	$notify.play()	
	tween.tween_property(self, "position:y", position.y - 50, 0.5)
	
	# 2. Faz o texto sumir (modulate.a é a transparência)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.5)
	
	# 3. Apaga o nó da cena quando o efeito terminar
	tween.tween_callback(queue_free)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
