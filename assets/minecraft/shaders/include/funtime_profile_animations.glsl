/* Profile covers 32, 33, 34. GameTime is the vanilla normalized day fraction. */
const int FT_32_DURATIONS[17] = int[17](40,40,50,40,40,40,40,40,50,40,40,40,40,40,50,40,40);
int ft_32_frame() {
    float t = mod(GameTime * 1200000.0, 710.0);
    for (int i = 0; i < 17; ++i) {
        t -= float(FT_32_DURATIONS[i]);
        if (t < 0.0) return i;
    }
    return 16;
}

const int FT_33_DURATIONS[40] = int[40](100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100);
int ft_33_frame() {
    float t = mod(GameTime * 1200000.0, 4000.0);
    for (int i = 0; i < 40; ++i) {
        t -= float(FT_33_DURATIONS[i]);
        if (t < 0.0) return i;
    }
    return 39;
}

const int FT_34_DURATIONS[7] = int[7](100,100,100,100,100,100,100);
int ft_34_frame() {
    float t = mod(GameTime * 1200000.0, 700.0);
    for (int i = 0; i < 7; ++i) {
        t -= float(FT_34_DURATIONS[i]);
        if (t < 0.0) return i;
    }
    return 6;
}

const int FT_41_DURATIONS[5] = int[5](250,250,250,250,1000);
int ft_41_frame() {
    float t = mod(GameTime * 1200000.0, 2000.0);
    for (int i = 0; i < 5; ++i) {
        t -= float(FT_41_DURATIONS[i]);
        if (t < 0.0) return i;
    }
    return 4;
}

vec4 ft_profile_process_color(vec4 inputColor, sampler2D glyphAtlas, vec2 glyphUv) {
    ivec3 rgb = ivec3(floor(inputColor.rgb * 255.0 + 0.5));
    bool frameColor = rgb.r == 254 && (
        (rgb.g == 166 && rgb.b >= 1 && rgb.b <= 17) ||
        (rgb.g == 167 && rgb.b >= 1 && rgb.b <= 40) ||
        (rgb.g == 168 && rgb.b >= 1 && rgb.b <= 7) ||
        (rgb.g == 169 && rgb.b >= 1 && rgb.b <= 5));
    if (!frameColor) return inputColor;

    // Only matching cover glyphs in minecraft:profile carry this invisible tag.
    // The atlas corner comes from UV, so shared-buffer baseVertex cannot alter it.
    ivec2 atlasSize = textureSize(glyphAtlas, 0);
    ivec2 pixel = clamp(ivec2(glyphUv * vec2(atlasSize)), ivec2(0), atlasSize - 1);
    // BitmapProvider uploads the full 256px cell, not its 176px ink width.
    // Keep tags inside the ink width to preserve the 177px text advance.
    // Map the right cell corners to the existing right-hand tags.
    if (all(equal(atlasSize, ivec2(256))) && pixel.x == 255 &&
        (pixel.y == 0 || pixel.y == 255)) pixel.x = 175;
    ivec4 tag = ivec4(floor(texelFetch(glyphAtlas, pixel, 0) * 255.0 + 0.5));
    if (!all(equal(tag, ivec4(37, rgb.g, rgb.b, 3)))) return inputColor;

    if (rgb.r == 254 && rgb.g == 166 && rgb.b >= 1 && rgb.b <= 17) {
        return vec4(1.0, 1.0, 1.0, ft_32_frame() == rgb.b - 1 ? inputColor.a : 0.0);
    }

    if (rgb.r == 254 && rgb.g == 167 && rgb.b >= 1 && rgb.b <= 40) {
        return vec4(1.0, 1.0, 1.0, ft_33_frame() == rgb.b - 1 ? inputColor.a : 0.0);
    }

    if (rgb.r == 254 && rgb.g == 168 && rgb.b >= 1 && rgb.b <= 7) {
        return vec4(1.0, 1.0, 1.0, ft_34_frame() == rgb.b - 1 ? inputColor.a : 0.0);
    }

    if (rgb.r == 254 && rgb.g == 169 && rgb.b >= 1 && rgb.b <= 5) {
        return vec4(1.0, 1.0, 1.0, ft_41_frame() == rgb.b - 1 ? inputColor.a : 0.0);
    }
    return inputColor;
}
