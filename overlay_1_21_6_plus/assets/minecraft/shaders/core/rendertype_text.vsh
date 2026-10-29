#version 150
#define VSH
#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:globals.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
uniform sampler2D Sampler2;
out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

#moj_import <minecraft:funtime_profile_animations.glsl>

uniform sampler2D Sampler0;
#moj_import <minecraft:funtime_text_effects.glsl>

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    vertexColor = ft_profile_process_color(Color, Sampler0, UV0) * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;

    baseColor = Color;
    lightColor = texelFetch(Sampler2, UV2 / 16, 0);
    applySpheyaPack9();
}
