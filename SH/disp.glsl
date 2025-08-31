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


vec3 get_color(ivec2 pid){

    int light_scale_down=(info_buffer.img_size_x/info_buffer.ligth_size_x);
    int maze_scale_down=(info_buffer.img_size_x/info_buffer.maze_size_y);
    int ligth_size_y=info_buffer.ligth_size_y;
    int maze_size_y=info_buffer.maze_size_y;

    vec3 rgb=vec3(0.0);
    
    int ligth_int = ligth_buffer.data[ligth_size_y*(pid.x/light_scale_down)+(pid.y/light_scale_down)];
        float ligth = float(ligth_int);
    if(ligth_int>100){
        int step=300-ligth_int;
        if (step<40){
            rgb = vec3(1.0f,1.0f,1.0f)*(1.2-0.01*float(step));
        }
        else{
            rgb = vec3(1.0f,1.0f,1.0f)*(0.8);
        }
        
    }
    else{
        if(ligth==10.0){
            rgb = vec3(0.7f,0.7f,0.6f);   
        }
        if(ligth<=9.0){
            rgb = vec3(1.0f,0.5f,0.5f)*2.0f/(12.0-ligth);   
        }
    }

        
        return rgb;
}

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;
void main() {

    int light_scale_down=(info_buffer.img_size_x/info_buffer.ligth_size_x);
    int maze_scale_down=(info_buffer.img_size_x/info_buffer.maze_size_y);
    int ligth_size_y=info_buffer.ligth_size_y;
    int maze_size_y=info_buffer.maze_size_y;







    ivec2 pid = ivec2(gl_GlobalInvocationID.x,gl_GlobalInvocationID.y);
    vec3 rgb = vec3(0.0f,0.0f,1.0f);
    
    if (maze_buffer.data[maze_size_y*(pid.x/maze_scale_down)+(pid.y/maze_scale_down)]==-1){
        rgb = vec3(0.5f,0.5f,0.5f);
    }
    else{
        vec3 rgb_00=get_color(ivec2((gl_GlobalInvocationID.x/light_scale_down)*light_scale_down,
        (gl_GlobalInvocationID.y/light_scale_down)*light_scale_down
        ));
        vec3 rgb_10=get_color(ivec2((gl_GlobalInvocationID.x/light_scale_down)*light_scale_down+light_scale_down,(gl_GlobalInvocationID.y/light_scale_down)*light_scale_down
        ));

        vec3 rgb_01=get_color(ivec2((gl_GlobalInvocationID.x/light_scale_down)*light_scale_down,
        (gl_GlobalInvocationID.y/light_scale_down)*light_scale_down+light_scale_down
        ));
        vec3 rgb_11=get_color(ivec2((gl_GlobalInvocationID.x/light_scale_down)*light_scale_down+light_scale_down,(gl_GlobalInvocationID.y/light_scale_down)*light_scale_down+light_scale_down
        ));

        vec3 rgb_0=mix(rgb_00,rgb_10,float(gl_GlobalInvocationID.x%light_scale_down)/light_scale_down);
        vec3 rgb_1=mix(rgb_01,rgb_11,float(gl_GlobalInvocationID.x%light_scale_down)/light_scale_down);
        rgb=mix(rgb_0,rgb_1,float(gl_GlobalInvocationID.y%light_scale_down)/light_scale_down);
        //if(ligth<1000.0){
        //    rgb = vec3(ligth*0.0002,0.0f,0.0f);
        //}
        //else{
        //    rgb = vec3(0.2f+(ligth-1000.0)*0.0001,0.0f,0.0f);
        //}
        
    }
    imageStore(output_texture, pid, vec4(rgb, 1.0));
}
