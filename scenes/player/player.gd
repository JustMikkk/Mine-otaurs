class_name Player
extends CharacterBody2D

signal break_wall(pos: Vector2i)

const SPEED = 300.0
const ACCELERATION = 0.2
const FRICTION = 0.25

@export var _player_actions: Array[String]

@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var _marker: Sprite2D = $Marker

var ligth_id

func _ready() -> void:
	ligth_id=$"..".register_sensor(self)

func _physics_process(delta: float) -> void:
	var ligth=$"..".get_sensor_data(ligth_id)
	#print(ligth)
	if ligth>-8:
		$AnimatedSprite2D.modulate=Color(0.9,0.9,0.9)
	else:
		$AnimatedSprite2D.modulate=Color(0.1,0.1,0.9)
	if ligth>-8:
		var direction := Input.get_vector(_player_actions[0], _player_actions[1], _player_actions[2], _player_actions[3]).normalized()
		if direction:
			velocity = velocity.lerp(direction.normalized() * SPEED, ACCELERATION)
			_animate(direction.normalized())
			_set_marker_pos(direction)
		else:
			velocity = velocity.lerp(Vector2.ZERO, FRICTION)
		
		if Input.is_action_just_pressed(_player_actions[4]):
			break_wall.emit(_marker.global_position)
		
		_animated_sprite_2d.speed_scale = clamp(velocity.length(), 0, 1)
		
		move_and_slide()


func _set_marker_pos(dir: Vector2) -> void:
	var marker_dir: Vector2i
	
	if abs(dir.x) > abs(dir.y):
		marker_dir = Vector2(1, 0) if dir.x > 0 else Vector2(-1, 0)
	else:
		marker_dir = Vector2(0, 1) if dir.y > 0 else Vector2(0, -1)
	
	_marker.global_position = (Vector2i(global_position) / 128) * 128 + Vector2i.ONE * 64 + marker_dir * 128


func _animate(dir: Vector2) -> void:
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x > 0:
			_animated_sprite_2d.animation = "move_right"
		else:
			_animated_sprite_2d.animation = "move_left"
	else:
		if velocity.y > 0:
			_animated_sprite_2d.animation = "move_down"
		else:
			_animated_sprite_2d.animation = "move_up" 
		
