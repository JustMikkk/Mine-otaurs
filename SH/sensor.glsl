#[compute]
#version 450

layout(set = 1, binding = 1, rgba32f) writeonly restrict uniform image2D output_texture;

layout(set = 1, binding = 2, std430) restrict buffer MBuffer {
    int data[];
}maze_buffer;

layout(set = 1, binding = 3, std430) restrict buffer PBuffer {
    vec4 p[];
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
    int sc=info_buffer.img_size_x/info_buffer.ligth_size_x;
    ivec2 maze_pos=ivec2(floor(sensor_buffer.data[gl_GlobalInvocationID.x]/sc));
    //maze_pos=ivec2(7,7);
    int ligth=0;
    for(int x=-3;x<4;x++){
        for(int y=-3;y<4;y++){
            int nligth=ligth_buffer.data[(maze_pos.x+x)*info_buffer.ligth_size_y+(maze_pos.y+y)];
            ligth=max(nligth,ligth);
        }
    }
    
    sensor_data_buffer.data[gl_GlobalInvocationID.x]=ligth;
}