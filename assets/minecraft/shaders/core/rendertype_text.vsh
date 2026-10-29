#version 150
#define VSH
#moj_import <minecraft:fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
uniform sampler2D Sampler2;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;
uniform float GameTime;
out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

#moj_import <minecraft:funtime_profile_animations.glsl>

uniform sampler2D Sampler0;
#moj_import <minecraft:funtime_text_effects.glsl>

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexDistance = fog_distance(Position, FogShape);
    vertexColor = ft_profile_process_color(Color, Sampler0, UV0) * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;

    baseColor = Color;
    lightColor = texelFetch(Sampler2, UV2 / 16, 0);
    applySpheyaPack9();
}
