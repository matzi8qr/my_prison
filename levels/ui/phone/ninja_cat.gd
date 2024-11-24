extends CharacterBody2D


const JUMP_VELOCITY = -600.0
const DEFLECT_VELOCITY = -600.0

const CAT_SPAWN_POINT = Vector2(91, 420)

signal dash
signal you_lose
var paused = true

enum CatState {RUN, INAIR, DASH}
var state = CatState.INAIR

var can_dash = true


func _ready():
	$NinjaSprite.animation = "run"
	$NinjaSprite.play()
	


func _physics_process(delta: float) -> void:
	if paused:
		$NinjaSprite.animation = "sit"
		return
	
	match state:
		CatState.RUN:
			if not is_on_floor(): 
				state = CatState.INAIR
				_set_in_air_anim()
		CatState.INAIR:
			velocity += get_gravity() * delta
			_set_in_air_anim()
			_check_for_landing()
			if position.y > get_viewport_rect().size.y:
				you_lose.emit()
		CatState.DASH:
			$SwordHitbox/SwordCapsule2D.disabled = false

	# Handle jump.
	if Input.is_action_just_pressed("interact"):
		if state == CatState.RUN:
			_jump()
		elif can_dash:
			_dash_n_slash()
		

	move_and_slide()
	
	
func _jump() -> void:
	velocity.y += JUMP_VELOCITY
	$NinjaSprite.animation = "jump"
	$NinjaSprite.play()
	
	
func _dash_n_slash() -> void:
	state = CatState.DASH
	can_dash = false
	velocity.y = 0
	$NinjaSprite.animation = "dash"
	$NinjaSprite.play()
	dash.emit()
	

func _set_in_air_anim() -> void:
	if state == CatState.INAIR:
		if velocity.y > 0:
			$NinjaSprite.animation = "in_air_down"
		else:
			$NinjaSprite.animation = "in_air_up"
		

func _check_for_landing() -> void:
	if is_on_floor() && state == CatState.INAIR:
		state = CatState.RUN
		can_dash = true
		$NinjaSprite.animation = "land"
		$NinjaSprite.play()

func _on_ninja_sprite_animation_finished() -> void:
	$SwordHitbox/SwordCapsule2D.disabled = true
	if is_on_floor():
		state = CatState.RUN
		$NinjaSprite.animation = "run"
		$NinjaSprite.play()
	else:
		state = CatState.INAIR
		_set_in_air_anim()


func _on_map_scroller_pause() -> void:
	paused = true


func _on_map_scroller_unpause() -> void:
	paused = false
	$NinjaSprite.animation = "run"
	$NinjaSprite.play()


func _on_sword_hitbox_area_entered(area: Area2D) -> void:
	_on_deflect()


func _on_deflect() -> void:
	state = CatState.INAIR
	velocity.y += DEFLECT_VELOCITY
	can_dash = true
	$NinjaSprite.animation = "jump"
	$NinjaSprite.play()


func _on_you_lose() -> void:
	state = CatState.INAIR
	$NinjaSprite.animation = "sit"
	paused = true
	position = CAT_SPAWN_POINT
