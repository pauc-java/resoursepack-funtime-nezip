#version 150
#define FSH

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;

in vec4 vertexColor;
in vec2 texCoord0;

out vec4 fragColor;

uniform float GameTime;
#moj_import <minecraft:funtime_text_effects.glsl>

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor;
    if (applySpheyaPack9()) {
        color = ft_effect_color;
    }
    if (color.a < 0.1) {
        discard;
    }
    fragColor = color * ColorModulator;
}
