#version 120

uniform float isHurt;

varying vec4 color;

void main()
{
    gl_Position = ftransform();
    gl_Position.xy *= 1.0 - isHurt * 0.1;
    gl_FogFragCoord = length((gl_ModelViewMatrix * gl_Vertex).xyz);

    color = gl_Color;
}