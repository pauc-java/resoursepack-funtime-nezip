#ifndef FT_TEXT_EFFECTS_INCLUDED
#define FT_TEXT_EFFECTS_INCLUDED
#ifdef FT_EXPLICIT_LOCATIONS
#define FT_LOC(n) layout(location = n)
#else
#define FT_LOC(n)
#endif
#ifdef VSH
FT_LOC(4) out vec4 baseColor;
FT_LOC(5) out vec4 lightColor;
#else
FT_LOC(4) in vec4 baseColor;
FT_LOC(5) in vec4 lightColor;
#endif
#moj_import <minecraft:funtime_text_utils.glsl>
#moj_import <minecraft:funtime_text_functions.glsl>
bool applyTextEffects() {
    uint vertexColorId = textData.isShadow ? colorId(textData.color) : colorId(floor(textData.color * 255.5 / 4.0) / 255.5);
    switch(vertexColorId >> 8) { 
        case 0xFFFFFFFFu:

    #moj_import <minecraft:text_effects_config.glsl>
    
        return true; 
    } 
    return false;
}

#moj_import <minecraft:funtime_text_impl.glsl>
#endif
