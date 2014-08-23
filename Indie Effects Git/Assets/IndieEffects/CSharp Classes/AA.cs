using UnityEngine;

/*
---------- Anti-Aliasing Indie Effects----------

This is an adaption of Unity Pro's AA Script, done by TheBlur (me)

*/
[RequireComponent(typeof(IndieEffects))]
[AddComponentMenu("Indie Effects/Anti-Aliasing C#")]
public class AA : MonoBehaviour
{
    public IndieEffects fxRes;

    public enum AAMode {
	    FXAA2 = 0,
	    FXAA3Console = 1,		
	    FXAA1PresetA = 2,
	    FXAA1PresetB = 3,
	    NFAA = 4,
	    SSAA = 5,
	    DLAA = 6,
    }

	public AAMode mode = AAMode.FXAA3Console;

	public bool showGeneratedNormals = false;
	public float offsetScale = 0.2f;
	public float blurRadius = 18f;

	public float edgeThresholdMin = 0.05f;
	public float edgeThreshold = 0.2f;
	public float edgeSharpness  = 4.0f;
		
	public bool dlaaSharp = false;

	public Shader ssaaShader;
	private Material ssaa;
	public Shader dlaaShader;
	private Material dlaa;
	public Shader nfaaShader;
	private Material nfaa;	
	public Shader shaderFXAAPreset2;
	private Material materialFXAAPreset2;
	public Shader shaderFXAAPreset3;
	private Material materialFXAAPreset3;
	public Shader shaderFXAAII;
	private Material materialFXAAII;
	public Shader shaderFXAAIII;
	private Material materialFXAAIII;
		
	public Material CurrentAAMaterial ()
	{
		Material returnValue = null;

		switch(mode) {
			case AAMode.FXAA3Console:
				returnValue = materialFXAAIII;
				break;
			case AAMode.FXAA2:
				returnValue = materialFXAAII;
				break;
			case AAMode.FXAA1PresetA:
				returnValue = materialFXAAPreset2;
				break;
			case AAMode.FXAA1PresetB:
				returnValue = materialFXAAPreset3;
				break;
			case AAMode.NFAA:
				returnValue = nfaa;
				break;
			case AAMode.SSAA:
				returnValue = ssaa;
				break;
			case AAMode.DLAA:
				returnValue = dlaa;
				break;	
			default:
				returnValue = null;
				break;
			}
			
		return returnValue;
	}

	public void Start () 
    {
		fxRes = gameObject.GetComponent<IndieEffects>();
		materialFXAAPreset2 = new Material (shaderFXAAPreset2);
		materialFXAAPreset3 = new Material (shaderFXAAPreset3);
		materialFXAAII = new Material (shaderFXAAII);
		materialFXAAIII = new Material (shaderFXAAIII);
		nfaa = new Material (nfaaShader);
		ssaa = new Material (ssaaShader); 
		dlaa = new Material (dlaaShader); 	            
	}
	
	public void Update () 
    {   
	    materialFXAAPreset2.mainTexture = fxRes.RT;
	    materialFXAAPreset3.mainTexture = fxRes.RT;
	    materialFXAAII.mainTexture = fxRes.RT;
	    materialFXAAIII.mainTexture = fxRes.RT;
	    nfaa.mainTexture = fxRes.RT;
	    ssaa.mainTexture = fxRes.RT;
	    dlaa.mainTexture = fxRes.RT;
	}

	public void OnPostRender() 
    {

 		// .............................................................................
		// FXAA antialiasing modes .....................................................
		
		if (mode == AAMode.FXAA3Console && (materialFXAAIII != null)) {
			materialFXAAIII.SetFloat("_EdgeThresholdMin", edgeThresholdMin);
			materialFXAAIII.SetFloat("_EdgeThreshold", edgeThreshold);
			materialFXAAIII.SetFloat("_EdgeSharpness", edgeSharpness);		
		
            IndieEffects.FullScreenQuad(materialFXAAIII);
        }        
		else if (mode == AAMode.FXAA1PresetB && (materialFXAAPreset3 != null)) {
            IndieEffects.FullScreenQuad(materialFXAAPreset3);
        }
        else if(mode == AAMode.FXAA1PresetA && materialFXAAPreset2 != null) {
            fxRes.RT.anisoLevel = 4;
            IndieEffects.FullScreenQuad(materialFXAAPreset2);
            fxRes.RT.anisoLevel = 0;
        }
        else if(mode == AAMode.FXAA2 && materialFXAAII != null) {
            IndieEffects.FullScreenQuad(materialFXAAII);
        }
		else if (mode == AAMode.SSAA && ssaa != null) {

		// .............................................................................
		// SSAA antialiasing ...........................................................
			
			IndieEffects.FullScreenQuad(ssaa);								
		}
		else if (mode == AAMode.DLAA && dlaa != null) {

		// .............................................................................
		// DLAA antialiasing ...........................................................
		
			fxRes.RT.anisoLevel = 0;	
			var interim = fxRes.RT;
			IndieEffects.FullScreenQuad(dlaa);			
			IndieEffects.FullScreenQuad(dlaa);					
		}
		else if (mode == AAMode.NFAA && nfaa != null) {

		// .............................................................................
		// nfaa antialiasing ..............................................
			
			fxRes.RT.anisoLevel = 0;	
		
			nfaa.SetFloat("_OffsetScale", offsetScale);
			nfaa.SetFloat("_BlurRadius", blurRadius);
				
			IndieEffects.FullScreenQuad(nfaa);					
		}
		else {
			// none of the AA is supported, fallback to a simple blit
			IndieEffects.FullScreenQuad(null);
		}
	}
}