Shader "Custom/DOFShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Depth ("DepthTexture", 2D) = "black" {}
		_FStop ("F-Stop", range(0,1)) = 0.5
		_Amount ("Blur Amount", Range(0,3)) = 2
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"
	
	sampler2D _MainTex;
	sampler2D _Depth;
	float4 _MainTex_TexelSize;
	float _Amount;
	float _FStop;
	
	struct v2f {
		float4 pos : POSITION;
		float2 uv[8] : TEXCOORD0;
	};
	
	v2f vert (appdata_img v)
	{
		v2f o;
		
		o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
		
		float2 uv = v.texcoord.xy;
				
		float2 up = float2(0.0, _MainTex_TexelSize.y) * _Amount;
		float2 right = float2(_MainTex_TexelSize.x, 0.0) * _Amount;	
			
		o.uv[0].xy = uv + up;
		o.uv[1].xy = uv - up;
		o.uv[2].xy = uv + right;
		o.uv[3].xy = uv - right;
		o.uv[4].xy = uv - right + up;
		o.uv[5].xy = uv - right -up;
		o.uv[6].xy = uv + right + up;
		o.uv[7].xy = uv + right -up;
		
		return o;
	}
        		
	half4 frag (v2f i) : COLOR
	{
		float2 uv = (i.uv[0] + i.uv[1]) * 0.5;
		float4 col = tex2D(_MainTex, (i.uv[0] + i.uv[1]) * 0.5);
		float depth;
		float3 viewNorm;
		float4 depthnormal = tex2D(_Depth,uv);
		DecodeDepthNormal (depthnormal, depth, viewNorm);
		depth *= _ProjectionParams.z;
		Linear01Depth(depth);
		depth /= _FStop;
		
		float4 newCol;
		newCol.rgb = (0,0,0);
		int count = 1;
		for (int pix = 0; pix < 8; pix ++) {
			if (i.uv[pix].x <= 1.0 && i.uv[pix].y <= 1.0 && i.uv[pix].x >= 0.0 && i.uv[pix].y >= 0.0) { //
				newCol += tex2D(_MainTex, i.uv[pix]);
				count ++;
			}
		}
		
		newCol = lerp(col, newCol / (count + 1)*1.2, saturate(depth));
		return newCol;
	}
	
	ENDCG
	
	SubShader {
		tags {"Queue" = "Overlay" "RenderType" = "Overlay"}
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			ENDCG
		}
	}
}
