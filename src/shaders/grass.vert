
#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 1, binding = 0) uniform ModelBufferObject {
    mat4 model;
};

layout(location = 0) in vec4 v0;
layout(location = 1) in vec4 v1;
layout(location = 2) in vec4 v2;
layout(location = 3) in vec4 up;

layout(location = 0) out vec4 tescV0;
layout(location = 1) out vec4 tescV1;
layout(location = 2) out vec4 tescV2;
layout(location = 3) out vec4 tescUp;

out gl_PerVertex {
    vec4 gl_Position;
};

void main() {
	tescV0 = model * v0;
    tescV1 = model * v1;
    tescV2 = model * v2;
    tescUp = up;
    gl_Position = tescV0;
}
