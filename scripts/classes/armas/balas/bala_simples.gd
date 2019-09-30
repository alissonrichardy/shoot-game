

var intervalo = 0.2
var ultimo_disparo = 0
var player
var pre_bala = preload("res://scenes/tiros/tiro_normal.tscn")

func _init(node):
	self.player = node
	pass


func dispara(direcao):
	if ultimo_disparo <= 0:
		cria_tiro(player.get_node("posBala"), direcao)
		ultimo_disparo = intervalo
	pass

func atualiza(delta):
	if ultimo_disparo > 0:
		ultimo_disparo -= delta
	pass
	
func cria_tiro(node, direcao):
	var bala = pre_bala.instance()
	bala.position = node.global_position
	bala.dir = direcao
	player.owner.add_child(bala)
	pass