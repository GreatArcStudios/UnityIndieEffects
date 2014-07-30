Shader "Custom/MotionBlur"{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Depth ("Depth Texture", 2D) = "black" {}
        _DepthPrev ("Depth Texture", 2D) = "black" {}
        _intensity ("Intensity", Range(0.0, 1.0)) = 0.5
    }
	CGINCLUDE
	
	#include "UnityCG.cginc"
           
	struct v2f {
		float4 pos : POSITION;
		float2 uv : TEXCOORD2;
		float2 uvVelocity : TEXCOORD1;
		float2 depth : TEXCOORD0;
	};

	v2f vert (appdata_img v)
	{
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		COMPUTE_EYEDEPTH(o.depth);
		return o;
	}

	sampler2D    _MainTex;
	sampler2D    _Depth;
	sampler2D    _DepthPrev;
	float4x4     _inverseViewProjectionMatrix;
	float4x4     _previousViewProjectionMatrix;		
	float        _intensity; //Range 0 - 1, I used pretty low values ~0.002

	float4 frag( v2f v ) : COLOR
	{
		float2 texCoord = v.uv;
//		float depth;
//		float3 norm;
//		DecodeDepthNormal(tex2Dlod(_Depth, float4(v.uv,0,0)),depth,norm);
//		depth *= _ProjectionParams.z;
//		Linear01Depth(depth);
//		depth += 10248;
//		depth -= lerp(0.0,1.0,depth / 10000);
		float depth = v.depth.x / 150;
		clamp(depth, 1.0, 0.0);
		
		float zOverW = depth / 10000;
		float4 H = float4(texCoord.x * 2 - 1, (1 - texCoord.y) * 2 - 1, min(zOverW, zOverW / depth), 1);
		float4 D = mul(_inverseViewProjectionMatrix , H);
		float4 worldPos = D / D.w;
		float4 currentPos = H;
		float4 previousPos = mul(_previousViewProjectionMatrix , worldPos);
		previousPos /= previousPos.w;
		_intensity = clamp(_intensity , 0.0 , 1.0);
		float2 velocity = (currentPos - previousPos)*_intensity;
		
		float4 finalColor = tex2D(_MainTex, texCoord);

		texCoord += velocity;
		int numSamples = 10;

		for(int i = 1; i < numSamples; ++i, texCoord += velocity) //modelVector * 
		{
		    float4 currentColor = tex2D(_MainTex, texCoord);
		    finalColor += currentColor;
		}

		finalColor = finalColor / numSamples;
		return finalColor;           
	}
	
//	float4 fragVector( v2f v ) : COLOR
//	{
//		float2 texCoord = v.uv;
//		float4 zOverW = tex2D(_Depth, texCoord);
//		float texOff_X = texCoord.x * 2 - 1;
//		float texOff_Y =  (1 - texCoord.y) * 2 - 1;
//		float4 H = float4(texOff_X, texOff_Y, zOverW.x, 1);
//		float4 zOverW2 = tex2D(_DepthPrev, texCoord);
//		float4 D = float4(texOff_X, texOff_Y, zOverW2.x, 1);
//		_intensity = clamp(_intensity , 0.0 , 1.0);
//		
//		float2 velocity;
//		velocity = (H-D)*_intensity;	
//		float4 finalColor = tex2D(_MainTex, texCoord);
//
//		texCoord += velocity;
//		int numSamples = 10;
//
//		for(int i = 1; i < numSamples; ++i, texCoord += velocity) //modelVector * 
//		{
//		    float4 currentColor = tex2D(_MainTex, texCoord);
//		    finalColor += currentColor;
//		}
//
//		finalColor = finalColor / numSamples;
//		return finalColor;              
//	}

	ENDCG
	SubShader {
		Pass {
			ZTest Always Cull Off ZWrite Off
			Fog { Mode off }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			ENDCG
		}	
	} 
    FallBack off
}