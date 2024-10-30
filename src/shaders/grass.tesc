#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(vertices = 1) out;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

layout(location = 0) in vec4 tescV0[];
layout(location = 1) in vec4 tescV1[];
layout(location = 2) in vec4 tescV2[];
layout(location = 3) in vec4 tescUp[];

layout(location = 0) out vec4 teseV0[];
layout(location = 1) out vec4 teseV1[];
layout(location = 2) out vec4 teseV2[];
layout(location = 3) out vec4 teseUp[];

in gl_PerVertex {
	vec4 gl_Position;
} gl_in[gl_MaxPatchVertices];

int calculateLOD(vec3 pos, vec3 camPos) {
    float dist = distance(pos, camPos);
    return int(ceil(mix(8, 1, smoothstep(1, 12, dist))));
}

void main() {
	// Don't move the origin location of the patch
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;

    teseV0[gl_InvocationID] = tescV0[gl_InvocationID];
    teseV1[gl_InvocationID] = tescV1[gl_InvocationID];
    teseV2[gl_InvocationID] = tescV2[gl_InvocationID];
    teseUp[gl_InvocationID] = tescUp[gl_InvocationID];

    int lod = calculateLOD(gl_out[gl_InvocationID].gl_Position.xyz, inverse(camera.view)[3].xyz);
    gl_TessLevelInner[0] = lod;
    gl_TessLevelInner[1] = lod;
    gl_TessLevelOuter[0] = lod;
    gl_TessLevelOuter[1] = lod;
    gl_TessLevelOuter[2] = lod;
    gl_TessLevelOuter[3] = lod;
}
