using UnityEngine;

// Here is a Bunell Disk Screen Space Ambient Occlusion or Disk to Disk SSAO implementation, ported in Unity Free by Cyrien5100 (me).
// Original technique was developped by Arkano22 based on an Nvidia Implementaion, but in geometry space.
// Arkano22 modified it to work in Screen Space.
// About me, i translated the shader in CG (original was GLSL), and i tweaked/customized it a little, to work correctly in Unity.
// If you use it in your games, please say my name in credits ;)
// Big thanks to Arkano22 for creating this EPIC technique, to FuzzyQuills for IndieEffects, to 0tacun for helping in position reconstruction, 
// to #Include Graphics and bwhiting from GameDev forum for helping me about self occlusion problem.
[RequireComponent(typeof(IndieEffects))]
[AddComponentMenu("Indie Effects/Screen Space Ambient Occlusion C#")]
public class SSAO_C5100 : MonoBehaviour
{
    public IndieEffects fxRes;

    public Texture2D randTex;
    public float bias = 1;
    public float samplingRadius= 1.0f;
    public float scale= 0.8f;
    [Range(2,8)]
    public int iterations = 3;
    [Range(0.7f, 0.9f)] 
    public float selfOcclusion = 0.8f;
    public float strength = 2.0f;

    public Material materialAO;
    public Shader shaderAO;

    public void Start () 
    {
	    fxRes = GetComponent<IndieEffects>();
	    materialAO = new Material (shaderAO);
    }


    public void Update () 
    {
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

	    Matrix4x4 P = camera.projectionMatrix;
	    Matrix4x4 invP = P.inverse;
	    invP = invP.transpose;
	    materialAO.SetMatrix ("_InvProj", invP); // Set the 4x4 Matrix
    }

    public void OnPostRender()
    {
	    IndieEffects.FullScreenQuad(materialAO);
    }
}