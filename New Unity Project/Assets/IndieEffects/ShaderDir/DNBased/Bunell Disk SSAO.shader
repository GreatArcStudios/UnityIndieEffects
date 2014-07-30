// Here is a Bunell Disk Screen Space Ambient Occlusion or Disk to Disk SSAO implementation, ported in Unity Free by Cyrien5100 (me).
// Original technique was developped by Arkano22 based on an Nvidia Implementaion, but in geometry space.
// Arkano22 modified it to work in Screen Space.
// About me, i translated the shader in CG (original was GLSL), and i tweaked/customized it a little, to work correctly in Unity.
// If you use it in your games, please say my name in credits ;)
// Big thanks to Arkano22 for creating this EPIC technique, to FuzzyQuills for IndieEffects, to 0tacun for helping in position reconstruction, 
// to #Include Graphics and bwhiting from GameDev forum for helping me about self occlusion problem.
//
Shader "Hidden/Bunell Disk SSAO" {
    Properties {
		_DepthNormalTex ("Depth Texture", 2D) = "" {}
		_noiseTex ("NoiseTex", 2D) = ""{}
		_sampleRad("Sampling Radius",Float) = 1.0
	}
	SubShader {
		//Blend One Zero
		Blend DstColor Zero 
		Tags { "Queue"="Overlay" "IgnoreProjector"="True" "RenderType"="Overlay"}
		Lighting Off
		Cull Off
		Fog { Mode Off }
		ZWrite Off
						
		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag 
			#pragma target 3.0
			#pragma glsl
			#pragma exclude_renderers d3d11 xbox360
			
			#include "UnityCG.cginc"
			
			#define FORCE_TEX2DLOD
			
			float _Bias;
			sampler2D _noiseTex;
			float4 _ProjInfo;
			float4x4 _InvProj;
			sampler2D _DepthNormalTex;
			float _sampleRad;
			float _scale;
			int _iterations;
			half _selfOcclusion;
			half _strength;
			

			struct appdata {
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				
			};
									
			v2f vert (appdata v) {
				v2f o;
				o.pos = mul( UNITY_MATRIX_MVP, v.vertex );
				o.uv = v.texcoord.xy;

				return o;
			}
			
			
			    float4 readDepthNormal(float2 coord) // A function which decodes the Depth/Normal Tetxure which are packed into one RGBA32 and return normals and depth.
        		{
        		float2 uv = coord;
//        		if(uv.x<0.01){uv.x = 0;}
//        		if(uv.y<0.01){uv.y = 0;}
//        		if(uv.y>0.99){uv.y = 1;}
//        		if(uv.x>0){uv.x = 1;}
        		float4 depthnormal = tex2Dlod (_DepthNormalTex,float4(uv,0,0));
                float3 viewNorm;
                float depth;
                DecodeDepthNormal (depthnormal, depth, viewNorm);
                depth *=_ProjectionParams.z; // _ProjectionParams.z = far clip
                return float4(viewNorm,depth);
        		}
			
			float3 posFromDepth(float2 coord)
			{
	float	Depth=readDepthNormal(coord).w;
	float4	Pos=float4((coord.x-0.5)*2,(0.5-coord.y)*2,1,1);
	float4	Ray=mul(Pos,_InvProj);
	return	Ray.xyz*Depth;
			}
			
			
			float aoFF(in half3 ddiff, in half3 cnorm, in float c1, in float c2, in float2 uv) //cnorm = main normal et readDepthNormal(uv+half2(c1,c2).xyz = sample normal
			{
			 half3 vv = normalize(ddiff);
			 float rd = length(ddiff);
			 half3 snorm = readDepthNormal(uv+half2(c1,c2)).xyz;
			 if (dot(snorm,cnorm)>_selfOcclusion){return 0;}
			 else{
			 return clamp(1.0-dot(snorm,-vv),0.0,1.0) *
           	 clamp(dot( cnorm,vv )-_Bias,0.0,1.0)* 
             (1.0 - 1.0/sqrt(1.0/(rd*rd*_scale) + 1.0));}
			}
			
					
			fixed4 frag( v2f o ) : COLOR
			{
				float4 depthnorm = readDepthNormal(o.uv);
				half3 n = depthnorm.xyz;
				half3 p = posFromDepth(o.uv);
				
				half2 fres = half2(_ScreenParams.x/64.0*5,_ScreenParams.y/64.0*5);
				half3 random = tex2D(_noiseTex,o.uv*fres.xy);
				random = random*2.0-half3(1.0);
				
				float ao = 0.0;
				float incx = (_sampleRad*4/_iterations)/_ScreenParams.x*0.1;
				float incy = (_sampleRad*4/_iterations)/_ScreenParams.y*0.1;
				float pw = incx;
				float ph = incy;
				float cdepth = depthnorm.w;
				for(float i=0.0; i<_iterations; ++i) 
    			{
       			float npw = (pw+0.0007*random.x)/cdepth;
       			float nph = (ph+0.0007*random.y)/cdepth;
       			
//       			float npw = (pw+0.0007*random.x)/cdepth;
//       			float nph = (ph+0.0007*random.y)/cdepth;

       			half3 ddiff = posFromDepth(o.uv+half2(npw,nph))-p;
       			half3 ddiff2 = posFromDepth(o.uv+half2(npw,-nph))-p;
       			half3 ddiff3 = posFromDepth(o.uv+half2(-npw,nph))-p;
       			half3 ddiff4 = posFromDepth(o.uv+half2(-npw,-nph))-p;
       			half3 ddiff5 = posFromDepth(o.uv+half2(0,nph))-p;
       			half3 ddiff6 = posFromDepth(o.uv+half2(0,-nph))-p;
       			half3 ddiff7 = posFromDepth(o.uv+half2(npw,0))-p;
       			half3 ddiff8 = posFromDepth(o.uv+half2(-npw,0))-p;

       			ao+=  aoFF(ddiff,n,npw,nph,o.uv);
       			ao+=  aoFF(ddiff2,n,npw,-nph,o.uv);
       			ao+=  aoFF(ddiff3,n,-npw,nph,o.uv);
       			ao+=  aoFF(ddiff4,n,-npw,-nph,o.uv);
       			ao+=  aoFF(ddiff5,n,0,nph,o.uv);
       			ao+=  aoFF(ddiff6,n,0,-nph,o.uv);
       			ao+=  aoFF(ddiff7,n,npw,0,o.uv);
       			ao+=  aoFF(ddiff8,n,-npw,0,o.uv);

       			//increase sampling area:
       			pw += incx;  
       			ph += incy;    
    			} 
    			ao/=8*_iterations;
    			ao*=_strength;
				fixed3 color = saturate(1-ao);
				
				if(cdepth < _ProjectionParams.z-_ProjectionParams.z/200){color = color;}
				else {color = fixed3(1,1,1);}
				return fixed4(color, 1);				
			}
			ENDCG
		}
		}
		
    Fallback off
	CustomEditor "FXMaterialEditor"
}