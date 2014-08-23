using UnityEngine;

/* 
						---Fisheye Image Effect---
This Indie Effects script is an adaption of the Unity Pro Fisheye Effect done by me.
If you want me to attempt to convert a unity pro image effect, consult the manual for my
forum link and email address.
*/

[RequireComponent(typeof(Camera))]
[AddComponentMenu("Indie Effects/Fisheye C#")]
public class FisheyeEffect : MonoBehaviour
{    
    public IndieEffects fxRes;
    public float strengthX = 0.2f;
    public float strengthY = 0.2f;
    public Shader fishEyeShader;
    private Texture2D tex;
    private Material fisheyeMaterial;	
	
    public void Start (){	
	    fxRes = GetComponent<IndieEffects>();
	    fisheyeMaterial = new Material(fishEyeShader);		
    }
	
    public void Update () {
	    fisheyeMaterial.mainTexture = fxRes.RT;
    }

    public void OnPostRender() 
    {				
	    float oneOverBaseSize = 80.0f / 512.0f;

        float ar = (Screen.width * 1.0f) / (Screen.height * 1.0f);
	
	    fisheyeMaterial.SetVector ("intensity", new Vector4 (strengthX * ar * oneOverBaseSize, strengthY * oneOverBaseSize, strengthX * ar * oneOverBaseSize, strengthY * oneOverBaseSize));
	    IndieEffects.FullScreenQuad(fisheyeMaterial);
    }
}