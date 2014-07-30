    Shader "Custom/SSAOTest" {
        Properties {
            _MainTex ("Base (RGB)", 2D) = "white" {}
            _DepthTextureSampler("Depth Texture", 2D) = "black" {}
            _RandomTextureSampler("Random Texture", 2D) = "grey" {}
            _Strength ("Strength", Range(0, 2.0)) = 1.0
            _Base ("Base", Range(0, 1.0)) = 0.2
            _Area ("Area", Range(0.00001, 0.2)) = 0.0075
            _Falloff ("Falloff", Range(0.0000005, 0.00001)) = 0.000001
            _Radius ("Radius", Range(0.0001, 0.0004)) = 0.0002
        }
       	CGINCLUDE
       	
       	#include "UnityCG.cginc"
       	
		sampler2D _MainTex;
		float4 _MainTex_TexelSize;
		sampler2D _DepthTextureSampler;
		sampler2D _RandomTextureSampler;

		float _Strength = 1.0;
		float _Base = 0.0;
		float _Area = 0.035;
		float _Falloff = 0.01;
		float _Radius = 0.025;
     
        struct v2f {
            float4 pos : POSITION;
            float2 uv : TEXCOORD0;
        };
        
        struct v2f_m {
			float4 pos : POSITION;
			float2 depth : TEXCOORD0;
		};
       
        v2f vert (appdata_img v)
        {
            v2f o;
           
            o.pos = mul (UNITY_MATRIX_MVP, v.vertex);

            o.uv = v.texcoord.xy;
            return o;
        }

       	v2f_m vertDepth (appdata_img v)
		{
			v2f_m o;
			
			o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
			float2 uv = v.texcoord.xy;
			COMPUTE_EYEDEPTH(o.depth);
			
			return o;
		}
       
        float3 normal_from_depth(float depth, float2 texcoords) {
            const float2 offset1 = float2(0.0,0.001);
            const float2 offset2 = float2(0.001,0.0);

            float depth1 = tex2D(_DepthTextureSampler, texcoords + offset1).r;
            float depth2 = tex2D(_DepthTextureSampler, texcoords + offset2).r;

            float3 p1 = float3(offset1, depth1 - depth);
            float3 p2 = float3(offset2, depth2 - depth);

            float3 normal = cross(p1, p2);
            normal.z = -normal.z;

            return normalize(normal);
        }  
               
        float4 ps_ssao(v2f In) : COLOR
        {
            float4 Output;
				
            const int samples = 16;

            const float3 sample_sphere[16] = {
                float3( 0.5381, 0.1856,-0.4319), float3( 0.1379, 0.2486, 0.4430),
                float3( 0.3371, 0.5679,-0.0057), float3(-0.6999,-0.0451,-0.0019),
                float3( 0.0689,-0.1598,-0.8547), float3( 0.0560, 0.0069,-0.1843),
                float3(-0.0146, 0.1402, 0.0762), float3( 0.0100,-0.1924,-0.0344),
                float3(-0.3577,-0.5301,-0.4358), float3(-0.3169, 0.1063, 0.0158),
                float3( 0.0103,-0.5869, 0.0046), float3(-0.0897,-0.4940, 0.3287),
                float3( 0.7119,-0.0154,-0.0918), float3(-0.0533, 0.0596,-0.5411),
                float3( 0.0352,-0.0631, 0.5460), float3(-0.4776, 0.2847,-0.0271)
                };

//            const float3 sample_sphere[8] = {
//                    float3(0.01305719,0.5872321,-0.119337),
//                    float3(0.3230782,0.02207272,-0.4188725),
//                    float3(-0.310725,-0.191367,0.05613686),
//                    float3(-0.4796457,0.09398766,-0.5802653),
//                    float3(0.1399992,-0.3357702,0.5596789),
//                    float3(-0.2484578,0.2555322,0.3489439),
//                    float3(0.1871898,-0.702764,-0.2317479),
//                    float3(0.8849149,0.2842076,0.368524),
//                };               
               
            float3 random = normalize( tex2D(_RandomTextureSampler, In.uv*4.0/*In.Tex0 * 4.0)*/).rgb );

            float depth;
            float3 norm;
            DecodeDepthNormal(tex2D(_DepthTextureSampler, In.uv), depth, norm);
            
            float3 position = float3(In.uv, depth);
            float3 normal = norm;

            float _Radius_depth = _Radius/depth;
            float occlusion = 0.0;
           
            for(int i=0; i < samples; i++) {
                float3 ray = _Radius_depth * reflect(sample_sphere[i], random);
                float3 hemi_ray = position + sign(dot(ray,normal)) * ray;

                float occ_depth = depth;
                float difference = depth - occ_depth;
				
				float rangeCheck = abs(depth - tex2D(_DepthTextureSampler, In.uv)) < _Radius ? 1.0 : 0.0;
                occlusion += step(_Falloff, difference) * (1.0-smoothstep(_Falloff, _Area, difference));
            }

            float ao = 1.0 - (_Strength * occlusion * (1.0 / samples));
            Output.rgb = ao + _Base;
            
            return tex2D(_MainTex, In.uv) * Output;
        }
    ENDCG
                
        SubShader {
            Cull Off ZWrite Off
            pass {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment ps_ssao
                #pragma target 3.0
                ENDCG
            }
        }
    }