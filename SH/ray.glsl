#[compute]
#version 450

layout(set = 1, binding = 1, rgba32f) writeonly restrict uniform image2D output_texture;

layout(set = 1, binding = 2, std430) restrict buffer MBuffer {
    int data[];
}maze_buffer;

layout(set = 1, binding = 3, std430) restrict buffer PBuffer {
    vec2 p[];
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

layout(local_size_x = 64, local_size_y = 1, local_size_z = 1) in;
void main() {

    int ligth_size_y=info_buffer.ligth_size_y;
    int maze_size_y=info_buffer.maze_size_y;


    vec2 pos=point_buffer.p[gl_GlobalInvocationID.y];
    vec2 vel=vec2(sin(gl_GlobalInvocationID.x*0.17+0.95),cos(gl_GlobalInvocationID.x*0.17+0.95))*0.03;
    int live=10;
    for(int step=0;step<200;step++){
        vec2 npos=pos+vel;
        ivec2 inpos=ivec2(floor(npos));
        ivec2 inpos2=ivec2(floor(npos*5.0));
        //atomicAdd(ligth_buffer.data[ipos2.x*50+ipos2.y],live);
        
        if ((maze_buffer.data[inpos.x*maze_size_y+inpos.y]==1)&&(step>10)){
            live-=1;
            if(live>0){
                if(floor(pos.x)!=floor(npos.x)){
                    vel=vec2(-vel.x,vel.y);
                    //vel=cos(gl_GlobalInvocationID.x*0.48+live*0.5)*vel+sin(gl_GlobalInvocationID.x*0.48+live*0.5)*vec2(-vel.y,vel.x);
                    //break;
                }
                if(floor(pos.y)!=floor(npos.y)){
                    vel=vec2(vel.x,-vel.y);
                    //break;
                }
            }
            else{
                break;
            }
        }
        else{
            atomicMax(ligth_buffer.data[inpos2.x*ligth_size_y+inpos2.y],live);
            pos=npos;
        }
    }
    barrier();

}
