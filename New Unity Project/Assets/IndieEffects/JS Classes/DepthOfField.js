#pragma strict
import IndieEffects;

@script RequireComponent(IndieEffects)
@script AddComponentMenu("Indie Effects/Depth of Field")
var fxRes : IndieEffects;

var shader : Shader;
private var DOFMat : Material;
@range (0,10)
var FStop : float;
@range (0,5)
var BlurAmount : float;

function Start () {
	fxRes = GetComponent(IndieEffects);
	DOFMat = new Material(shader);
}

function OnPostRender () {
	DOFMat.SetTexture("_MainTex",fxRes.RT);
	DOFMat.SetTexture("_Depth",fxRes.DNBuffer);
	DOFMat.SetFloat ("_FStop", FStop*10);
	DOFMat.SetFloat ("_Amount", BlurAmount);
	FullScreenQuad(DOFMat);
}