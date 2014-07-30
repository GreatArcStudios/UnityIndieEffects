Shader "IndieEffects/Negative" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Pass {
			Blend OneMinusDstColor Zero
			SetTexture [_MainTex] {
			combine texture, constant
			}
		}
		Pass {
			Blend DstColor OneMinusSrcColor
			SetTexture [_MainTex] {
			combine texture - previous
			}
		}
	} 
	FallBack Off
}
