#@tool
extends Node
class_name MyLigth
@onready var Graphic=$Graphic
@export var trect:TextureRect
var tab_i=[
	[1,1,1,1,1,1,1,1,1,1],
	[1,0,1,1,1,1,1,1,1,1],
	[1,0,1,0,1,1,1,1,1,1],
	[1,0,0,0,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1],

	[1,1,1,1,1,1,1,1,1,1],
	[1,0,1,1,1,1,1,1,1,1],
	[1,0,1,0,1,1,1,1,1,1],
	[1,0,0,0,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1],
	
		[1,1,1,1,1,1,1,1,1,1],
	[1,0,1,1,1,1,1,1,1,1],
	[1,0,1,0,1,1,1,1,1,1],
	[1,0,0,0,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1],

	[1,1,1,1,1,1,1,1,1,1],
	[1,0,1,1,1,1,1,1,1,1],
	[1,0,1,0,1,1,1,1,1,1],
	[1,0,0,0,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1],
	

]

var tab=[

	

]
var rd:RenderingDevice
var rdview:RDTextureView

var Tsize=Vector2i(36,36)*128#Vector2i(500,500)

var sensors=[]
var sensors_data=[]
var lights=[]

func make_tab():
	var mg=$"../Level_maker/MapGenerator"
	tab=[]
	for x in range(mg._map.size()):
		tab.append([])
		for y in range(mg._map[0].size()):
			tab[-1].append(1 if mg._map[y][x] !=0 else 0)


func make_tab_old():
	var sx=tab_i.size()
	var sy=tab_i[0].size()
	var sm=max(sx,sy)
	tab=[]
	for x in range(sm):
		tab.append([])
		for y in range(sm):
			tab[-1].append(1)
	for x in range(sx):
		for y in range(sy):		
			tab[x][y]=tab_i[x][y]
	print("make table ",tab.size()," ",tab[0].size())
	
func register_sensor(n:Node2D):
	var id = sensors.size()
	sensors.append(n)
	sensors_data.append(0)
	return id

func register_ligth(n:Node2D):
	var id = lights.size()
	lights.append(n)
	return id
	
func get_sensor_data(id:int):
	return sensors_data[id]

func upadate_sensors():
	var t=PackedFloat32Array([])
	for sid in range(sensors.size()):
		var s:Node2D=sensors[sid]
		#var posl=$"../TextureRect".to_local(s.global_position)
		t.append(s.global_position.x)
		t.append(s.global_position.y)
	rd.buffer_update(SensorIn[0][0],0,t.size()*4,t.to_byte_array())


func func_to_array(f:Callable,n:int):
	var dat = PackedInt32Array()
	dat.resize(n)
	for i in range(n):
		dat[i]=f.call(i)
	return dat

func func_to_arrayf(f:Callable,n:int):
	var dat = PackedFloat32Array()
	dat.resize(n)
	for i in range(n):
		dat[i]=f.call(i)
	return dat

func init_texture(binding):
	var texture_rid=Graphic.rd_texture(rd,Tsize.x,Tsize.y)
	var texture_godot:Texture2DRD=Texture2DRD.new()
	texture_godot.set_texture_rd_rid(texture_rid)
	trect.texture=texture_godot
	var uniformI = RDUniform.new()
	uniformI.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	uniformI.binding = binding 
	var texture2 := rd.texture_create_shared(rdview,texture_rid)
	uniformI.add_id(texture2)
	return uniformI

var pipeline_ray:RID
var pipeline_disp:RID
var pipeline_disp_clr:RID
var pipeline_sen:RID
var uniform_set:RID

var maze=[[]]
var li_point=[[]]
var SensorIn=[[]]
var SensorData=[[]]

var light_scale_down
var maze_scale_down
var ligth_size_y
var maze_size_y




