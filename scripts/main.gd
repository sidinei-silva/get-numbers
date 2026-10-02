extends Node

@export var number_scene: PackedScene
var score
var screen_size: Vector2
var life = 1
var actual_life = life


var objectives = [
	{
	"text": "Colete os números ímpares",
	"condition": func(number: int) -> bool:
		return number % 2 != 0
		},
	{
	"text": "Colete os números pares",
	"condition": func(number: int) -> bool:
		return number % 2 == 0
			},
	{
	"text": "Colete os números maiores que 5",
	"condition": func(number: int) -> bool:
		return number > 5
		},
	{
	"text": "Colete os números menores que 5",
	"condition": func(number: int) -> bool:
		return number < 5
		}
]



var actual_objective

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport().size
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func signal_catch_number(number: int) -> void:
	if actual_objective["condition"].call(number):
		score += 1
		print("Score: %d" % score)	
	else:
		actual_life -= 1
		print("Life: %d" % actual_life)
		if actual_life <= 0:
			game_over()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$ObjectiveTimer.start()
	select_objective()
	actual_life = life

func game_over():
	print("Game Over")
	$StartTimer.stop()
	$NumberTimer.stop()
	$ObjectiveTimer.stop()
	$Player.stop()
	for number in get_tree().get_nodes_in_group("numbers"):
		number.remove_from_scene()
	print("Final Score: %d" % score)

func _on_start_timer_timeout() -> void:
	$NumberTimer.start()

func _on_number_timer_timeout() -> void:
	# Criar instancia
	var number_instance = number_scene.instantiate()
	var number_half_width = number_instance.get_node("CollisionShape2D").shape.get_rect().size.x / 2
	var random_x = randf_range(number_half_width, screen_size.x - number_half_width)
	number_instance.position.x = random_x
	
	# Adicionando o número à cena
	add_child(number_instance)


func _on_objective_timer_timeout() -> void:
	select_objective()


func select_objective()-> void:
	var random_index = randi() % objectives.size()
	actual_objective = objectives[random_index]
	print("Objective: %s" % actual_objective["text"])
