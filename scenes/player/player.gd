class_name Player
extends CharacterBody2D

signal break_wall(pos: Vector2i)

enum State {
	FROZEN,
	MOVING,
	ATTACKING,
}

const SPEED = 300.0
const ACCELERATION = 0.2
const FRICTION = 0.25

@export var _player_actions: Array[String]
@export var _has_pickaxe: bool = false

var _current_state: State = State.MOVING
var _facing_dir := Vector2i.DOWN

@onready var _light: MyLigth = get_tree().get_first_node_in_group("myLight")

@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var _marker: Sprite2D = $Marker
@onready var _hitbox: Area2D = $Hitbox

var ligth_id


func _ready() -> void:
	ligth_id = _light.register_sensor(self)


func _physics_process(delta: float) -> void:
	var light = _light.get_sensor_data(ligth_id)
	print("My ligth ",light)
	match _current_state:
		State.FROZEN:
			_animated_sprite_2d.modulate=Color(0.1, 0.1, 0.1)
			
			if light > 9:
				_animated_sprite_2d.modulate = Color.WHITE
				_current_state = State.MOVING
		
		State.MOVING:
			var direction := Input.get_vector(_player_actions[0], _player_actions[1], _player_actions[2], _player_actions[3]).normalized()
			if direction:
				velocity = velocity.lerp(direction.normalized() * SPEED, ACCELERATION)
				_animate(direction.normalized())
				_set_marker_pos()
			else:
				velocity = velocity.lerp(Vector2.ZERO, FRICTION)
			
			_animated_sprite_2d.speed_scale = clamp(velocity.length(), 0, 1)
			if Input.is_action_just_pressed(_player_actions[4]):
				_attack()
				
				if _has_pickaxe:
					await get_tree().create_timer(0.4).timeout
					break_wall.emit(_marker.global_position)
			
			move_and_slide()
			if light <= 9:
				_current_state=State.FROZEN
				#_animated_sprite_2d.stop()
		
		State.ATTACKING:
			if not _animated_sprite_2d.is_playing():
				_animated_sprite_2d.animation = "move_down"
				_animated_sprite_2d.play()
				_current_state = State.MOVING


func take_damage() -> void:
	_animated_sprite_2d.modulate = Color.RED
	await get_tree().create_timer(0.05).timeout
	_animated_sprite_2d.modulate = Color.WHITE


func _attack() -> void:
	var new_degrees: float
	_current_state = State.ATTACKING
	_animated_sprite_2d.speed_scale = 1
	
	match _facing_dir:
		Vector2i.UP:
			new_degrees = -90
			_animated_sprite_2d.animation = "attack_up"
		Vector2i.LEFT:
			new_degrees = 180
			_animated_sprite_2d.animation = "attack_left"
		Vector2i.RIGHT:
			new_degrees = 0
			_animated_sprite_2d.animation = "attack_right"
		Vector2i.DOWN:
			new_degrees = 90
			_animated_sprite_2d.animation = "attack_down"
		
	_animated_sprite_2d.play()
	_hitbox.rotation_degrees = new_degrees


func _set_marker_pos() -> void:
	_marker.global_position = Vector2i(global_position) + _facing_dir * 80


func _animate(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			_facing_dir = Vector2i.RIGHT
			_animated_sprite_2d.animation = "move_right"
		else:
			_facing_dir = Vector2i.LEFT
			_animated_sprite_2d.animation = "move_left"
	else:
		if dir.y > 0:
			_facing_dir = Vector2i.DOWN
			_animated_sprite_2d.animation = "move_down"
		else:
			_facing_dir = Vector2i.UP
			_animated_sprite_2d.animation = "move_up" 
		


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage()
