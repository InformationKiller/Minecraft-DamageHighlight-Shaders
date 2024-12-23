#version 120

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;

uniform float viewWidth;
uniform float viewHeight;

uniform float frameTime;
uniform float frameTimeCounter;
uniform float aspectRatio;

varying vec2 uv;

vec3 hue2rgb(float hue)
{
  vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
  vec3 p = abs(fract(vec3(hue) + K.xyz) * 6.0 - K.www);
  return clamp(p - K.xxx, 0.0, 1.0);
}

/* DRAWBUFFERS:03 */
void main()
{
    float outline = 0.0;
    float current = texture2D(colortex2, uv).x;

    vec2 dir = (uv - (vec2(0.2 * cos(frameTimeCounter * 6.0) * aspectRatio, 0.2 * sin(frameTimeCounter * 6.0)) * 0.5 + 0.5));

    for(float t = 0.0; t < 1.0; t += 0.1)
    {
        outline += texture2D(colortex2, uv - dir * t * 0.05).x;
    }

    outline /= 10.0;
    outline -= current;
    outline = float(outline > 0.0);

    vec2 offset = 1.0 / vec2(viewWidth, viewHeight);

    float left = texture2D(colortex2, uv + vec2(-offset.x, 0.0)).r;
    float right = texture2D(colortex2, uv + vec2(offset.x, 0.0)).r;
    float top = texture2D(colortex2, uv + vec2(0.0, offset.y)).r;
    float bottom = texture2D(colortex2, uv + vec2(0.0, -offset.y)).r;

    outline += max(max(left, right), max(top, bottom)) - current;
    outline = float(outline > 0.0);

    vec3 center_n = texture2D(colortex1, uv).rgb;
    vec3 left_n = texture2D(colortex1, uv + vec2(-offset.x, 0.0)).rgb;
    vec3 right_n = texture2D(colortex1, uv + vec2(offset.x, 0.0)).rgb;
    vec3 top_n = texture2D(colortex1, uv + vec2(0.0, offset.y)).rgb;
    vec3 bottom_n = texture2D(colortex1, uv + vec2(0.0, -offset.y)).rgb;

    float edge = 0.0;
    edge += distance(center_n, left_n);
    edge += distance(center_n, right_n);
    edge += distance(center_n, top_n);
    edge += distance(center_n, bottom_n);

    outline = mix(outline, 1.0, float(current > 0.0 && edge > 0.01));

    vec4 color = texture2D(colortex0, uv);
    color.rgb = mix(color.rgb, color.rgb * hue2rgb(fract(frameTimeCounter * 0.2)), float(current > 0.0));
    color.rgb = mix(color.rgb, vec3(0.0, 1.0, 1.0), float(outline > 0.0));
    color.r = mix(color.r, 1.0, texture2D(colortex3, vec2(uv.x + sin(frameTimeCounter * 58.0) * 0.01 / aspectRatio, uv.y + cos(frameTimeCounter * 35.0) * 0.01)).r);

    gl_FragData[0] = color;
    gl_FragData[1] = vec4(float(outline > 0.0));
}
