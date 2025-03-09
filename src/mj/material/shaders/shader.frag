#version 450

layout(set = 0, binding = 2) uniform float time;
layout(set = 1, binding = 0) uniform sampler2D albedoSampler;
layout(set = 1, binding = 1) uniform sampler2D metalicSampler;
layout(set = 1, binding = 2) uniform sampler2D roughnessSampler;

layout(location = 0) in vec3 normal;
layout(location = 1) in vec4 color;
layout(location = 2) in vec2 uv;
layout(location = 0) out vec4 outColor;

void main() {
    vec3 lightDir = normalize(vec3(1.0, 1.0, 1.0));
    float brightness = max(dot(normalize(normal), lightDir), 0.0);
    vec4 albedo = texture(albedoSampler, uv);
    vec4 shadedColor = brightness * brightness * albedo;
    outColor = shadedColor;
}
