#version 450

layout(location = 0) in vec4 inPosition;
layout(location = 1) in vec4 inColor;
layout(location = 2) in vec4 inNormal;
layout(location = 3) in vec2 inUV;

layout(set = 0, binding = 0) uniform mat4 view;
layout(set = 0, binding = 1) uniform mat4 proj;
layout(set = 0, binding = 2) uniform float time;

layout(push_constant) uniform mat4 world;

layout(location = 0) out vec4 outNormal;
layout(location = 1) out vec4 outColor;
layout(location = 2) out vec2 outUV;

void main() {
    outNormal = world * inNormal;
    outColor = inColor;
    outUV = inUV;
    gl_Position = proj * view * world * inPosition;
}
