using UnityEngine;

[RequireComponent(typeof(Camera))]
[AddComponentMenu("Indie Effects/Motion Blur C#")]
public class motionBlurModern : MonoBehaviour
{
    public IndieEffects fxRes;

    private Material blurMat;
    public Shader blurShader;
    public Shader VectorsShader;
    [Range(0.0f, 0.1f)]
    public float intensity = 0.001f;
    public Texture2D prevDepth;

    public Matrix4x4 previousViewProjectionMatrix;

    public void Start () 
    {
	    fxRes = GetComponent<IndieEffects>();
        blurMat = new Material(blurShader);
        previousViewProjectionMatrix = camera.projectionMatrix * camera.worldToCameraMatrix;
    }
    
    public void OnPostRender () 
    {
        Matrix4x4 viewProjection = camera.projectionMatrix * camera.worldToCameraMatrix;
	    //vector map generation
        Matrix4x4 inverseViewProjection = viewProjection.inverse;
        blurMat.SetMatrix("_inverseViewProjectionMatrix" , inverseViewProjection);
        blurMat.SetMatrix("_previousViewProjectionMatrix" , previousViewProjectionMatrix);
        blurMat.SetFloat("_intensity", intensity);
        blurMat.SetTexture("_MainTex", fxRes.RT);
        blurMat.SetTexture("_Depth", fxRes.DNBuffer);
        IndieEffects.FullScreenQuad(blurMat);
        previousViewProjectionMatrix = viewProjection;
    }
}