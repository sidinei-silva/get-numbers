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
	var number: int = area.number
	hit.emit(number)
	# $CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false