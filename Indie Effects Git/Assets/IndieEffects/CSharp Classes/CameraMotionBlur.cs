using UnityEngine;

/*
	CameraMotionBlur.js
	This effect creates a motion blur effect when the camera is moved.
	Object motion blur is with this not possible, but it gives a good impression
	of speed. The effect is a bit wobbly, I think the bigger the depth texture 
	resolution is the stabler the effect (not confirmed). Please change the intensity for your needs
	
	~0tacun
*/
 
//[RequireComponent(typeof(IndieEffects))]
[AddComponentMenu("Indie Effects/CameraMotionBlur C#")]
public class CameraMotionBlur : MonoBehaviour
{ 
    public IndieEffects fxRes;
			 
    private Material blurMat;
    public Shader shader;
    public float intensity = 0.05f;
			 
    private Matrix4x4 previousViewProjectionMatrix;
 
    public void Start () {
	    fxRes = GetComponent<IndieEffects>();
	    blurMat = new Material(shader);
	
	    previousViewProjectionMatrix = fxRes.DepthCam.camera.projectionMatrix * fxRes.DepthCam.camera.worldToCameraMatrix;
   
    }

 
    public void OnPostRender () 
    { 
	    Matrix4x4 viewProjection = fxRes.DepthCam.camera.projectionMatrix * fxRes.DepthCam.camera.worldToCameraMatrix;
        Matrix4x4 inverseViewProjection = viewProjection.inverse; 
 
	    blurMat.SetMatrix("_inverseViewProjectionMatrix" , inverseViewProjection);
	    blurMat.SetMatrix("_previousViewProjectionMatrix" , previousViewProjectionMatrix);
	   
	    blurMat.SetFloat("_intensity", intensity);
   
	    blurMat.SetTexture("_MainTex", fxRes.RT);
	    blurMat.SetTexture("_CameraDepthTexture", fxRes.DNBuffer);  
      
	    IndieEffects.FullScreenQuad(blurMat);
   
	    previousViewProjectionMatrix = viewProjection;
    }
}