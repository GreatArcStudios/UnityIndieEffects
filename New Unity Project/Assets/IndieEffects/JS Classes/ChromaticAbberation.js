#pragma strict

@script RequireComponent(IndieEffects)
@script AddComponentMenu("Indie Effects/Chromatic Abberation")
import IndieEffects;

var fxRes : IndieEffects;
var shader : Shader;
private var chromMat : Material;
var vignette : Texture2D;

function Start () {
	fxRes = GetComponent(IndieEffects);
	chromMat = new Material(shader);
}

function OnPostRender () {
	chromMat.SetTexture("_MainTex", fxRes.RT);
	chromMat.SetTexture("_Vignette", vignette);
	FullScreenQuad(chromMat);
}