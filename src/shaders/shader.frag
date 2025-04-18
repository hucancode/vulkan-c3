#version 450

layout(location = 0) in vec4 normal;
layout(location = 1) in vec4 color;
layout(location = 2) in vec2 uv;
layout(location = 0) out vec4 outColor;

layout(set = 0, binding = 1) uniform sampler2D albedoSampler;

void main() {
    vec4 lightDir = normalize(vec4(1.0, 1.0, 1.0, 1.0));
    float brightness = max(dot(normalize(normal), lightDir), 0.0);
    vec4 albedo = texture(albedoSampler, uv);
    vec4 shadedColor = brightness * brightness * albedo;
    outColor = shadedColor;
}
