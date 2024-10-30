#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs
const vec3 lightPos = vec3(2, 7, 0);

layout(location = 0) in vec4 fs_Pos;
layout(location = 1) in vec3 fs_Nor;
layout(location = 2) in vec2 fs_UV;

layout(location = 0) out vec4 outColor;

float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

#define OCTAVES 6
float fbm (in vec2 st) {
    // Initial values
    float value = 0.0;
    float amplitude = .5;
    float frequency = 0.;
    //
    // Loop of octaves
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * noise(st);
        st *= 2.;
        amplitude *= .5;
    }
    return value;
}

void main() {

    vec3 bottom_Col = vec3(0.0, 0.3, 0.0);
    vec3 top_Col = vec3(0.0, 0.85, 0.0);

    top_Col.x += fbm(fs_Pos.xz * 1.5) * 1.2;

    outColor = vec4(mix(bottom_Col, top_Col, fs_UV.y), 1.0);
}
