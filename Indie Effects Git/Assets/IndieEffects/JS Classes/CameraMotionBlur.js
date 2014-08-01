/*
	CameraMotionBlur.js
	This effect creates a motion blur effect when the camera is moved.
	Object motion blur is with this not possible, but it gives a good impression
	of speed. The effect is a bit wobbly, I think the bigger the depth texture 
	resolution is the stabler the effect (not confirmed). Please change the intensity for your needs
	
	~0tacun
*/
#pragma strict
 
//@script RequireComponent (IndieEffects)
@script AddComponentMenu ("Indie Effects/CameraMotionBlur")
 
			var fxRes : IndieEffects;
			 
	private var blurMat : Material;
			var shader : Shader;
			var intensity : float = 0.05;
			 
	private var previousViewProjectionMatrix : Matrix4x4;
 
function Start () {
	fxRes = transform.GetComponent("IndieEffects");
	blurMat = new Material(shader);
	
	previousViewProjectionMatrix = fxRes.DepthCam.camera.projectionMatrix * fxRes.DepthCam.camera.worldToCameraMatrix;
   
}

 
function OnPostRender () {

 
	var viewProjection : Matrix4x4 = fxRes.DepthCam.camera.projectionMatrix * fxRes.DepthCam.camera.worldToCameraMatrix;
	var inverseViewProjection : Matrix4x4 = viewProjection.inverse;
 
 
	blurMat.SetMatrix("_inverseViewProjectionMatrix" , inverseViewProjection);
	blurMat.SetMatrix("_previousViewProjectionMatrix" , previousViewProjectionMatrix);
	   
	blurMat.SetFloat("_intensity", intensity);
   
	blurMat.SetTexture("_MainTex", fxRes.RT);
	blurMat.SetTexture("_CameraDepthTexture", fxRes.DNBuffer);
   
   
   
	FullScreenQuad(blurMat);
   
	previousViewProjectionMatrix = viewProjection;
}
