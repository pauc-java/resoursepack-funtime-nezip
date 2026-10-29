#version 330
#define VSH
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:sample_lightmap.glsl>
#endif
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:globals.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
in ivec2 UV2;
uniform sampler2D Sampler2;
out float sphericalVertexDistance;
out float cylindricalVertexDistance;
#endif
out vec4 vertexColor;
out vec2 texCoord0;

#moj_import <minecraft:funtime_profile_animations.glsl>

uniform sampler2D Sampler0;
#moj_import <minecraft:funtime_text_effects.glsl>

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    #if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    vertexColor = ft_profile_process_color(Color, Sampler0, UV0) * sample_lightmap(Sampler2, UV2);
    #else
    vertexColor = ft_profile_process_color(Color, Sampler0, UV0);
    #endif
    texCoord0 = UV0;

    baseColor = Color;
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    lightColor = sample_lightmap(Sampler2, UV2);
#else
    lightColor = vec4(1.0);
#endif
    applySpheyaPack9();
}
