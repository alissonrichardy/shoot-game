extends Area2D

var velocidade = 300
var dano = 1
var limite_tela = 100
var posicao_inicial
var dir = -1


func _ready():
	posicao_inicial = position
	pass 

func _physics_process(delta):
	position = position + Vector2(dir,0) * velocidade * delta
	if ( (posicao_inicial.x - position.x) * dir) < -limite_tela:
		print("deu o limite da bala na tela")
		queue_free()
	pass
	
func _body_entered(body):
	print (body.get_groups())
	pass
