#version 120

uniform float isHurt;

varying vec4 color;
varying vec2 uv;
varying vec2 lm;

void main()
{
    gl_Position = ftransform();
    gl_Position.xy *= 1.0 - isHurt * 0.1;
    gl_FogFragCoord = length((gl_ModelViewMatrix * gl_Vertex).xyz);

    color = gl_Color;
    uv = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lm = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
}