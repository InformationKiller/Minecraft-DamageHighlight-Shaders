#version 120

uniform sampler2D tex;
uniform sampler2D lightmap;

uniform int fogMode;

varying vec4 color;
varying vec2 uv;
varying vec2 lm;

/* DRAWBUFFERS:0 */
void main()
{
    gl_FragData[0] = texture(tex, uv) * texture(lightmap, lm) * color;
}