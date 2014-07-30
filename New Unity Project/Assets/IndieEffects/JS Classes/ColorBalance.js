/*
This script is intended for use with Fuzzy Quill's True Motion Blur for Unity free script.
Shader variable is intended for the ColorBalance shader that should have been provided
along with this script.

-Adam T. Ryder
http://1337atr.weebly.com
*/
import IndieEffects;
@script RequireComponent (IndieEffects)
@script AddComponentMenu ("Indie Effects/Color Balance")
var fxRes : IndieEffects;

private var mat : Material;
var shader : Shader;

var Lift : Color = Color(1.0, 1.0, 1.0, 1.0);
var LiftBright : float = 1.0;
var Gamma : Color = Color(1.0, 1.0, 1.0, 1.0);
var GammaBright : float = 1.0;
var Gain : Color = Color(1.0, 1.0, 1.0, 1.0);
var GainBright : float = 1.0;

function Start () {
	fxRes = GetComponent(IndieEffects);
	mat = new Material(shader);
	mat.SetColor("_Lift", Lift);
	mat.SetFloat("_LiftB", Mathf.Clamp(LiftBright, 0.0, 2.0));
	mat.SetColor("_Gamma", Gamma);
	mat.SetFloat("_GammaB", Mathf.Clamp(GammaBright, 0.0, 2.0));
	mat.SetColor("_Gain", Gain);
	mat.SetFloat("_GainB", Mathf.Clamp(GainBright, 0.0, 2.0));
}

function Update () {
	mat.SetTexture("_MainTex", fxRes.RT);
}

function OnPostRender () {
	FullScreenQuad(mat);
}