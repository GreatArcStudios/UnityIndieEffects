Shader "Custom/RadialBlur" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	struct v2f {
		float4 pos : POSITION;
		float2 uv : TEXCOORD0;
	};
	
	sampler2D _MainTex;
	float2 intensity;
	
	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	} 
	
	half4 frag(v2f i) : COLOR 
	{
		half2 coords = i.uv;
		coords = (coords - 0.5) * 1.0;		
		
		half2 realCoordOffs;
		realCoordOffs.x = coords.x * intensity.x * 0.1; 
		realCoordOffs.y = coords.y * intensity.y * 0.1;
		
		half4 col = tex2D (_MainTex, i.uv - realCoordOffs);
		
		return col;
	}
	
	half4 frag2(v2f i) : COLOR 
	{
		half2 coords = i.uv;
		coords = (coords - 0.5) * 1.2;		
		
		half2 realCoordOffs;
		realCoordOffs.x = coords.x * intensity.x * 0.12; 
		realCoordOffs.y = coords.y * intensity.y * 0.12;
		
		half4 col = tex2D (_MainTex, i.uv - realCoordOffs);
		
		return col;
	}
	
	half4 frag3(v2f i) : COLOR 
	{
		half2 coords = i.uv;
		coords = (coords - 0.5) * 1.4;		
		
		half2 realCoordOffs;
		realCoordOffs.x = coords.x * intensity.x * 0.14; 
		realCoordOffs.y = coords.y * intensity.y * 0.14;
		
		half4 col = tex2D (_MainTex, i.uv - realCoordOffs);
		
		return col;
	}
	
	half4 frag4(v2f i) : COLOR 
	{
		half2 coords = i.uv;
		coords = (coords - 0.5) * 1.6;		
		
		half2 realCoordOffs;
		realCoordOffs.x = coords.x * intensity.x * 0.16; 
		realCoordOffs.y = coords.y * intensity.y * 0.16;
		
		half4 col = tex2D (_MainTex, i.uv - realCoordOffs);
		
		return col;
	}
	half4 frag5(v2f i) : COLOR 
	{
		half2 coords = i.uv;
		coords = (coords - 0.5) * 1.8;		
		
		half2 realCoordOffs;
		realCoordOffs.x = coords.x * intensity.x * 0.18; 
		realCoordOffs.y = coords.y * intensity.y * 0.18;
		
		half4 col = tex2D (_MainTex, i.uv - realCoordOffs);
		
		return col;
	}
	
	half4 frag6(v2f i) : COLOR 
	{
		half2 coords = i.uv;
		coords = (coords - 0.5) * 2.0;		
		
		half2 realCoordOffs;
		realCoordOffs.x = coords.x * intensity.x * 0.2; 
		realCoordOffs.y = coords.y * intensity.y * 0.2;
		
		half4 col = tex2D (_MainTex, i.uv - realCoordOffs);
		
		return col;
	}
	
	half4 frag7(v2f i) : COLOR 
	{
		half2 coords = i.uv;
		coords = (coords - 0.5) * 2.2;		
		
		half2 realCoordOffs;
		realCoordOffs.x = coords.x * intensity.x * 0.22; 
		realCoordOffs.y = coords.y * intensity.y * 0.22;
		
		half4 col = tex2D (_MainTex, i.uv - realCoordOffs);
		
		return col;
	}
	
	half4 frag8(v2f i) : COLOR 
	{
		half2 coords = i.uv;
		coords = (coords - 0.5) * 2.4;		
		
		half2 realCoordOffs;
		realCoordOffs.x = coords.x * intensity.x * 0.24; 
		realCoordOffs.y = coords.y * intensity.y * 0.24;
		
		half4 col = tex2D (_MainTex, i.uv - realCoordOffs);
		
		return col;
	}


	ENDCG 
	
	
	SubShader {
		ZTest Always Cull Off ZWrite Off
		blend OneMinusDstColor DstColor
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG
		}
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag2
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG
		}
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag3
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG
		}
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag4
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG
		}
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag5
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG
		}
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag6
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG
		}
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag7
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG
		}
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag8
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG
		}
	}
}
