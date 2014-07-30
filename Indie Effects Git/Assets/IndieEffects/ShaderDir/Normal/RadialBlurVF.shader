Shader "Custom/Godrays" {
Properties {
    _MainTex ("Base (RGB)", 2D) = "white" {}
    _Depth ("Base (RGB)", 2D) = "white" {}
    fX ("fX", Float) = 0.5
    fY ("fY", Float) = 0.5
    fExposure ("fExposure", Float) = 0.6
    fDecay ("fDecay", Float) = 0.8
    fDensity ("fDensity", Float) = 1
    fWeight ("fWeight", Float) = 0.9
    fClamp ("fClamp", Float) = 1.0
    sunPosX("sunPosX",Vector) = (0.5,0.5,0)
    sunPosY("sunPosY",Vector) = (0.5,0.5,0)
}
    CGINCLUDE
    #include "UnityCG.cginc"
   
    uniform sampler2D _MainTex;
    float4 _MainTex_TexelSize;
    uniform sampler2D _Depth;
    float fX,fY,fExposure,fDecay,fDensity,fWeight,fClamp,iSamples;
    float sunPosX;
    float sunPosY;
    float2 intensity = float2(0.1,0.1);
   
    struct v2f
    {
        float4 pos : POSITION;
        float2 uv : TEXCOORD0;
    };
    
    v2f vert (appdata_img v) {
    	v2f o;
    	o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
    	o.uv = v.texcoord.xy;
    	return o;
    }
 
	half4 frag (v2f i) : COLOR {
		
		int iSamples=100;
		float2 vUv = i.uv;
		//vUv *= float2(1,1); // repeat?
		float2 deltaTextCoord = float2(vUv - float2(fX,fY));
		deltaTextCoord *= 1.0 /  float(iSamples) * fDensity;
		float2 coord = vUv;
		float illuminationDecay = 1.0;
		float4 FragColor = float4(0.0);
		for(int i=0; i < iSamples ; i++){
		coord -= deltaTextCoord;
		float4 texel = tex2D(_MainTex, coord);
		texel *= illuminationDecay * fWeight;
		FragColor += texel;
		illuminationDecay *= fDecay;
		}
		FragColor *= fExposure;
		FragColor = clamp(FragColor, 0.0, fClamp);
		return FragColor;
	} 
   
    ENDCG
Subshader {
    Tags { "Queue"="Overlay" "RenderType"="Overlay"}
    ZTest On
    Cull Off
    ZWrite Off
    Fog { Mode off }
        Pass {
        blend OneMinusDstColor SrcColor
            CGPROGRAM
              #pragma fragmentoption ARB_precision_hint_fastest
              #pragma vertex vert
              #pragma fragment frag
              #pragma target 3.0
              #pragma glsl
              ENDCG
          }
    }
}
