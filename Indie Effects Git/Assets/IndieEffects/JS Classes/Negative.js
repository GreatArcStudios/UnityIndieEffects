#pragma strict
import IndieEffects;
/*

				----------Negative----------
When i was playing around with the indie effects motion blur shader, i got 
this effect by accident. enjoy!
*/
@script RequireComponent (IndieEffects)
@script AddComponentMenu ("Indie Effects/Negative")
var fxRes : IndieEffects;

private var ThermoMat : Material;
var shader : Shader;
var noise : float;

function Start () {
	fxRes = GetComponent(IndieEffects);
	ThermoMat = new Material(shader);
}

function Update () {
	ThermoMat.SetTexture("_MainTex", fxRes.RT);
}

function OnPostRender () {
	FullScreenQuad(ThermoMat);
}