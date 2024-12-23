#version 120

uniform sampler2D tex;

uniform float frameTimeCounter;
uniform float isHurt;

varying vec2 uv;

float random(float seed)
{
    return fract(sin(seed * 0.012989) * 43758.5453123);
}

float loop(float x)
{
    x = mix(x, x - 1.0, float(x > 1.0));
    x = mix(x, x + 1.0, float(x < 0.0));
    return x;
}

/* DRAWBUFFERS:0 */
void main()
{
    float a = random(floor(frameTimeCounter * 16.0));
    float b = random(a * 2.0);
    float c = random(b * 3.0);
    float d = random(c * 4.0);
    float e = random(d * 5.0);
    float f = random(e * 6.0);
    float g = random(f * 7.0);

    b = (1.0 - a) * b + a;

    float offset = mix(c, mix(d, e, float(uv.y > b)), float(uv.y > a));
    offset = (offset * 2.0 - 1.0) * 0.15;

    a = texture2D(tex, vec2(loop(uv.x + (offset - f * 0.1) * isHurt), uv.y)).r;
    b = texture2D(tex, vec2(loop(uv.x + offset * isHurt), uv.y)).g;
    c = texture2D(tex, vec2(loop(uv.x + (offset + g * 0.1) * isHurt), uv.y)).b;

    gl_FragData[0] = vec4(a, b, c, 1.0);

    gl_FragData[0].rgb = mix(gl_FragData[0].rgb, mix(gl_FragData[0].rgb, vec3(0.0), clamp(length(uv * 2.0 - 1.0) - 0.3, 0.0, 1.0)), isHurt);
}