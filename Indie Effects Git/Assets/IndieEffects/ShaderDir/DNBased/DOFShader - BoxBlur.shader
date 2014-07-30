Shader "Custom/DOFShader_BoxBlur" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Depth ("DepthTexture", 2D) = "black" {}
		_FStop ("F-Stop", float) = 0.5
		_Amount ("Blur Amount", Range(1,10)) = 3
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"
	
	sampler2D _MainTex;
	sampler2D _Depth;
	float4 _MainTex_TexelSize;
	float _Amount;
	float _FStop;
	
	struct v2f_m {
		float4 pos : POSITION;
		float2 uv : TEXCOORD0;
	};
	
	v2f_m vertC (appdata_img v)
	{
		v2f_m o;
		o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	}
	
	half4 fragC (v2f_img i) : COLOR
	{
		float4 col = (0,0,0);
		float depth;
		float3 viewNorm;
		float4 depthnormal = tex2Dlod (_Depth,float4(i.uv,0,0));
		DecodeDepthNormal (depthnormal, depth, viewNorm);
		depth *= _ProjectionParams.z;
		Linear01Depth(depth);
		depth /= _FStop;
		
		int radius = 5;
		for (int pix = 0; pix < radius; pix ++) {
		col += tex2D(_MainTex, i.uv + half2(_MainTex_TexelSize.x * (pix * _Amount),0));
		col += tex2D(_MainTex, i.uv - half2(_MainTex_TexelSize.x * (pix * _Amount),0));
		col += tex2D(_MainTex, i.uv + half2(0,_MainTex_TexelSize.y * (pix * _Amount)));
		col += tex2D(_MainTex, i.uv - half2(0,_MainTex_TexelSize.y * (pix * _Amount)));
		col += tex2D(_MainTex, i.uv + half2(_MainTex_TexelSize.x * (pix * _Amount),_MainTex_TexelSize.x * (pix * _Amount)));
		col += tex2D(_MainTex, i.uv + half2(-_MainTex_TexelSize.x * (pix * _Amount),_MainTex_TexelSize.x * (pix * _Amount)));
		col += tex2D(_MainTex, i.uv + half2(-_MainTex_TexelSize.x * (pix * _Amount),-_MainTex_TexelSize.x * (pix * _Amount)));
		col += tex2D(_MainTex, i.uv + half2(_MainTex_TexelSize.x * (pix * _Amount),-_MainTex_TexelSize.x * (pix * _Amount)));
		}
		col = col / radius / 8;
//		
		half4 finalcol;
		finalcol = lerp(tex2D(_MainTex, i.uv), col, saturate(depth));
		
		return finalcol;
	}
	
	ENDCG
	
	SubShader {
		Pass {
			Tags { "Queue" = "Overlay" "RenderType" = "Overlay" }
			CGPROGRAM
			#pragma vertex vertC
			#pragma fragment fragC
			#pragma target 3.0
			ENDCG
		}		
	}
}
