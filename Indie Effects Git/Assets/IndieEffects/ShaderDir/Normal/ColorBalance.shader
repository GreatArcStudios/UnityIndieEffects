/*
This shader is intended for use with the accompanying ColorBalance script and
Fuzzy Quill's True Motion Blur for Unity Free script.

-Adam T. Ryder
http://1337atr.weebly.com
*/

Shader "Custom/ColorBalance" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_Lift ("Lift (RBG)", Color) = (1.0, 1.0, 1.0, 1.0)
		_LiftB ("Bright", Range (0.0, 2.0)) = 1.0
		_Gamma ("Gamma (RBG)", Color) = (1.0, 1.0, 1.0, 1.0)
		_GammaB ("Bright", Range (0.0, 2.0)) = 1.0
		_Gain ("Gain (RBG)", Color) = (1.0, 1.0, 1.0, 1.0)
		_GainB ("Bright", Range (0.0, 2.0)) = 1.0
	}
	SubShader {
		Tags { "Queue"="Overlay" "RenderType"="Overlay" "ForceNoShadowCasting"="True" "IgnoreProjector"="True" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Simple halfasview novertexlights noforwardadd
		#pragma target 3.0
		
		half4 LightingSimple (SurfaceOutput s, half3 lightDir, half atten) {
			half4 c;
			c.rgb = s.Albedo;
			c.a = 1.0;
			return c;
		}

		sampler2D _MainTex;
		fixed4 _Lift;
		fixed4 _Gamma;
		fixed4 _Gain;
		float _LiftB;
		float _GammaB;
		float _GainB;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			_Lift = _Lift * _LiftB;
			_Gamma = _Gamma * _GammaB;
			_Gain = _Gain * _GainB;
			o.Albedo.r = pow(_Gain.r * (c.r + (_Lift.r - 1.0) * (1.0 - c.r)), 1.0 / _Gamma.r);
			o.Albedo.g = pow(_Gain.g * (c.g + (_Lift.g - 1.0) * (1.0 - c.g)), 1.0 / _Gamma.g);
			o.Albedo.b = pow(_Gain.b * (c.b + (_Lift.b - 1.0) * (1.0 - c.b)), 1.0 / _Gamma.b);
		}
		ENDCG
	} 
	FallBack "Diffuse"
}