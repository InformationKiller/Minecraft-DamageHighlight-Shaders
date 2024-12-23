#version 120

/*
const int colortex1Format = RGB16;
const int colortex2Format = R32F;
const int colortex3Format = R8;
const vec4 colortex3ClearColor = vec4(0.0, 0.0, 0.0, 0.0);
const bool colortex3Clear = false;
*/

uniform sampler2D colortex0;

uniform float frameTimeCounter;
uniform float aspectRatio;

varying vec2 uv;

void main()
{
    gl_FragColor = texture2D(colortex0, uv);
}