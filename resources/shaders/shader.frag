#version 300 es

// required to work
precision highp float;

// matched by name
in  vec4 ocolor;

// named freely
out vec4 color;
void main(void) {
    color = ocolor;
}
