extends CharacterBody3D

const HEALTH_BONUS = 12
const ESSENCE_BONUS = 2
const EXPERIENCE_BONUS = 1
const SLIDE_SPEED = 2

@export var move_speed = 15

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var move_to_player = false
var has_hit_floor = false


func _ready():  # Randomize velocities.
	velocity.y = randf_range(0, 2)
	velocity.x = randf_range(-4, 4)
	velocity.z = randf_range(-4, 4)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	else:
		if not has_hit_floor:  # Play sound when hitting floor.
			var drop_sound = ["CollectableOne", "CollectableTwo"].pick_random()
			AudioHandler.play_sound(drop_sound)
			
			# Do not play sound again.
			has_hit_floor = true
		
		if move_to_player:
			move_towards_player(delta)
		
		else:  # Slow to a stop.
			velocity.x = move_toward(velocity.x, 0, SLIDE_SPEED)
			velocity.z = move_toward(velocity.x, 0, SLIDE_SPEED)
		
		# If not animated, play animation.
		if $AnimationPlayer.current_animation != "float":
			$AnimationPlayer.play("float")
	
	move_and_slide()


func collect_health():
	PlayerVars.current_health += HEALTH_BONUS
	if PlayerVars.current_health > PlayerVars.max_health:
		PlayerVars.current_health = PlayerVars.max_health


func collect_essence():
	PlayerVars.essence += ESSENCE_BONUS


func collect_experience():
	PlayerVars.current_exp += EXPERIENCE_BONUS


func _on_collect_area_3d_body_entered(body):
	if body.name == "Player":  # Collectable only by the player.
		
		# Get the right type of collectable function.
		if is_in_group("Health Collectables"):
			collect_health()
		elif is_in_group("Essence Collectables"):
			collect_essence()
		elif is_in_group("Experience Collectables"):
			collect_experience()
		
		queue_free()


func move_towards_player(delta):
	var player = get_parent().get_node("Player")
	
	# Get the direction to the player.
	var direction = (player.global_transform.origin - self.global_transform.origin)
	direction = direction.normalized()
	
	# Move in that direction.
	translate(direction * move_speed * delta)


func _on_move_area_3d_body_entered(body) -> void:
	if body.name == "Player":
		move_to_player = true


func _on_move_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		move_to_player = false
