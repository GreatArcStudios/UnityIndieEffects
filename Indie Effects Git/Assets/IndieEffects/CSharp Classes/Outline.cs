using UnityEngine;

[RequireComponent(typeof( IndieEffects))]
[AddComponentMenu("Indie Effects/Outline C#")]
public class Outline : MonoBehaviour
{

    public IndieEffects fxRes ;

    public float threshold;
    private Material blurMat;
    public Shader outlineShader; 

    public void Start () {
        fxRes = GetComponent<IndieEffects>();
        blurMat = new Material(outlineShader);
    }
    public void Update () {
        blurMat.SetTexture("_MainTex", fxRes.RT);
        blurMat.SetFloat("_Treshold", threshold);
    }
    public void OnPostRender () {
        IndieEffects.FullScreenQuad(blurMat);
    }
}