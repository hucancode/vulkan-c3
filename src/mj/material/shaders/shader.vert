#version 450

layout(location = 0) in vec4 inPosition;
layout(location = 1) in vec4 inColor;
layout(location = 2) in vec4 inNormal;
layout(location = 3) in vec2 inUV;

layout(set = 0, binding = 0) uniform UBO {
    mat4 proj;
    mat4 view;
    float time;
} engine;
layout(set = 0, binding = 1) uniform mat4 model;

layout(location = 0) out vec4 fragNormal;
layout(location = 1) out vec4 fragColor;
layout(location = 2) out vec2 fragUV;

void main() {
    fragNormal = model * inNormal;
    fragColor = inColor;
    fragUV = inUV;
    gl_Position = engine.proj * engine.view * model * inPosition;
}
