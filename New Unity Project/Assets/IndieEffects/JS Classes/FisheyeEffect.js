#pragma strict
import IndieEffects;
/* 
						---Fisheye Image Effect---
This Indie Effects script is an adaption of the Unity Pro Fisheye Effect done by me.
If you want me to attempt to convert a unity pro image effect, consult the manual for my
forum link and email address.
*/
var fxRes : IndieEffects;

@script RequireComponent (Camera)
@script AddComponentMenu ("Indie Effects/Fisheye")

var strengthX : float = 0.2f;
var strengthY : float = 0.2f;
var fishEyeShader : Shader;
private var tex : Texture2D;
private var fisheyeMaterial : Material;	
	
function Start (){	
	fxRes = GetComponent(IndieEffects);
	fisheyeMaterial = new Material(fishEyeShader);		
}
	
function Update () {
	fisheyeMaterial.mainTexture = fxRes.RT;
}

function OnPostRender() {				
	var oneOverBaseSize : float = 80.0f / 512.0f;
		
	var ar : float = (Screen.width * 1.0f) / (Screen.height * 1.0f);
	
	fisheyeMaterial.SetVector ("intensity", Vector4 (strengthX * ar * oneOverBaseSize, strengthY * oneOverBaseSize, strengthX * ar * oneOverBaseSize, strengthY * oneOverBaseSize));
	FullScreenQuad(fisheyeMaterial);
}