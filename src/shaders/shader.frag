#version 450
layout(binding = 1) uniform sampler2D texSampler;

layout(location = 0) in vec4 fragNormal;
layout(location = 1) in vec4 fragColor;
layout(location = 2) in vec2 fragTexCoord;
layout(location = 0) out vec4 outColor;

void main() {
    vec4 lightDir = normalize(vec4(1.0, 1.0, 1.0, 1.0));
    float brightness = max(dot(normalize(fragNormal), lightDir), 0.0);
    vec4 albedo = texture(texSampler, fragTexCoord);
    vec4 shadedColor = fragColor * brightness * albedo;
    outColor = albedo;
}
