extends Area2D

signal hit(number: int)

@export var speed: int = 400
var screen_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()  # Hide the player at the start of the game


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta

	var half_width = get_node("CollisionShape2D").shape.get_rect().size.x / 2
	position.x = clamp(position.x, half_width, screen_size.x - half_width)

func _on_area_entered(area: Area2D) -> void:
	$Cesta.z_index = 0
	if not area.has_method("capture"):
		return

	# Borda superior da cesta
	var basket_shape = $CollisionShape2D
	var basket_rect = basket_shape.shape.get_rect()
	var basket_top = basket_shape.to_global(
		Vector2(0, basket_rect.position.y)
	).y

	# Borda inferior do número
	var number_shape = area.get_node("CollisionShape2D")
	var number_rect = number_shape.shape.get_rect()

	var current_bottom = number_shape.to_global(
		Vector2(0, number_rect.end.y)
	).y

	var bottom_offset = current_bottom - area.global_position.y
	var previous_bottom = area.previous_y + bottom_offset

	# Só captura quando a parte inferior atravessa a borda.
	if previous_bottom >= basket_top:
		return

	if current_bottom < basket_top:
		return


	$Cesta.z_index = area.z_index + 1
	var number = area.number
	hit.emit(number)
	area.capture(global_position)



func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
