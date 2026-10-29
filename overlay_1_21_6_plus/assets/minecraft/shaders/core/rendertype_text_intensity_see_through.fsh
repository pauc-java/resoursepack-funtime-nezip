#version 150
#define FSH
#define IS_GRAYSCALE

#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

in vec4 vertexColor;
in vec2 texCoord0;

out vec4 fragColor;

#moj_import <minecraft:globals.glsl>
#moj_import <minecraft:funtime_text_effects.glsl>

void main() {
    vec4 color = texture(Sampler0, texCoord0).rrrr * vertexColor;
    if (applySpheyaPack9()) {
        color = ft_effect_color;
    }
    if (color.a < 0.1) {
        discard;
    }
    fragColor = color * ColorModulator;
}
