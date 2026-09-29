extends CharacterBody2D

@export var speed: float = 400

func get_input():
	var input_direction = Input.get_axis("left", "right")
	velocity.x = input_direction * speed
	
func limit_player_position():
	var screen_size = get_viewport_rect().size.x
	var half_width = get_node("CollisionShape2D").shape.get_rect().size.x / 2
	position.x = clamp(position.x, half_width, screen_size - half_width)

func _physics_process(_delta):
	get_input()
	move_and_slide()
	limit_player_position()
