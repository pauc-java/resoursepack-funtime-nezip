#version 330
#define VSH
#define FT_EXPLICIT_LOCATIONS
#extension GL_ARB_separate_shader_objects : require
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
#include <minecraft:fog.glsl>
#include <minecraft:sample_lightmap.glsl>
#endif
#include <minecraft:dynamictransforms.glsl>
#include <minecraft:projection.glsl>
#include <minecraft:globals.glsl>

layout(location = 0) in vec3 Position;
layout(location = 1) in vec4 Color;
layout(location = 2) in vec2 UV0;
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
layout(location = 3) in ivec2 UV2;
uniform sampler2D Sampler2;
layout(location = 0) out float sphericalVertexDistance;
layout(location = 1) out float cylindricalVertexDistance;
#endif
layout(location = 2) out vec4 vertexColor;
layout(location = 3) out vec2 texCoord0;

#include <minecraft:funtime_profile_animations.glsl>

uniform sampler2D Sampler0;
#include <minecraft:funtime_text_effects.glsl>

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
