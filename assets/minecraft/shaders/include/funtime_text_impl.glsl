

#ifdef FSH
vec4 ft_effect_color;
FT_LOC(6) flat in float vctfx_applyTextEffect;
FT_LOC(7) flat in float vctfx_isShadow;
FT_LOC(8) flat in float vctfx_isGui;
FT_LOC(9) flat in float vctfx_changedScale;

FT_LOC(10) in vec4 vctfx_screenPos;
FT_LOC(11) in vec3 vctfx_viewPos;
FT_LOC(12) in vec2 vctfx_faceCoord;
FT_LOC(13) in float vctfx_side;

FT_LOC(14) in vec3 vctfx_t0;
FT_LOC(15) in vec3 vctfx_t1;
FT_LOC(16) in vec3 vctfx_p0;
FT_LOC(17) in vec3 vctfx_p1;
FT_LOC(18) in vec4 vctfx_vp0;
FT_LOC(19) in vec4 vctfx_vp1;
FT_LOC(20) in vec4 vctfx_vp2;

bool applySpheyaPack9() {
    textData.uv = vec2(0.0);
    textData.color = vec4(0.0);
    textData.alpha = 1.0;
    textData.overlayColor = vec4(0.0);
    textData.backColor = vec4(0.0);
    textData.shouldScale = false;
    textData.uvMin = vec2(0.0);
    textData.uvMax = vec2(1.0);
    textData.uvCenter = vec2(0.5);
    textData.position = vec2(0.0);
    textData.characterPosition = vec2(0.0);
    textData.localPosition = vec2(0.0);
    textData.isShadow = false;

    if(vctfx_applyTextEffect < 0.5) return false;
    
    vec4 textureSample = vec4(0.0);
    if(vctfx_changedScale < 0.5) {
        textureSample = ft_text_sample(texCoord0);
        if(textureSample.a < 0.1) discard;
    }

    vec2 pMin = min(vctfx_p0.xy / vctfx_p0.z, vctfx_p1.xy / vctfx_p1.z);
    vec2 pMax = max(vctfx_p0.xy / vctfx_p0.z, vctfx_p1.xy / vctfx_p1.z);
    vec3 vp0 = vctfx_vp0.xyz / vctfx_vp0.w;
    vec3 vp1 = vctfx_vp1.xyz / vctfx_vp1.w;
    vec3 vp2 = vctfx_vp2.xyz / vctfx_vp2.w;
    textData.uvMin = min(vctfx_t0.xy / vctfx_t0.z, vctfx_t1.xy / vctfx_t1.z);
    textData.uvMax = max(vctfx_t0.xy / vctfx_t0.z, vctfx_t1.xy / vctfx_t1.z);
    textData.uvCenter = (textData.uvMin + textData.uvMax) * 0.5;

    vec3 up = vp2 - vp1;
    vec3 left = vp2 - vp0;
    vec3 origin = vp0 - up;
    if(vctfx_side == 0.0) {
        vec3 tmp = up;
        up = -left;
        left = -tmp;
    }
    vec2 lenSq = vec2(dot(left, left), dot(up, up));

    if(vctfx_changedScale > 0.5) {
        textData.localPosition = (vctfx_screenPos.xy - pMin) / (pMax - pMin);
        textData.localPosition.y = 1.0 - textData.localPosition.y;
        textData.uv = textData.uvMin + (textData.uvMax - textData.uvMin) * textData.localPosition;
    }else{
        textData.localPosition = vctfx_faceCoord;
        textData.uv = texCoord0;
    }


    if((abs(up.x) < 0.0001 && abs(up.z) < 0.0001 && abs(left.y) < 0.0001 && abs(up.z) < 0.0001) || vctfx_isGui > 0.5) {
        textData.characterPosition = 0.5 * (pMax + pMin) * (textData.uvMax - textData.uvMin) * 256.0 / (pMax - pMin);
        textData.position = vctfx_screenPos.xy * (textData.uvMax - textData.uvMin) * 256.0 / (pMax - pMin);
    }else{
        textData.characterPosition = vec2(dot(left, origin), dot(up, origin)) * (textData.uvMax - textData.uvMin) * 256.0 / lenSq;
        textData.position =  vec2(dot(left, vctfx_viewPos), dot(up, vctfx_viewPos)) * (textData.uvMax - textData.uvMin) * 256.0 / lenSq;
    }

    textData.isShadow = vctfx_isShadow > 0.5;
    textData.color = vec4(baseColor.rgb, 1.0);
    textData.alpha = baseColor.a;

    if(vctfx_isShadow > 0.5)
        textData.characterPosition += vec2(-1, +1);

    applyTextEffects();
    if(vctfx_changedScale > 0.5)
        if(uvBoundsCheck(textData.uv, textData.uvMin, textData.uvMax))
            textureSample = ft_text_sample(textData.uv);

    ft_effect_color = textData.color * textureSample;
    ft_effect_color = vec4(mix(textData.backColor.rgb, ft_effect_color.rgb, ft_effect_color.a), 1.0 - (1.0 - ft_effect_color.a) * (1.0 - textData.backColor.a));
    ft_effect_color.a *= textData.alpha;
    ft_effect_color.rgb = mix(ft_effect_color.rgb, textData.overlayColor.rgb, textData.overlayColor.a);
    ft_effect_color *= lightColor;

    if(ft_effect_color.a == 0.0) discard;
    return true;
}
#endif

