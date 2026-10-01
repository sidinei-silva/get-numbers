extends Node

@export var number_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func signal_catch_number(number: int) -> void:
	print("Caught number: %d" % number)


func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	


func _on_start_timer_timeout() -> void:
	$NumberTimer.start()

func _on_number_timer_timeout() -> void:
	# Criar instancia
	var number_instance = number_scene.instantiate()

	# Escolher um local aleatório para spawnar o numero
	var number_spawn_location = $NumberPath/NumberSpawnLocation
	number_spawn_location.progress_ratio = randf()
	
	# Ajustar a posição do local de spawn para que o numero não saia da tela
	var number_half_width = number_instance.get_node("CollisionShape2D").shape.get_rect().size.x / 2
	var number_path_length = $NumberPath.curve.get_baked_length()
	number_spawn_location.position.x = clamp(number_spawn_location.position.x, number_half_width, number_path_length - number_half_width)

	# Setando a posição do numero para o local de spawn
	number_instance.position = number_spawn_location.position
	
	# Spawnando o numero na cena
	add_child(number_instance)
