extends CharacterBody2D
@onready var clickscene = preload("res://clickeffect.tscn")
@onready var nscene = preload("res://notify.tscn")
@onready var indicator = $sprite
var target_pos = Vector2.ZERO
var is_moving = false # Mudei para is_moving para ficar mais claro
func _ready() -> void:
	global_position = Vector2.ZERO

func _physics_process(delta: float) -> void:

	# 1. PEGA O ALVO APENAS NO CLIQUE
	if Input.is_action_just_pressed("jump_victim"):
		target_pos = get_global_mouse_position()
		clickeffect(target_pos)
		is_moving = true # Só começa a mover quando clica

	# 2. LÓGICA DE MOVIMENTO
	if is_moving:
		global_position = lerp(global_position, target_pos, Gmanager.mov_speed * delta)
		
		# Para o movimento ao chegar perto
		if global_position.distance_to(target_pos) < 5:
			global_position = target_pos
			is_moving = false
			velocity = Vector2.ZERO

	move_and_slide()

# --- NOTIFICAÇÃO ---
func create_notify(posicao_da_vitima):	
	var inst = nscene.instantiate()
	# Adicionamos a cena ao mundo, não como filho direto do vírus 
	# (para que a notificação não se mova junto com o vírus)
	inst.global_position = posicao_da_vitima 
	get_tree().current_scene.add_child(inst)
func evolve():
	# Define uma escala base (ex: 1.0) e adiciona um fator baseado nos pontos
	# Ex: A cada ponto, o vírus cresce 0.05
	var fator_crescimento = 0.03
	var nova_escala = 1.0 + (Gmanager.points * fator_crescimento)
	var cor_alvo = Color.from_hsv(Gmanager.points * 0.02, 0.8, 1.0) 

	# Limita o tamanho máximo para não cobrir a tela inteira (ex: max 3.0)
	nova_escala = clamp(nova_escala, 1.0, 4.0)
	
	# Aplica a evolução com Tween
	var tween = create_tween()
	# Sorteia uma cor da paleta e aplica
	var paleta = [Color("#ff0000"), Color("#00ff00"), Color("#0000ff")] # Você pode usar códigos HEX
	var cor = paleta.pick_random()

	tween.tween_property(self, "scale", Vector2(nova_escala, nova_escala), 0.5).set_trans(Tween.TRANS_ELASTIC)
	if Gmanager.points % 5 == 0 and Gmanager.points > 0:
		tween.tween_property(self, "modulate", cor, 0.5)
		tween.tween_property(self, "scale", Vector2(nova_escala + 0.2, nova_escala + 0.2), 0.2)
		tween.tween_property(self, "scale", Vector2(nova_escala, nova_escala), 0.2)
func clickeffect(t):
	#sound
	$click.pitch_scale = randf_range(0.9, 1.1)
	$click.stop() 
	$click.play()
	var inst = clickscene.instantiate()
	# Adicionamos a cena ao mundo, não como filho direto do vírus 
	# (para que a notificação não se mova junto com o vírus)
	get_tree().current_scene.add_child(inst)
	inst.global_position = t
	# Exemplo simples de Shake

func on_area_entered(area: Area2D) -> void:
	if area.is_in_group("victim"):
		# Captura a posição antes de deletar o objeto
		var pos_capturada = area.global_position
		create_notify(pos_capturada)
		evolve()
		Gmanager.points+=1

		area.queue_free()
