#pragma strict
 
@script RequireComponent (IndieEffects)
@script AddComponentMenu ("Indie Effects/Image Bloom")
import IndieEffects;
var fxRes : IndieEffects;

private var bloomMat : Material;
var bloomShader : Shader;
var threshold : float;
var amount : float;
var newTex : Texture2D;
 
function Start () {
fxRes = GetComponent(IndieEffects);
newTex = new Texture2D(fxRes.textureSize, fxRes.textureSize, TextureFormat.RGB24, false);
newTex.wrapMode = TextureWrapMode.Clamp;
bloomMat = new Material(bloomShader);
}

function OnGUI() {
	bloomMat.SetFloat("_Threshold", threshold);
	bloomMat.SetFloat("_Amount", amount);
	bloomMat.SetTexture("_MainTex", fxRes.RT);
	bloomMat.SetTexture("_BlurTex", fxRes.RT);
	FullScreenQuad(bloomMat);
}