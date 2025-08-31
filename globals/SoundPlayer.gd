extends Node

var music:AudioStreamPlayer
var fmusic:AudioStreamPlayer
var sound:Array[AudioStreamPlayer]

var torch:TorchLigth
var p:Array[Player]

func _ready() -> void:
	p=[]
	music=AudioStreamPlayer.new()
	self.add_child(music)
	music.stream=load("res://Sounds/free-happy-music-389297.mp3")
	music.volume_db=-40.0
	music.play()
	music.connect("finished",func():
		music.seek(0)
		music.play()
		)


	fmusic=AudioStreamPlayer.new()
	self.add_child(fmusic)
	fmusic.stream=load("res://Sounds/stuck-in-dreams-epic-inspiring-276665.mp3")
	fmusic.play()
	fmusic.volume_db=-40.0
	fmusic.connect("finished",func():
		fmusic.seek(0)
		fmusic.play()
		)

enum Sounds{HIT,DIG,SWORD,HELP,HEAL,SWORD_FLESH}

func make_sound(type:Sounds):
	var s=AudioStreamPlayer.new()
	self.add_child(s)
	if type==Sounds.HIT:
		s.stream=load("res://Sounds/DAMAGE TAKEN.mp3")
		s.volume_db=-10
		s.pitch_scale=1
	if type==Sounds.DIG:
		s.stream=load("res://Sounds/car-crash-sound-376882(1).mp3")
		#s.volume_db=-20
	if type==Sounds.HELP:
		s.stream=load("res://Sounds/086180_help-helpwav-91603.mp3")
		s.volume_db=-25
	if type==Sounds.HEAL:
		s.stream=load("res://Sounds/retro-jump-3-236683.mp3")
		s.volume_db=-5
	if type==Sounds.SWORD:
		s.stream=load("res://Sounds/sword-slice-2-393845.mp3")
		s.volume_db=-5
	if type==Sounds.SWORD_FLESH:
		s.stream=load("res://Sounds/hit-flesh-02-266309.mp3")
		s.volume_db=-5
	s.play()
	s.connect("finished",func():
		s.queue_free()
		)

func _process(delta: float) -> void:
	var stuckState=[Player.State.FROZEN,Player.State.STUN]
	var is_weel=true
	if torch.power<30:
		is_weel=false
	for pl in p:
		if is_instance_valid(pl):
			if pl._current_state in stuckState:
				is_weel=false
	if torch:
		if torch.power>20:
			if is_weel:
				music.volume_db=lerp(music.volume_db,0.0-15,delta*1.1)
				fmusic.volume_db=lerp(fmusic.volume_db,-60.0,delta*1.1)
			else:
				music.volume_db=lerp(music.volume_db,-5.0-15,delta*1.1)
				fmusic.volume_db=lerp(fmusic.volume_db,-10.0,delta*1.1)
		else:
			music.volume_db=-100.0
			fmusic.volume_db=-100.0
