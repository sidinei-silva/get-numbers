extends Node

@export var number_scene: PackedScene
var score
var screen_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport().size
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
	var number_half_width = number_instance.get_node("CollisionShape2D").shape.get_rect().size.x / 2
	var random_x = randf_range(number_half_width, screen_size.x - number_half_width)
	number_instance.position.x = random_x
	
	# Adicionando o número à cena
	add_child(number_instance)
