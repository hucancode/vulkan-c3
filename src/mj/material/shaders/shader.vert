#version 450

layout(location = 0) in vec4 inPosition;
layout(location = 1) in vec4 inColor;
layout(location = 2) in vec4 inNormal;
layout(location = 3) in vec2 inUV;

layout(set = 0, binding = 0) uniform SceneUBO {
    mat4 camera_proj;
    mat4 camera_view;
    float time;
} scene;
layout(set = 0, binding = 1) uniform mat4 model;

layout(location = 0) out vec4 outNormal;
layout(location = 1) out vec4 outColor;
layout(location = 2) out vec2 outUV;

void main() {
    outNormal = model * inNormal;
    outColor = inColor;
    outUV = inUV;
    gl_Position = scene.camera_proj * scene.camera_view * model * inPosition;
}
