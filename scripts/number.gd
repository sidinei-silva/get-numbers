extends RigidBody2D


@export var speed := 300.0
var number: int

var numbers_assets = {
	"0": preload("res://assets/numbers/0.png"),
	"1": preload("res://assets/numbers/1.png"),
	"2": preload("res://assets/numbers/2.png"),
	"3": preload("res://assets/numbers/3.png"),
	"4": preload("res://assets/numbers/4.png"),
	"5": preload("res://assets/numbers/5.png"),
	"6": preload("res://assets/numbers/6.png"),
	"7": preload("res://assets/numbers/7.png"),
	"8": preload("res://assets/numbers/8.png"),
	"9": preload("res://assets/numbers/9.png")
}

var target_velocity := Vector2(0, 200)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	choose_random_number()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += speed * delta
	pass


func choose_random_number() -> void:
	var random_index = randi() % numbers_assets.size()
	var random_key = numbers_assets.keys()[random_index]
	number = int(random_key)
	var key = str(number)

	if !numbers_assets.has(key):
		push_error("No texture found for key: %s" % key)
		return

	var texture = numbers_assets[key]
	$Sprite2D.texture = texture
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
