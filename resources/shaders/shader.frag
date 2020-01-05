#version 300 es

// required to work
precision highp float;

in vec2 otexpos;

uniform sampler2D texSample;

// named freely
out vec4 FragColor;
void main(void) {
    FragColor = texture(texSample, otexpos);
}
