    Shader "IndieEffects/Alpha-Blended Motion Blur Stippling" {
    Properties {
    _MainTex ("Texture(RGB)", 2D) = "black" {}
    _Accum ("Accumulation", float) = 0.65
    }
     
    SubShader {
     
    ZTest Always Cull Off ZWrite Off
    Pass {
    Blend SrcAlpha OneMinusSrcAlpha
    //ColorMask RGB
     
    CGPROGRAM
    #include "UnityCG.cginc"
    #pragma vertex vert
    #pragma fragment frag
    //#pragma fragmentoption ARB_precision_hint_fastest
    #pragma target 3.0
     
    struct v2f {
    float4 pos : POSITION;
    float2 uv : TEXCOORD0;
    };
     
    v2f vert (appdata_img v)
    {
    v2f o;
    o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
    o.uv = v.texcoord.xy;
     
    return o;
    }
     
    sampler2D _MainTex;
    float4 _MainTex_TexelSize;
    float _Accum;
     
    float4 col;
     
    half4 frag (v2f i) : COLOR
    {
    col = tex2D(_MainTex, i.uv);
     
     
    if(int(i.uv.x + i.uv.y)/i.uv.x == i.uv.y)
    discard;
    else
    col.a = _Accum;
     
//    col.r = 1.0;
//    col.g = 1.0;
//    col.b = 1.0;
    
     
    return col;
    }
     
     
    ENDCG
    /*
    SetTexture [_MainTex] {
    ConstantColor(1,1,1,[_Accum])
    Combine texture, constant
    }*/
    }
    Pass {
    Blend One Zero
    ColorMask A
    SetTexture [_MainTex] {
    Combine texture
    }
    }
    }
    Fallback off
    }