extends Area2D

@export var speed := 300.0
var number: int

var previous_y: float

var numbers_assets = [
	preload("res://assets/numbers/0.png"),
	preload("res://assets/numbers/1.png"),
	preload("res://assets/numbers/2.png"),
	preload("res://assets/numbers/3.png"),
	preload("res://assets/numbers/4.png"),
	preload("res://assets/numbers/5.png"),
	preload("res://assets/numbers/6.png"),
	preload("res://assets/numbers/7.png"),
	preload("res://assets/numbers/8.png"),
	preload("res://assets/numbers/9.png")
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	choose_random_number()
	previous_y = global_position.y
	z_index = 0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	previous_y = global_position.y
	global_position.y += speed * delta


func choose_random_number() -> void:
	var random_index = randi() % numbers_assets.size()

	if !numbers_assets[random_index]:
		push_error("No texture found for number: %s" % random_index)
		return

	var texture = numbers_assets[random_index]
	$Sprite2D.texture = texture
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func capture(target_position: Vector2) -> void:
	# Impede que o número seja capturado novamente
	set_physics_process(false)
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	$CollisionShape2D.set_deferred("disabled", true)

	# Anima a entrada na cesta e o desaparecimento
	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(
		self,
		"global_position",
		target_position,
		0.6
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)

	tween.tween_property(
		$Sprite2D,
		"modulate:a",
		0.0,
		0.6
	)

	tween.chain().tween_callback(queue_free)

func remove_from_scene() -> void:
	queue_free()