func init_gpu():
	light_scale_down=(Tsize.x/(5*tab.size()));
	maze_scale_down=(Tsize.x/(tab.size()));
	ligth_size_y=5*tab.size()
	maze_size_y=tab.size()
	
	
	rdview = RDTextureView.new()
	rd = RenderingServer.get_rendering_device()
	var uniformI:RDUniform=init_texture(1)
	var uniformMaze=Graphic.to_rd_int_array(rd,func_to_array(func (n):return tab[n/maze_size_y][n%maze_size_y],maze_size_y*maze_size_y),2,maze)
	var uniformPoint=Graphic.to_rd_float_array(rd, func_to_arrayf(func (n):return 1.5,2*100),3,li_point)
	var uniformLi=Graphic.to_rd_int_array(rd,func_to_array(func (n):return 0.0,ligth_size_y*ligth_size_y),4)
	var uniformInfo=Graphic.to_rd_int_array(rd,PackedInt32Array([
		Tsize.x,
		Tsize.y,
		tab.size(),
		tab[0].size(),
		5*tab.size(),
		5*tab[0].size()
		]),5)
		
	var uniformSensor=Graphic.to_rd_float_array(rd,func_to_arrayf(func (n):return 1.5,2*sensors.size()),6,SensorIn)
	var uniformSensorData=Graphic.to_rd_int_array(rd,func_to_array(func (n):return 0,sensors.size()),7,SensorData)
	
	
	
	var shader_ray:RID=Graphic.load_shader(rd,"res://SH/ray.glsl")
	var shader_disp:RID=Graphic.load_shader(rd,"res://SH/disp.glsl")
	var shader_disp_clr:RID=Graphic.load_shader(rd,"res://SH/disp_clr.glsl")
	var shader_sen:RID=Graphic.load_shader(rd,"res://SH/sensor.glsl")
	
	uniform_set=rd.uniform_set_create([uniformI,uniformMaze,uniformPoint,uniformLi,
	uniformInfo,uniformSensor,uniformSensorData
	
	], shader_ray, 1)
	
	pipeline_ray = rd.compute_pipeline_create(shader_ray)
	pipeline_disp = rd.compute_pipeline_create(shader_disp)
	pipeline_disp_clr = rd.compute_pipeline_create(shader_disp_clr)
	pipeline_sen = rd.compute_pipeline_create(shader_sen)

func _ready() -> void:
	make_tab()
	init_gpu()
	
func reaload_maze():
	rd.buffer_update(maze[0][0],0,4*maze_size_y*maze_size_y,func_to_array(func (n):return tab[n/maze_size_y][n%maze_size_y],maze_size_y*maze_size_y).to_byte_array())

var lx=1.5
var ly=1.5
func reaload_li():
	var a=PackedFloat32Array([lx,ly])
	for l in lights:
		a.append(clamp(l.global_position.x/maze_scale_down,0.0,maze_size_y-1))
		a.append(clamp(l.global_position.y/maze_scale_down,0.0,maze_size_y-1))
		
	rd.buffer_update(li_point[0][0],0,4*a.size(),a.to_byte_array())
	print("reLOAD")
	print(a)


