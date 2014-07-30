Shader "Indie Effects/Image Bloom" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BlurTex ("Base (RGB)", 2D) = "white" {}
		_Threshold ("Threshold", range(0,1)) = 0.1
		_Amount ("Amount", range(0,2)) = 0.2
	}
	CGINCLUDE
	#include "UnityCG.cginc"

	sampler2D _MainTex;
	half4 _MainTex_TexelSize;
	sampler2D _BlurTex;
	half _Threshold;
	half _Amount;

	struct v2f {
		float4 pos : POSITION;
		float2 uv : TEXCOORD0;
	};
	
	v2f vert (appdata_img v){
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	}
	half4 fragBloom (v2f i) : COLOR {
		half4 col = tex2D(_BlurTex, i.uv);
		
		_Amount = clamp(_Amount, 0.0, 2.0);
		_Threshold = clamp(_Threshold, 0.0, 1.0);
		int radius = 10;
		for (int pix = 0; pix < radius; pix ++) {
		col += tex2D(_MainTex, i.uv + half2(_MainTex_TexelSize.x * pix,_MainTex_TexelSize.y * pix));
		col += tex2D(_MainTex, i.uv + half2(_MainTex_TexelSize.x * pix,-_MainTex_TexelSize.y * pix));
		col += tex2D(_MainTex, i.uv + half2(-_MainTex_TexelSize.x * pix,-_MainTex_TexelSize.y * pix));
		col += tex2D(_MainTex, i.uv + half2(-_MainTex_TexelSize.x * pix,_MainTex_TexelSize.y * pix));
		}
		
		col = col / radius;
		
		half4 finalColor = tex2D(_MainTex, i.uv);
		half4 bleedCol = tex2D(_MainTex, i.uv);
		bleedCol += col * _Amount;
		half4 superCol = lerp(finalColor, bleedCol, Luminance(col.rgb)/(_Threshold*10));
		return superCol;
	}
	
	ENDCG
		
	SubShader {
	tags { "Queue" = "Overlay" "RenderType" = "Overlay" }
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment fragBloom
			#pragma target 3.0
			ENDCG
		}
	}
	FallBack "Diffuse"
}
