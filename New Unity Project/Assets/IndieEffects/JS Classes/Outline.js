#pragma strict
import IndieEffects;

@script RequireComponent (IndieEffects)
@script AddComponentMenu ("Indie Effects/Outline")

var fxRes : IndieEffects;

var threshold : float;
private var blurMat : Material;
var outlineShader : Shader; 

function Start () {
    fxRes = GetComponent("IndieEffects");
    blurMat = new Material(outlineShader);
}
function Update () {
    blurMat.SetTexture("_MainTex", fxRes.RT);
    blurMat.SetFloat("_Treshold", threshold);
}
function OnPostRender () {
    FullScreenQuad(blurMat);
}