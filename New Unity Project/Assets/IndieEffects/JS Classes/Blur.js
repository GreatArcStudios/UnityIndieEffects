#pragma strict
import IndieEffects;

@script RequireComponent (IndieEffects)
@script AddComponentMenu ("Indie Effects/Blur")
var fxRes : IndieEffects;

private var blurMat : Material;
var blurShader : Shader;
@range(0,5)
var blur : float;

function Start () {
	fxRes = GetComponent(IndieEffects);
	blurMat = new Material(blurShader);
}

function Update () {
	blurMat.SetTexture("_MainTex", fxRes.RT);
	blurMat.SetFloat("_Amount", blur);
}

function OnPostRender () {
	FullScreenQuad(blurMat);
}