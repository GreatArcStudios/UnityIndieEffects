using UnityEngine;

[RequireComponent(typeof(IndieEffects))]
[AddComponentMenu("Indie Effects/Chromatic Abberation C#")]
public class ChromaticAbberation : MonoBehaviour
{
    public IndieEffects fxRes;
    public Shader shader;
    private Material chromMat;
    public Texture2D vignette;

    public void Start () {
	    fxRes = GetComponent<IndieEffects>();
	    chromMat = new Material(shader);
    }

    public void OnPostRender () {
	    chromMat.SetTexture("_MainTex", fxRes.RT);
	    chromMat.SetTexture("_Vignette", vignette);
	    IndieEffects.FullScreenQuad(chromMat);
    }
}