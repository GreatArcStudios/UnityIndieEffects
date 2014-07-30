Shader "IndieEffects/Chromatic Abberation" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Vignette ("Vignette", 2D) = "black" {}
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			sampler2D _Vignette;

			struct v2f {
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert ( appdata_img v ) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.texcoord.xy;
				return o;
			}
			
			half4 frag ( v2f i ) : COLOR {
				half4 col = tex2D(_MainTex, i.uv);
				half4 vig = tex2D(_Vignette, i.uv);
				
				half2 realCoordOffs;
				half2 coords = i.uv;
				coords = (coords - 0.5) * 2.0;
				
				realCoordOffs.x = coords.x * 0.1 * 0.1;
				realCoordOffs.y = coords.y * 0.1 * 0.1;
				
				half red = tex2D(_MainTex, i.uv - realCoordOffs).r;
				half green = tex2D(_MainTex, i.uv - realCoordOffs * 1.5).g;
				half blue = tex2D(_MainTex, i.uv - realCoordOffs * 2).b;
				half red2 = tex2D(_MainTex, i.uv - realCoordOffs * 2.4).r;
				half green2 = tex2D(_MainTex, i.uv - realCoordOffs * 2.8).g;
				half blue2 = tex2D(_MainTex, i.uv - realCoordOffs * 3.2).b;
				half4 chroma = half4(red,0,0,1) + half4(0,green,0,1) + half4(0,0,blue,1);
				half4 chroma2 = half4(red2,0,0,1) + half4(0,green2,0,1) + half4(0,0,blue2,1);
				
				half4 chromaFinal = chroma + chroma2;
				
				half4 finalCol = lerp(chromaFinal/2.5,col,Luminance(vig.rgb));
				return finalCol;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
