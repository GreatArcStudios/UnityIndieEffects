

Shader "IndieEffects/CameraMotionBlur"{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_CameraDepthTexture ("Depth Texture", 2D) = "black" {}
		//_intensity ("Intensity", Range(0.0, 1.0)) = 0.5
	}
	SubShader
	{
	Pass
		{
			ZTest Always Cull Off ZWrite Off
			  Fog { Mode off }
	   
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
		   
			#include "UnityCG.cginc"
		   
			struct v2f {
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
				float2 uvVelocity : TEXCOORD1;
			};
		   
			v2f vert (appdata_img v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.texcoord.xy;
			   
				return o;
			}
		   
			sampler2D     _MainTex;
			sampler2D     _CameraDepthTexture;
			float4x4    _inverseViewProjectionMatrix;
			float4x4     _previousViewProjectionMatrix;
			float        _intensity; //Range 0 - 1, I used pretty low values ~0.002
		   
			float4 frag( v2f v ) : COLOR
			{
				float2 texCoord = v.uv;
				// Get the depth buffer value at this pixel.
				float zOverW = tex2D(_CameraDepthTexture, texCoord);
			   
				// H is the viewport position at this pixel in the range -1 to 1.
				float4 H = float4(texCoord.x * 2 - 1, (1 - texCoord.y) * 2 - 1, zOverW, 1);
			   
				// Transform by the view-projection inverse.
				float4 D = mul(_inverseViewProjectionMatrix , H);
			   
				// Divide by w to get the world position.
				float4 worldPos = D / D.w;
			   
			   
			   
				// Current viewport position
				float4 currentPos = H;
			   
				// Use the world position, and transform by the previous view-
				// projection matrix.
				float4 previousPos = mul(_previousViewProjectionMatrix , worldPos);
			   
				// Convert to nonhomogeneous points [-1,1] by dividing by w.
				previousPos /= previousPos.w;
			   
				// Use this frame's position and last frame's to compute the pixel
				// velocity.
				_intensity = clamp(_intensity , 0.0 , 1.0);
				float2 velocity = -(currentPos - previousPos)*_intensity;
			   
 
			   
			   
				// Get the initial color at this pixel.
				float4 finalColor = tex2D(_MainTex, texCoord);
				texCoord += velocity;
				int numSamples = 10;
				for(int i = 1; i < numSamples; ++i, texCoord += velocity)
				{
					// Sample the color buffer along the velocity vector.
				//    float2 offset = velocity * (float(i) / float(numSamples - 1) - 0.5);
					float4 currentColor = tex2D(_MainTex, texCoord);
 
					// Add the current color to our color sum.
					finalColor += currentColor;
				}
			   
				// Average all of the samples to get the final blur color.
				finalColor = finalColor / numSamples;
				return finalColor;
				//return float4(zOverW , zOverW , zOverW , 1.0);
			   
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
