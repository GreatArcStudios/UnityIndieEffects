#pragma strict
import IndieEffects;

@script RequireComponent (IndieEffects)
@script AddComponentMenu ("Indie Effects/Motion Blur")
var fxRes : IndieEffects;

private var blurMat : Material;
var blurShader : Shader;
var VectorsShader : Shader;
@range(0.0, 0.1)
var intensity : float = 0.001;
var prevDepth : Texture2D;

var previousViewProjectionMatrix : Matrix4x4;

function Start () {
	fxRes = GetComponent(IndieEffects);
    blurMat = new Material(blurShader);
    previousViewProjectionMatrix = camera.projectionMatrix * camera.worldToCameraMatrix;
}

function Update () {
//	blurMat.SetTexture("_Depth", fxRes.DNBuffer);
}

function OnPostRender () {
    var viewProjection : Matrix4x4 = camera.projectionMatrix * camera.worldToCameraMatrix;
	//vector map generation
	var inverseViewProjection : Matrix4x4 = viewProjection.inverse;
    blurMat.SetMatrix("_inverseViewProjectionMatrix" , inverseViewProjection);
    blurMat.SetMatrix("_previousViewProjectionMatrix" , previousViewProjectionMatrix);
    blurMat.SetFloat("_intensity", intensity);
    blurMat.SetTexture("_MainTex", fxRes.RT);
    blurMat.SetTexture("_Depth", fxRes.DNBuffer);
    FullScreenQuad(blurMat);
    previousViewProjectionMatrix = viewProjection;
}