Shader "IndieEffects/Vignette" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Vignette("Vignette (RGBA)", 2D) = "white" {}
	}
	SubShader {
	ZTest Always Cull Off ZWrite Off
	Fog { Mode Off }
		Pass {
		blend SrcALpha OneMinusSrcAlpha
		ColorMask RGB
			SetTexture[_MainTex]{
			ConstantColor(1,1,1,0)
			combine texture, constant
			}
		}
		Pass {
		blend DstColor OneMinusDstColor
		SetTexture [_MainTex]{
		Combine Texture
		}
		}
		Pass {
		blend SrcColor OneMinusSrcColor
		ColorMask RGB
			SetTexture[_Vignette]{
			combine texture
			}
		}
	}
}
