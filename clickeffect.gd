extends Node2D

func _ready() -> void:
	# Cria um Tween para o efeito de "abrindo"
	var tween = create_tween()
	# Expande o círculo e diminui a opacidade ao mesmo tempo
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.3)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.3)
	# Deleta automaticamente após o Tween terminar
	tween.tween_callback(queue_free)
