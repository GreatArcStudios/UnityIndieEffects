using UnityEngine;

[RequireComponent(typeof(IndieEffects))]
[AddComponentMenu("Indie Effects/Depth of Field C#")]
public class DepthOfField : MonoBehaviour
{
    public IndieEffects fxRes;

    public Shader shader;
    private Material DOFMat;
    [Range (0,10)]
    public float FStop;
    [Range (0,5)]
    public float BlurAmount;

    public void Start () {
	    fxRes = GetComponent<IndieEffects>();
	    DOFMat = new Material(shader);
    }

    public void OnPostRender () {
	    DOFMat.SetTexture("_MainTex",fxRes.RT);
	    DOFMat.SetTexture("_Depth",fxRes.DNBuffer);
	    DOFMat.SetFloat ("_FStop", FStop*10);
	    DOFMat.SetFloat ("_Amount", BlurAmount);
	    IndieEffects.FullScreenQuad(DOFMat);
    }
}