#version 300 es

// attribute index 0
in vec3 iposition;
// attribute index 1
in vec4 icolor;

// matched by name in fragment shader
out vec4 ocolor;

void main(void) {
    // x, y, z, w=1
    gl_Position = vec4(iposition.x, iposition.y, iposition.z, 1.0);

    // color passthrough
    ocolor = icolor;
}
