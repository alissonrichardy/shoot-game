extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const SPEED = 100
const JUMP_HEIGTH = -280
var anim =""
var nova_anim =""
var double_jump = false
var direcao = 1

enum{LIVE, DIE}
var status = LIVE
var morre_vel
var morre_wt


var motion = Vector2() #variável responsável para controlar o X e Y do player

var tiro_simples = preload("res://scripts/classes/armas/balas/bala_simples.gd")
var armas = [
	tiro_simples.new(self)
	]
	
var arma_atual



func _ready():#serve para iniciar as coisas
	#add_to_group(main_script.GRUPO_PERSONAGEM)
	arma_atual = tiro_simples.new(self)
	pass 


func _physics_process(delta):
	if status == LIVE:
		_move(delta)
	elif status == DIE:
		_morrendo(delta)
		
		#disparo
	if Input.is_action_pressed("ui_shoot"):
		arma_atual.dispara(direcao)
		pass
	arma_atual.atualiza(delta)

func _move(delta):

	motion.y += GRAVITY #força de gravidade
	
	var walk_right = Input.is_action_pressed("ui_right")
	var walk_left = Input.is_action_pressed("ui_left")
	var andando = walk_left || walk_right
	var jump = Input.is_action_just_pressed("ui_jump")
	var jump_stop = Input.is_action_just_released("ui_jump")
	var colidindo_chao = is_on_floor()
	var is_run = Input.is_action_pressed("run")
	
	
	var vel = SPEED
	if is_run:
		vel *= 1.5
	
	if walk_right:
		motion.x = vel
		$sprite.flip_h = false
		direcao = 1
		$posBala.position = Vector2(30,23)
	elif walk_left:
		motion.x = -vel
		$sprite.flip_h = true
		direcao = -1
		$posBala.position = Vector2(2,23)
	else:
		motion.x = 0 

	if colidindo_chao: #está no chao
		if andando:
			nova_anim = "walk"
		else:
			nova_anim = "idle"
	else: #não está no chão
		if motion.y < 0: #pulando
			nova_anim = "jump"
		else: #caindo
			nova_anim = "caindo"

#-----------controle do pulo---------------
	if colidindo_chao:
		double_jump = true
		if jump: #pulo simples
			motion.y = JUMP_HEIGTH
			#musicas_e_sons.tocar_som_pulo_simples()
	elif jump_stop && motion.y < 0: #controla a intensidade do pulo simples
		motion.y *= 0.5
	
	if double_jump && jump && !colidindo_chao: #pulo duplo
		motion.y = JUMP_HEIGTH
		#musicas_e_sons.tocar_som_pulo_duplo()
		double_jump = false
#-----------controle do pulo---------------
	
	if anim != nova_anim: 
		$anim.play(nova_anim)
		anim = nova_anim
		pass
	
	
	#Funciona sem atribuir a funcao para a variavel motion, porem quando o player cai, fica bugado
	motion = move_and_slide(motion, UP) #função responsável para movimentar o player

func _morrendo(delta):
	var extra
	if morre_wt > 0:
		morre_wt -= delta
	else:
		move_and_collide(morre_vel * delta)
		morre_vel +=  Vector2(0,2)

func _on_cabeca_body_entered(body):
	if body.has_method("destroi"):
		body.destroi()

func _on_pes_body_entered(body):
	if body.has_method("dano"):
		body.dano(1)
		motion.y = JUMP_HEIGTH
		$sound.play()
		pass

func die():
	if status == LIVE:
		#main_script.emit_signal("personagem_morto")
		$shape.queue_free()
		$pes/shape.queue_free()
		morre_vel = Vector2(0, -80)
		morre_wt = 1
		status = DIE
		$anim.play("caindo")
		#musicas_e_sons.tocar_som_dead()
		$timer_respaw.start()
		#owner.get_node("music").stop()


func _on_timer_respaw_timeout():
	"""
	if main_script.lifes > 0:
		get_tree().reload_current_scene()
	else:
		print("voltar ao menu")
		main_script.trocar_fase(0)
		pass
	"""
	pass
