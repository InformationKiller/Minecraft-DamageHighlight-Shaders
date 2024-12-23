#version 120

uniform sampler2D tex;
uniform sampler2D lightmap;

uniform vec4 entityColor;
uniform int fogMode;

varying vec4 color;
varying vec3 normals;
varying vec2 uv;
varying vec2 lm;

vec3 binary_color(vec3 c)
{
    float b = c.r * 0.299 + c.g * 0.587 + c.b * 0.114;
    return vec3(floor(b * 3.0) / 2.0);
}

/* DRAWBUFFERS:012 */
void main()
{
    vec4 c = texture2D(tex, uv) * color;

    float hurt = float(entityColor.a > 0.0 && entityColor.b < 0.1);

    gl_FragData[0] = c * texture2D(lightmap, lm);
    gl_FragData[1] = vec4(normals * 0.5 + 0.5, 1.0);
    gl_FragData[2] = vec4(hurt);

    if(fogMode == 9729)
    {
        gl_FragData[0].rgb = mix(gl_Fog.color.rgb, gl_FragData[0].rgb, clamp((gl_Fog.end - gl_FogFragCoord) / (gl_Fog.end - gl_Fog.start), 0.0, 1.0));
    }
    else if(fogMode == 2048)
    {
        gl_FragData[0].rgb = mix(gl_Fog.color.rgb, gl_FragData[0].rgb, clamp(exp(-gl_FogFragCoord * gl_Fog.density), 0.0, 1.0));
    }
    
    gl_FragData[0].rgb = mix(mix(gl_FragData[0].rgb, entityColor.rgb, entityColor.a), binary_color(c.rgb), hurt);
}