@tool
extends Node

var rdview:RDTextureView


func _ready() -> void:
	rdview=RDTextureView.new()

func to_rd_float_array(rd:RenderingDevice,input:PackedFloat32Array,binding:int,arr:Array=[[]])->RDUniform:
	var input_bytes := input.to_byte_array()
	var buffer = rd.storage_buffer_create(input_bytes.size(), input_bytes)
	arr[0].append(buffer)
	var uniform := RDUniform.new()
	uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform.binding = binding
	uniform.add_id(buffer)
	return uniform
	
func to_rd_int_array(rd:RenderingDevice,input:PackedInt32Array,binding:int,arr:Array=[[]])->RDUniform:
	var input_bytes := input.to_byte_array()
	var buffer = rd.storage_buffer_create(input_bytes.size(), input_bytes)
	arr[0].append(buffer)
	var uniform := RDUniform.new()
	uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform.binding = binding
	uniform.add_id(buffer)
	return uniform

func empty_buffer(rd:RenderingDevice,size:int,binding:int,arr=[[]])->RDUniform:
	var input_bytes := PackedByteArray([])
	#input_bytes.resize(size)
	var buffer = rd.storage_buffer_create(size,input_bytes)
	arr[0].append(buffer)
	var uniform := RDUniform.new()
	uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform.binding = binding
	uniform.add_id(buffer)
	return uniform

func rd_texture(rd:RenderingDevice, width, height )->RID:
	var texture_format := RDTextureFormat.new()
	texture_format.width = width
	texture_format.height = height
	texture_format.format = RenderingDevice.DATA_FORMAT_R32G32B32A32_SFLOAT
	texture_format.usage_bits = (
	RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT +
	RenderingDevice.TEXTURE_USAGE_STORAGE_BIT +
	RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT +
	RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
	)
	var dat = PackedFloat32Array()
	dat.resize(width*height*4)
	dat.fill(0.5)
	var dat2 = dat.to_byte_array()
	return rd.texture_create(texture_format,rdview,[dat2])
	
func load_shader(rd:RenderingDevice,path:String):
	var shader_spirv:RDShaderSPIRV=load(path).get_spirv()
	var shader:RID=rd.shader_create_from_spirv(shader_spirv)
	if shader_spirv.compile_error_compute!="":
		printerr(path)
		print(shader_spirv.compile_error_compute)
		assert(false)
	return shader
