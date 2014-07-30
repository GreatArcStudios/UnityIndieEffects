#pragma strict

// Here is a Bunell Disk Screen Space Ambient Occlusion or Disk to Disk SSAO implementation, ported in Unity Free by Cyrien5100 (me).
// Original technique was developped by Arkano22 based on an Nvidia Implementaion, but in geometry space.
// Arkano22 modified it to work in Screen Space.
// About me, i translated the shader in CG (original was GLSL), and i tweaked/customized it a little, to work correctly in Unity.
// If you use it in your games, please say my name in credits ;)
// Big thanks to Arkano22 for creating this EPIC technique, to FuzzyQuills for IndieEffects, to 0tacun for helping in position reconstruction, 
// to #Include Graphics and bwhiting from GameDev forum for helping me about self occlusion problem.
@script RequireComponent(IndieEffects)
@script AddComponentMenu("Indie Effects/Screen Space Ambient Occlusion")
import IndieEffects;
var fxRes : IndieEffects;

var randTex : Texture2D;
var bias : float = 1;
var samplingRadius : float = 1.0f;
var scale : float = 0.8f;
@Range(2,8) var iterations : int = 3;
@Range(0.7f,0.9f) var selfOcclusion : float = 0.8f;
var strength : float = 2.0f;

var materialAO : Material;
var shaderAO : Shader;

function Start () {	
	fxRes = GetComponent(IndieEffects);
	materialAO = new Material (shaderAO);
}


function Update () {
//	depthTex = _NormalsDepth.DepthTex;
	materialAO.SetTexture("_MainTex", fxRes.RT);
	materialAO.SetTexture("_DepthNormalTex", fxRes.DNBuffer);
	materialAO.SetTexture("_noiseTex", randTex);
	materialAO.SetFloat("_Bias", -bias);
	materialAO.SetFloat("_scale", scale);
	materialAO.SetFloat("_sampleRad", samplingRadius*100);
	materialAO.SetInt("_iterations", iterations);
	materialAO.SetFloat("_selfOcclusion", selfOcclusion);
	materialAO.SetFloat("_strength", strength);

	var P : Matrix4x4 = camera.projectionMatrix;
	var invP : Matrix4x4 = P.inverse;
	invP = invP.transpose;
	materialAO.SetMatrix ("_InvProj", invP); // Set the 4x4 Matrix
}

function OnPostRender () {
	FullScreenQuad(materialAO);
}
