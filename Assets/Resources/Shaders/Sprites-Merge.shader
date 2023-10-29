Shader"Sprites/Merge"
{
    Properties
    {
        _MainTex0 ("Sprite Texture0", 2D) = "white" {}
        _MainTex1 ("Sprite Texture1", 2D) = "black" {}
        _MainTex2 ("Sprite Texture2", 2D) = "black" {}
        _MainTex3 ("Sprite Texture3", 2D) = "black" {}
        _MainTex4 ("Sprite Texture4", 2D) = "black" {}
        _Color ("Tint", Color) = (1,1,1,1)
        _AlphaEx ("AlphaEx", Range(0, 1)) = 1
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Cull Off
        Lighting Off
        ZWrite Off
        Blend One OneMinusSrcAlpha

        Pass
        {
        CGPROGRAM
            #pragma vertex SpriteVert
            #pragma fragment SpriteFrag
            #pragma target 2.0
            #pragma multi_compile TEX0 TEX1 TEX2 TEX3 TEX4 TEX5 TEX6 TEX7 TEX8 TEX9 TEX10 TEX11 TEX12 TEX13 TEX14 TEX15 TEX16

#include "UnityCG.cginc"

// Material Color.
fixed4 _Color;
float _AlphaEx;

struct appdata_t
{
    float4 vertex   : POSITION;
    float4 color    : COLOR;
    float2 texcoord : TEXCOORD0;
};

struct v2f
{
    float4 vertex   : SV_POSITION;
    fixed4 color    : COLOR;
    float2 texcoord : TEXCOORD0;
};

inline float4 UnityFlipSprite(in float3 pos, in fixed2 flip)
{
    return float4(pos.xy * flip, pos.z, 1.0);
}

v2f SpriteVert(appdata_t IN)
{
    v2f OUT;
    
    OUT.vertex = UnityObjectToClipPos(IN.vertex);
    OUT.texcoord = IN.texcoord;
    OUT.color = IN.color * _Color;
    
    return OUT;
}

sampler2D _MainTex0;
float4 _MainTex0_ST;
sampler2D _MainTex1;
float4 _MainTex1_ST;
sampler2D _MainTex2;
float4 _MainTex2_ST;
sampler2D _MainTex3;
float4 _MainTex3_ST;
sampler2D _MainTex4;
float4 _MainTex4_ST;
sampler2D _MainTex5;
float4 _MainTex5_ST;
sampler2D _MainTex6;
float4 _MainTex6_ST;
sampler2D _MainTex7;
float4 _MainTex7_ST;
sampler2D _MainTex8;
float4 _MainTex8_ST;
sampler2D _MainTex9;
float4 _MainTex9_ST;
sampler2D _MainTex10;
float4 _MainTex10_ST;
sampler2D _MainTex11;
float4 _MainTex11_ST;
sampler2D _MainTex12;
float4 _MainTex12_ST;
sampler2D _MainTex13;
float4 _MainTex13_ST;
sampler2D _MainTex14;
float4 _MainTex14_ST;
sampler2D _MainTex15;
float4 _MainTex15_ST;

fixed4 SampleSpriteTexture (float2 uv)
{
    fixed4 color = fixed4(0, 0, 0, 0);
    fixed4 _color = fixed4(0, 0, 0, 0);
    
#if defined(TEX1) || defined(TEX2) || defined(TEX3) || defined(TEX4) || defined(TEX5) || defined(TEX6) || defined(TEX7) || defined(TEX8) || defined(TEX9) || defined(TEX10) || defined(TEX11) || defined(TEX12) || defined(TEX13) || defined(TEX14) || defined(TEX15) || defined(TEX16)
    color = tex2D(_MainTex0, TRANSFORM_TEX(uv, _MainTex0));
#endif

#if defined(TEX2) || defined(TEX3) || defined(TEX4) || defined(TEX5) || defined(TEX6) || defined(TEX7) || defined(TEX8) || defined(TEX9) || defined(TEX10) || defined(TEX11) || defined(TEX12) || defined(TEX13) || defined(TEX14) || defined(TEX15) || defined(TEX16)
    _color = tex2D(_MainTex1, TRANSFORM_TEX(uv, _MainTex1));
    color.rgb = color.rgb * (1-_color.a) + _color.rgb * _color.a;
    color.a = max(color.a, _color.a);
#endif

#if defined(TEX3) || defined(TEX4) || defined(TEX5) || defined(TEX6) || defined(TEX7) || defined(TEX8) || defined(TEX9) || defined(TEX10) || defined(TEX11) || defined(TEX12) || defined(TEX13) || defined(TEX14) || defined(TEX15) || defined(TEX16)
    _color = tex2D(_MainTex2, TRANSFORM_TEX(uv, _MainTex2));
    color.rgb = color.rgb * (1-_color.a) + _color.rgb * _color.a;
    color.a = max(color.a, _color.a);
#endif

#if defined(TEX4) || defined(TEX5) || defined(TEX6) || defined(TEX7) || defined(TEX8) || defined(TEX9) || defined(TEX10) || defined(TEX11) || defined(TEX12) || defined(TEX13) || defined(TEX14) || defined(TEX15) || defined(TEX16)
    _color = tex2D(_MainTex3, TRANSFORM_TEX(uv, _MainTex3));
    color.rgb = color.rgb * (1-_color.a) + _color.rgb * _color.a;
    color.a = max(color.a, _color.a);
#endif

#if defined(TEX5) || defined(TEX6) || defined(TEX7) || defined(TEX8) || defined(TEX9) || defined(TEX10) || defined(TEX11) || defined(TEX12) || defined(TEX13) || defined(TEX14) || defined(TEX15) || defined(TEX16)
    _color = tex2D(_MainTex4, TRANSFORM_TEX(uv, _MainTex4));
    color.rgb = color.rgb * (1-_color.a) + _color.rgb * _color.a;
    color.a = max(color.a, _color.a);
#endif

#if defined(TEX6) || defined(TEX7) || defined(TEX8) || defined(TEX9) || defined(TEX10) || defined(TEX11) || defined(TEX12) || defined(TEX13) || defined(TEX14) || defined(TEX15) || defined(TEX16)
    _color = tex2D(_MainTex5, TRANSFORM_TEX(uv, _MainTex5));
    color.rgb = color.rgb * (1-_color.a) + _color.rgb * _color.a;
    color.a = max(color.a, _color.a);
#endif

#if defined(TEX7) || defined(TEX8) || defined(TEX9) || defined(TEX10) || defined(TEX11) || defined(TEX12) || defined(TEX13) || defined(TEX14) || defined(TEX15) || defined(TEX16)
    _color = tex2D(_MainTex6, TRANSFORM_TEX(uv, _MainTex6));
    color.rgb = color.rgb * (1-_color.a) + _color.rgb * _color.a;
    color.a = max(color.a, _color.a);
#endif

#if defined(TEX8) || defined(TEX9) || defined(TEX10) || defined(TEX11) || defined(TEX12) || defined(TEX13) || defined(TEX14) || defined(TEX15) || defined(TEX16)
    _color = tex2D(_MainTex7, TRANSFORM_TEX(uv, _MainTex7));
    color.rgb = color.rgb * (1-_color.a) + _color.rgb * _color.a;
    color.a = max(color.a, _color.a);
#endif

#if defined(TEX9) || defined(TEX10) || defined(TEX11) || defined(TEX12) || defined(TEX13) || defined(TEX14) || defined(TEX15) || defined(TEX16)
    _color = tex2D(_MainTex8, TRANSFORM_TEX(uv, _MainTex8));
    color.rgb = color.rgb * (1-_color.a) + _color.rgb * _color.a;
    color.a = max(color.a, _color.a);
#endif

#if defined(TEX10) || defined(TEX11) || defined(TEX12) || defined(TEX13) || defined(TEX14) || defined(TEX15) || defined(TEX16)
    _color = tex2D(_MainTex9, TRANSFORM_TEX(uv, _MainTex9));
    color.rgb = color.rgb * (1-_color.a) + _color.rgb * _color.a;
    color.a = max(color.a, _color.a);
#endif

#if defined(TEX11) || defined(TEX12) || defined(TEX13) || defined(TEX14) || defined(TEX15) || defined(TEX16)
    _color = tex2D(_MainTex10, TRANSFORM_TEX(uv, _MainTex10));
    color.rgb = color.rgb * (1-_color.a) + _color.rgb * _color.a;
    color.a = max(color.a, _color.a);
#endif

#if defined(TEX12) || defined(TEX13) || defined(TEX14) || defined(TEX15) || defined(TEX16)
    _color = tex2D(_MainTex11, TRANSFORM_TEX(uv, _MainTex11));
    color.rgb = color.rgb * (1-_color.a) + _color.rgb * _color.a;
    color.a = max(color.a, _color.a);
#endif

#if defined(TEX13) || defined(TEX14) || defined(TEX15) || defined(TEX16)
    _color = tex2D(_MainTex12, TRANSFORM_TEX(uv, _MainTex12));
    color.rgb = color.rgb * (1-_color.a) + _color.rgb * _color.a;
    color.a = max(color.a, _color.a);
#endif

#if defined(TEX14) || defined(TEX15) || defined(TEX16)
    _color = tex2D(_MainTex13, TRANSFORM_TEX(uv, _MainTex13));
    color.rgb = color.rgb * (1-_color.a) + _color.rgb * _color.a;
    color.a = max(color.a, _color.a);
#endif

#if defined(TEX15) || defined(TEX16)
    _color = tex2D(_MainTex14, TRANSFORM_TEX(uv, _MainTex14));
    color.rgb = color.rgb * (1-_color.a) + _color.rgb * _color.a;
    color.a = max(color.a, _color.a);
#endif

#if defined(TEX16)
    _color = tex2D(_MainTex15, TRANSFORM_TEX(uv, _MainTex15));
    color.rgb = color.rgb * (1-_color.a) + _color.rgb * _color.a;
    color.a = max(color.a, _color.a);
#endif
    
    color.rgb *= _AlphaEx;
    return color;
}

fixed4 SpriteFrag(v2f IN) : SV_Target
{
    fixed4 c = SampleSpriteTexture (IN.texcoord) * IN.color;
    c.rgb *= c.a;
    return c;
}

        ENDCG
        }
    }
}
