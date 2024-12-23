#version 120

#define GHOST_RUNNER

#ifdef GHOST_RUNNER
#endif

uniform mat4 gbufferProjection;

uniform int heldItemId;
uniform float frameTimeCounter;

uniform float isHurt;

varying vec4 color;
varying vec2 uv;
varying vec2 lm;

mat4 rotateX(float deg)
{
    float angle = radians(deg);
    float s = sin(angle);
    float c = cos(angle);
    return mat4(
        1.0, 0.0, 0.0, 0.0,
        0.0, c, -s, 0.0,
        0.0, s, c, 0.0,
        0.0, 0.0, 0.0, 1.0
    );
}

mat4 rotateY(float deg)
{
    float angle = radians(deg);
    float s = sin(angle);
    float c = cos(angle);
    return mat4(
        c, 0.0, s, 0.0,
        0.0, 1.0, 0.0, 0.0,
        -s, 0.0, c, 0.0,
        0.0, 0.0, 0.0, 1.0
    );
}

mat4 rotateZ(float deg)
{
    float angle = radians(deg);
    float s = sin(angle);
    float c = cos(angle);
    return mat4(
        c, -s, 0.0, 0.0,
        s, c, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0
    );
}

float katana_anim()
{
    float base = mod(frameTimeCounter, 10.0);
    return base * 2.0 * float(base < 0.5);
}

void main()
{
    if (heldItemId == 5000)
    {
        // FULL OF MAGIC NUMBER
        vec4 pos = rotateX(-10.0) * rotateY(15.0) * rotateZ(-90.0) * gl_ModelViewMatrix * gl_Vertex;
        pos.xyz += vec3(-0.3, -0.7, 0.4);
        pos = rotateY(4.0) * pos;
        pos = rotateX(-katana_anim() * 1080.0) * pos;
        pos = rotateY(-4.0) * pos;
        pos.yz -= vec2(0.2, 0.3);
        pos.y += 0.15 * sin(katana_anim() * 3.1415926);
        pos.z += 0.05;
        gl_Position = gl_ProjectionMatrix * pos;
        gl_Position.xy /= gl_ProjectionMatrix[0][0] / gbufferProjection[0][0];
    }
    else
    {
        gl_Position = ftransform();
    }
    gl_Position.xy *= 1.0 - isHurt * 0.1;
    gl_FogFragCoord = length((gl_ModelViewMatrix * gl_Vertex).xyz);

    color = gl_Color;
    uv = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lm = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
}