func _process(delta: float) -> void:
	
	if not Engine.is_editor_hint():
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			
			#var p:Vector2=Vector2(get_viewport().get_mouse_position())/maze_scale_down
			var p:Vector2=Vector2($"../TextureRect".get_local_mouse_position())/maze_scale_down
			if tab[int(clamp(p.x,0.0,maze_size_y-1))][int(clamp(p.y,0.0,maze_size_y-1))]!=1:
				lx=clamp(p.x,0.0,maze_size_y-1)
				ly=clamp(p.y,0.0,maze_size_y-1)
			#print(get_viewport().get_mouse_position())
		#lx+=delta*sin(delta)*5.0
	reaload_li()
	if Input.is_action_just_pressed("ui_down"):
		tab_i=[
	[1,1,1,1,1,1,1,1,1,1],
	[1,0,0,0,1,0,0,0,1,1],
	[1,0,1,0,0,0,1,1,1,1],
	[1,0,0,0,1,1,1,1,1,1],
	[1,0,1,1,1,1,1,1,1,1],

	[1,0,1,1,1,1,1,1,1,1],
	[1,0,1,1,1,1,1,1,1,1],
	[1,0,1,0,0,0,0,1,1,1],
	[1,0,0,0,1,1,0,1,1,1],
	[1,1,1,1,1,1,0,1,1,1],
	
	[1,1,1,1,1,1,0,1,1,1],
	[1,0,1,1,1,1,0,1,1,1],
	[1,0,1,0,0,0,0,1,1,1],
	[1,0,0,0,1,1,1,1,1,1],
	[1,1,1,0,1,1,1,1,1,1],

	[1,1,1,0,0,1,1,1,1,1],
	[1,0,1,1,0,1,1,1,1,1],
	[1,0,1,0,0,1,1,1,1,1],
	[1,0,0,0,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1],
	
	
]
		make_tab()
		reaload_maze()
	if Input.is_action_just_pressed("ui_up"):
		tab_i=[
	[1,1,1,1,1,1,1,1,1,1],
	[1,0,1,1,1,1,0,0,0,1],
	[1,0,1,1,1,0,0,0,0,1],
	[1,0,0,1,1,1,0,0,1,1],
	[1,1,1,1,1,1,0,0,0,1],

	[1,1,1,1,1,1,1,0,0,1],
	[1,0,1,1,1,1,1,1,1,1],
	[1,0,1,0,1,1,1,1,1,1],
	[1,0,0,0,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1],
	
	
		[1,1,1,1,1,1,1,1,1,1],
	[1,0,1,1,1,1,1,1,1,1],
	[1,0,1,0,1,1,1,1,1,1],
	[1,0,0,0,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1],

	[1,1,1,1,1,1,1,1,1,1],
	[1,0,1,1,1,1,1,1,1,1],
	[1,0,1,0,1,1,1,1,1,1],
	[1,0,0,0,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1],
	
		
]
		make_tab()
		reaload_maze()
	
	if pipeline_disp_clr:
		
		var compute_list :=rd.compute_list_begin()
		
		
		rd.compute_list_bind_uniform_set(compute_list,uniform_set,1)
		rd.compute_list_bind_compute_pipeline(compute_list,pipeline_disp_clr)
		rd.compute_list_dispatch(compute_list,ligth_size_y,ligth_size_y,1)
		rd.compute_list_add_barrier(compute_list)
		
		
		
		rd.compute_list_bind_uniform_set(compute_list,uniform_set,1)
		rd.compute_list_bind_compute_pipeline(compute_list,pipeline_ray)
		rd.compute_list_dispatch(compute_list,20,1+lights.size(),1)
		rd.compute_list_add_barrier(compute_list)
		print(1+lights.size())
		
	
		
		rd.compute_list_bind_uniform_set(compute_list,uniform_set,1)
		rd.compute_list_bind_compute_pipeline(compute_list,pipeline_disp)
		rd.compute_list_dispatch(compute_list,Tsize.x/4,Tsize.y/4,1)
		rd.compute_list_add_barrier(compute_list)
		
		rd.compute_list_bind_uniform_set(compute_list,uniform_set,1)
		rd.compute_list_bind_compute_pipeline(compute_list,pipeline_sen)
		rd.compute_list_dispatch(compute_list,sensors.size(),1,1)
		rd.compute_list_add_barrier(compute_list)



		rd.compute_list_end()
		
		upadate_sensors()
		
		#print(rd.buffer_get_data(SensorData[0][0],0,4*sensors.size()))
		var a:PackedInt32Array=rd.buffer_get_data(SensorData[0][0],0,4*sensors.size()).to_int32_array()
		sensors_data=Array(a)
		#print(sensors.size())
		#print(a)
	
	
