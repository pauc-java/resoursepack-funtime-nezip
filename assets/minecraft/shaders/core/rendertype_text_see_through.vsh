#version 150
#define VSH

in vec3 Position;
in vec4 Color;
in vec2 UV0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec4 vertexColor;
out vec2 texCoord0;

uniform float GameTime;
uniform sampler2D Sampler0;
#moj_import <minecraft:funtime_text_effects.glsl>

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexColor = Color;
    texCoord0 = UV0;

    baseColor = Color;
    lightColor = vec4(1.0);
    applySpheyaPack9();
}