#ifdef VSH
FT_LOC(6) flat out float vctfx_applyTextEffect;
FT_LOC(7) flat out float vctfx_isShadow;
FT_LOC(8) flat out float vctfx_isGui;
FT_LOC(9) flat out float vctfx_changedScale;

FT_LOC(10) out vec4 vctfx_screenPos;
FT_LOC(11) out vec3 vctfx_viewPos;
FT_LOC(12) out vec2 vctfx_faceCoord;
FT_LOC(13) out float vctfx_side;

FT_LOC(14) out vec3 vctfx_t0;
FT_LOC(15) out vec3 vctfx_t1;
FT_LOC(16) out vec3 vctfx_p0;
FT_LOC(17) out vec3 vctfx_p1;

FT_LOC(18) out vec4 vctfx_vp0;
FT_LOC(19) out vec4 vctfx_vp1;
FT_LOC(20) out vec4 vctfx_vp2;

bool applySpheyaPack9() {
    textData.uv = vec2(0.0);
    textData.color = vec4(0.0);
    textData.alpha = 1.0;
    textData.overlayColor = vec4(0.0);
    textData.backColor = vec4(0.0);
    textData.shouldScale = false;
    textData.uvMin = vec2(0.0);
    textData.uvMax = vec2(1.0);
    textData.uvCenter = vec2(0.5);
    textData.position = vec2(0.0);
    textData.characterPosition = vec2(0.0);
    textData.localPosition = vec2(0.0);
    textData.isShadow = false;

    vctfx_applyTextEffect = 0.0;
    vctfx_t0 = vec3(0.0);
    vctfx_t1 = vec3(0.0);
    vctfx_p0 = vec3(0.0);
    vctfx_p1 = vec3(0.0);
    vctfx_vp0 = vec4(0.0);
    vctfx_vp1 = vec4(0.0);
    vctfx_vp2 = vec4(0.0);
    vctfx_side = 0.0;

    textData.isShadow = false;
    textData.color = Color;
    textData.shouldScale = false;
    vctfx_isShadow = textData.isShadow ? 1.0 : 0.0;
    vctfx_isGui = ProjMat[3][3] != 0.0 ? 1.0 : 0.0;
    vctfx_viewPos = mat3(ModelViewMat) * Position;

    // Only glyphs generated for minecraft:text_effect carry both row signatures.
    // Standard fonts retain vanilla color handling even for configured effect colors.
    ivec2 ftAtlasSize = textureSize(Sampler0, 0);
    ivec2 ftTexel = clamp(ivec2(UV0 * vec2(ftAtlasSize)), ivec2(0), ftAtlasSize - 1);
    ivec4 ftTag = ivec4(floor(texelFetch(Sampler0, ftTexel, 0) * 255.0 + 0.5));
    bool ftTagged = all(equal(ftTag, ivec4(17, 93, 211, 1))) || all(equal(ftTag, ivec4(211, 93, 17, 2)));
    if (!ftTagged) return false;

    // Existing FunTime profile frame colors always retain their old rendering.
    ivec3 ftRgb = ivec3(floor(Color.rgb * 255.0 + 0.5));
    if (ftRgb.r == 254 && ftRgb.g >= 166 && ftRgb.g <= 169) return false;
    if (ftRgb.r == 63 && ftRgb.g >= 41 && ftRgb.g <= 42) return false;
    if(!applyTextEffects()) {
        textData.isShadow = true;
        if(!applyTextEffects()) return false;
    }
    vctfx_isShadow = textData.isShadow ? 1.0 : 0.0;

    // FontTexture insets glyph UV bounds by 0.01 texel: minima have
    // fractional part 0.01, maxima 0.99. Identify the quad corner from
    // those bounds, independently of the draw's base vertex in shared buffers.
    bvec2 uvMaxCorner = greaterThan(fract(UV0 * vec2(textureSize(Sampler0, 0))), vec2(0.5));
    int vertexId = uvMaxCorner.x ? (uvMaxCorner.y ? 2 : 3) : (uvMaxCorner.y ? 1 : 0);
    if(vertexId == 0) { vctfx_t0 = vec3(UV0, 1.0); vctfx_p0 = vec3(gl_Position.xy, 1.0); vctfx_vp0 = vec4(vctfx_viewPos, 1.0); }
    if(vertexId == 1) { vctfx_vp2 = vec4(vctfx_viewPos, 1.0); }
    if(vertexId == 2) { vctfx_t1 = vec3(UV0, 1.0); vctfx_p1 = vec3(gl_Position.xy, 1.0); vctfx_vp1 = vec4(vctfx_viewPos, 1.0); }
    if(vertexId == 3) { vctfx_vp2 = vec4(vctfx_viewPos, 1.0); vctfx_side = 1.0; }

    vctfx_faceCoord = vec2[](vec2(0.0, 1.0), vec2(0.0, 0.0), vec2(1.0, 0.0), vec2(1.0, 1.0))[vertexId];

    vctfx_changedScale = 0.0;
    if(textData.shouldScale) {
        gl_Position.xy += 0.2 * (vctfx_faceCoord * 2.0 - 1.0);
        vctfx_changedScale = 1.0;
    }

    vctfx_screenPos = gl_Position;
    vctfx_applyTextEffect = 1.0;
    return true;
}
#endif

