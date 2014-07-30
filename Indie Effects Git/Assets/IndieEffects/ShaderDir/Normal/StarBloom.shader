/*
This shader is intended for use with Fuzzy Quill's True Motion Blur for Unity free script
and in conjuction with Bloom.js.

-Adam T. Ryder
http://1337atr.weebly.com
*/

Shader "IndieEffects/ShaderDir/SimpleBloom" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" { }
		_BlurTex ("Base (RGB)", 2D) = "black" { }
		_OffsetScale("Offset", Range (0.0, 10.0)) = 1.0
		_Threshold ("Threshold", Range (0.0, 1.0)) = 0.7
		_Amount ("Amount", Range (0.0, 10.0)) = 1.0
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"
	
	sampler2D _MainTex;
	sampler2D _BlurTex;
	float4 _MainTex_TexelSize;
	uniform float _OffsetScale;
	uniform float _Amount;
	uniform float _Threshold;
	
	struct v2f {
		float4 pos : POSITION;
		float2 uv : TEXCOORD0;
	};
	
	struct v2f_off {
		float4 pos : POSITION;
		float2 uv[8] : TEXCOORD0;
	};
	
	struct v2f_off2 {
		float4 pos : POSITION;
		float2 uv[8] : TEXCOORD0;
	};
	
	v2f vert (appdata_img v)
	{
		v2f o;
		
		o.pos = mul (UNITY_MATRIX_MVP, v.vertex);

		o.uv = v.texcoord.xy;
		
		return o;
	}
	
	v2f_off vertOff (appdata_img v)
	{
		v2f_off o;
		
		o.pos = mul (UNITY_MATRIX_MVP, v.vertex);

		float2 uv = v.texcoord.xy;
				
		float2 up = float2(0.0, _MainTex_TexelSize.y) * _OffsetScale;
		float2 right = float2(_MainTex_TexelSize.x, 0.0) * _OffsetScale;	
			
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
	v2f_off2 vertOff2 (appdata_img v)
	{
		v2f_off2 o;
		
		o.pos = mul (UNITY_MATRIX_MVP, v.vertex);

		float2 uv = v.texcoord.xy;
				
		float2 up = float2(0.0, _MainTex_TexelSize.y) * _OffsetScale / 2;
		float2 right = float2(_MainTex_TexelSize.x, 0.0) * _OffsetScale / 2;	
			
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
	
	float4 col;
	half4 frag (v2f i) : COLOR
	{
		col = tex2D(_MainTex, i.uv);
		if (Luminance( tex2D(_MainTex, i.uv).rgb ) >= _Threshold) {
			col.rgb += tex2D(_BlurTex, i.uv).rgb;
		} else { col.rgb = (0,0,0); }
		return col;
	}
	
	half4 fragOff (v2f_off i) : COLOR
	{
		col = tex2D(_BlurTex, (i.uv[0] + i.uv[1]) * 0.5);
		float4 newCol;
		newCol.rgb = col.rgb;
		int count = 1;
		for (int pix = 0; pix < 8; pix ++) {
			if (i.uv[pix].x <= 1.0 && i.uv[pix].y <= 1.0	&& i.uv[pix].x >= 0.0 && i.uv[pix].y >= 0.0) {
					newCol += tex2D(_BlurTex, i.uv[pix]);
					count ++;
			}
		}
		newCol = ((newCol + col) / (count + 1)) * _Amount;
		
		return newCol;
	}
	half4 fragOff2 (v2f_off2 i) : COLOR
	{
		col = tex2D(_BlurTex, (i.uv[0] + i.uv[1]) * 0.5);
		float4 newCol;
		newCol.rgb = col.rgb;
		int count = 1;
		for (int pix = 0; pix < 8; pix ++) {
			if (i.uv[pix].x <= 1.0 && i.uv[pix].y <= 1.0	&& i.uv[pix].x >= 0.0 && i.uv[pix].y >= 0.0) {
					newCol += tex2D(_BlurTex, i.uv[pix]);
					count ++;
			}
		}
		newCol = ((newCol + col) / (count + 1)) * _Amount;
		
		return newCol;
	}
	ENDCG
	
	SubShader {
		Tags { "Queue"="Overlay" "RenderType"="Overlay"}
		blend SrcColor One
		Pass {
			ZTest Always Cull Off ZWrite Off
			Fog { Mode off }
			Lighting Off
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma target 3.0
			
			ENDCG
		}
		Pass {
			ZTest Always Cull Off ZWrite Off
			Blend One SrcColor
			Fog { Mode off }
			Lighting Off
			
			CGPROGRAM
			#pragma vertex vertOff
			#pragma fragment fragOff
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma target 3.0
			
			ENDCG
		}
		
		Pass {
			ZTest Always Cull Off ZWrite Off
			Blend One SrcColor
			Fog { Mode off }
			Lighting Off
			
			CGPROGRAM
			#pragma vertex vertOff2
			#pragma fragment fragOff2
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma target 3.0
			
			ENDCG
		}
	}
	
	SubShader {
		Tags { "Queue" = "Overlay" }
		
		Pass {
			ZTest Always Cull Off ZWrite Off
			Fog { Mode off }
			Lighting Off
			
			SetTexture [_MainTex] {
				Combine texture
			}
		}
	}
	Fallback off
}