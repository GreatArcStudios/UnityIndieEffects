using UnityEngine;

[RequireComponent(typeof(IndieEffects))]
[AddComponentMenu("Indie Effects/Blur C#")]
public class Blur : MonoBehaviour
{
    public IndieEffects fxRes;

    private Material blurMat;
    public Shader blurShader;
    [Range(0,5)]
    public float blur;

    public void Start () {
	    fxRes = GetComponent<IndieEffects>();
	    blurMat = new Material(blurShader);
    }

    public void Update () {
	    blurMat.SetTexture("_MainTex", fxRes.RT);
	    blurMat.SetFloat("_Amount", blur);
    }

    public void OnPostRender () {
	    IndieEffects.FullScreenQuad(blurMat);
    }
}