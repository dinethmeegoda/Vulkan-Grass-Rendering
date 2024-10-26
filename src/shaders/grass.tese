#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

layout(location = 0) in vec4 teseV0[];
layout(location = 1) in vec4 teseV1[];
layout(location = 2) in vec4 teseV2[];
layout(location = 3) in vec4 teseUp[];

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

    vec3 v0 = teseV0[0].xyz;
    vec3 v1 = teseV1[0].xyz;
    vec3 v2 = teseV2[0].xyz;

    float orientation = teseV0[0].w;
    float height = teseV1[0].w;
    float width = teseV2[0].w;
    float stiffness = teseUp[0].w;

    // Based off of De Casteljau's algorithm

    vec3 a = v0 + (v1 - v0) * v;
    vec3 b = v1 + (v2 - v1) * v;
    vec3 c = a + (b - a) * v;

    vec3 orientationVec = vec3(cos(orientation), 0, -sin(orientation));

    vec3 c0 = c - width * orientationVec;
    vec3 c1 = c + width * orientationVec;

    vec3 tangent = normalize(b - a);
    vec3 normal = cross(tangent, orientationVec);

    float t = u + v * (0.5 - u);

    vec3 position = c0 + (c1 - c0) * t;
    gl_Position = camera.proj * camera.view * vec4(position, 1.0);

}
