#[compute]
#version 450

layout(set = 1, binding = 1, rgba32f) writeonly restrict uniform image2D output_texture;

layout(set = 1, binding = 2, std430) restrict buffer MBuffer {
    int data[];
}maze_buffer;

layout(set = 1, binding = 3, std430) restrict buffer PBuffer {
    vec2 p;
}point_buffer;

layout(set = 1, binding = 4, std430) restrict buffer LBuffer {
    int data[];
}ligth_buffer;

layout(set = 1, binding = 5, std430) restrict buffer IBuffer {
    int img_size_x;
    int img_size_y;
    int maze_size_x;
    int maze_size_y;
    int ligth_size_x;
    int ligth_size_y;
}info_buffer;

layout(set = 1, binding = 6, std430) restrict buffer S1Buffer {
    vec2 data[];
}sensor_buffer;

layout(set = 1, binding = 7, std430) restrict buffer S2Buffer {
    int data[];
}sensor_data_buffer;

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
    ligth_buffer.data[info_buffer.ligth_size_y*(gl_GlobalInvocationID.x)+(gl_GlobalInvocationID.y)]=0;
}
