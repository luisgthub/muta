extends Node2D
@export var scene1: PackedScene
@export var scene2: PackedScene
@export var scene3: PackedScene
@export var scene4: PackedScene
@onready var clickscene = preload("res://groweffect.tscn")
@onready var difscene = preload("res://dificulty.tscn")
var victim_count = 0
@onready var camera = $Camera2D
var victim_limit = 10
var timer = Timer.new()
var random_place = Vector2.ZERO
var x = 0
var y = 0

var victim_array = []
var tempo_total: float = 0.0
func _ready() -> void:
	victim_array = [scene1,scene2,scene3]

	# 1. Configurar o Timer
	timer.wait_time = 3.0        # Tempo em segundos
	timer.one_shot = false       # Faz ele rodar apenas uma vez
	add_child(timer)             # Adiciona como filho do nó atual
	# 2. Conectar o sinal 'timeout' à função 'on_timer_timeout'
	timer.timeout.connect(create_victim)
	# 3. Iniciar o timer
	timer.start()
# --- NOTIFICAÇÃO ---
func create_dificulty():	
	var inst = difscene.instantiate()
	# Adicionamos a cena ao mundo, não como filho direto do vírus 
	# (para que a notificação não se mova junto com o vírus)
	inst.global_position = Vector2(0,0)
	get_tree().current_scene.add_child(inst)
func shake_camera():
	var tween = create_tween()
	tween.tween_property(camera, "offset", Vector2(randf_range(-5, 3), randf_range(-5, 3)), 0.05)
	tween.tween_property(camera, "offset", Vector2.ZERO, 0.03)

func create_bomb():
	var x = randi_range(-120,120)
	var y = randi_range(-120,120)
	var random_place = Vector2(x,y)
	var inst = scene4.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.global_position = random_place
	
func game_over():
	print("derrota")
	get_tree().change_scene_to_file("res://game_over.tscn")
	#get_tree().paused=true
var cot = 0
func increase_dificulty():
# Multiplica por 0.9 (deixando o timer 10% mais rápido a cada etapa)
	timer.wait_time *= 0.9 
	timer.wait_time = max(0.5, timer.wait_time) # Garante que nunca fique abaixo de 0.5s
	print("Dificuldade aumentada! Novo intervalo de spawn: ", timer.wait_time," ",cot)
	cot+=1
func create_victim():
	var qt = randi_range(1,3+cot)
	for i in range(qt):
		
		var rand_victim = victim_array.pick_random()
		x = randi_range(-170,170)	
		y = randi_range(-100,100)
		random_place = Vector2(x,y)
		if rand_victim == null:
			#print("ERRO: O array sorteou um item NULO. Verifique os caminhos dos preloads!")
			return
		var offset = Vector2(randi_range(-40, 40), randi_range(-20, 20))
		var inst = rand_victim.instantiate()
		get_tree().current_scene.add_child(inst)
		inst.global_position = random_place + offset
		groweffect(inst.global_position)


func groweffect(t):
	var inst = clickscene.instantiate()
	# Adicionamos a cena ao mundo, não como filho direto do vírus 
	# (para que a notificação não se mova junto com o vírus)
	add_child(inst)
	inst.global_position = t
	
func _process(delta: float) -> void:
			
		# --- VERIFICA O MARCO DE 5 ---
	if Gmanager.points % 10 == 0 and Gmanager.points!=0:
		shake_camera()
	$Label.text ="FINAL SCORE: "+str(Gmanager.points)
	var victim_count = get_tree().get_nodes_in_group("victim").size()
	
	if victim_count>=victim_limit:
		game_over()
	tempo_total += delta 
	# 2. Aumentar dificuldade (exemplo: a cada 10 segundos, reduz o tempo de espera)
	# Usamos fmod para verificar múltiplos de 10 segundos
	if int(tempo_total) % 20 == 0 and tempo_total > 0:
		victim_limit+=2
		Gmanager.multiplier +=1
		Gmanager.mov_speed = max(5.0,Gmanager.mov_speed-0.5)
		#TESTE
		increase_dificulty()
		if int(tempo_total) >0:
			create_dificulty()
			create_bomb()
		# Adicionamos um pequeno delay no tempo_total para não rodar centenas de vezes por segundo
		tempo_total += 1
	pass
