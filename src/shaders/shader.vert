#version 450

layout(location = 0) in vec4 inPosition;
layout(location = 1) in vec4 inColor;
layout(location = 2) in vec4 inNormal;
layout(location = 3) in vec2 inTexCoord;

layout(set = 0, binding = 0) uniform UBO {
    mat4 proj;
    mat4 view;
    mat4 model;
    float time;
} ubo;

layout(location = 0) out vec4 fragNormal;
layout(location = 1) out vec4 fragColor;
layout(location = 2) out vec2 fragTexCoord;

void main() {
    fragNormal = inNormal;
    fragColor = inColor;
    fragTexCoord = inTexCoord;
    gl_Position = ubo.proj * ubo.view * ubo.model * inPosition;
}
