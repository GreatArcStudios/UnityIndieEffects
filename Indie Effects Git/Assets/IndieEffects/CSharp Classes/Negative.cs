using UnityEngine;

/*

				----------Negative----------
When i was playing around with the indie effects motion blur shader, i got 
this effect by accident. enjoy!
*/
[RequireComponent(typeof(IndieEffects))]
[AddComponentMenu("Indie Effects/Negative C#")]
public class Negative : MonoBehaviour
{
    public IndieEffects fxRes;

    private Material ThermoMat;
    public Shader shader;
    public float noise;

    public void Start () {
	    fxRes = GetComponent<IndieEffects>();
	    ThermoMat = new Material(shader);
    }

    public void Update () {
	    ThermoMat.SetTexture("_MainTex", fxRes.RT);
    }

    public void OnPostRender () {
	    IndieEffects.FullScreenQuad(ThermoMat);
    }
}