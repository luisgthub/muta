extends Area2D # Ou Node2D, dependendo de como você criou

func _ready() -> void:
	# 1. Cria o Timer dinamicamente
	var timer = Timer.new()
	timer.wait_time = 3.0 # Tempo que ela fica na tela antes de explodir/sumir
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
	
	# Opcional: Animação de nascimento (ex: escala de 0 para 1)
	self.scale = Vector2.ZERO
	var tween = create_tween()
	# Adicione isso dentro do _ready ou antes do fim do timer

	tween.tween_property(self, "scale", Vector2(2,2), 0.2).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(self, "modulate", Color.RED, 1.0)
func _on_timer_timeout() -> void:
	# Aqui você coloca a lógica do que a bomba faz ao explodir
	print("BOMBA EXPLODIU!")
	$explo.play("explo")
	# Exemplo: dar dano ou chamar o game_over se ainda estiver na tela
	# Gmanager.take_damage(10)
	# Remove a bomba da cena
	queue_free()
