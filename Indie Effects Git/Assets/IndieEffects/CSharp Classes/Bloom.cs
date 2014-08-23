using UnityEngine;
 
[RequireComponent(typeof(IndieEffects))]
[AddComponentMenu("Indie Effects/Image Bloom C#")]
public class Bloom : MonoBehaviour
{
    public IndieEffects fxRes;

    private Material bloomMat;
    public Shader bloomShader;
    public float threshold;
    public float amount;
    public Texture2D newTex;
 
    public void Start () {
    fxRes = GetComponent<IndieEffects>();
    newTex = new Texture2D(fxRes.textureSize, fxRes.textureSize, TextureFormat.RGB24, false);
    newTex.wrapMode = TextureWrapMode.Clamp;
    bloomMat = new Material(bloomShader);
    }

    public void OnGUI() {
	    bloomMat.SetFloat("_Threshold", threshold);
	    bloomMat.SetFloat("_Amount", amount);
	    bloomMat.SetTexture("_MainTex", fxRes.RT);
	    bloomMat.SetTexture("_BlurTex", fxRes.RT);
	    IndieEffects.FullScreenQuad(bloomMat);
    }
}