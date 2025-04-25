extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 500

var attacking = false

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Apply gravity if not on floor
	if not is_on_floor():
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		sprite.play("jump")

	# Horizontal movement
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	velocity.x = speed * horizontal_direction

	# Flip sprite based on direction
	if horizontal_direction != 0:
		sprite.flip_h = horizontal_direction < 0

	# Attack handling
	if Input.is_action_just_pressed("attack") and is_on_floor():
		sprite.play("attack")
		attacking = true
		velocity.x = 0  # Optional: stop while attacking
	elif is_on_floor():
		if horizontal_direction != 0:
			if not attacking:
				sprite.play("run")
		else:
			if not attacking:
				sprite.play("idle")
	elif not is_on_floor() and not attacking:
		sprite.play("jump")

	move_and_slide()

	print(velocity)

func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "attack":
		attacking = false
