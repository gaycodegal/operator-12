#version 300 es

in vec3 iposition;
in vec2 itexpos;

uniform mat4 transform;

// matched by name in fragment shader
out vec2 otexpos;

void main(void) {
    // x, y, z, w=1
    gl_Position = transform * vec4(iposition, 1.0f);

    // passthrough
    otexpos = itexpos;
}
