using UnityEngine;
using System.Collections;

/*
----------Indie Effects Base----------
This is the base for all other image effects to occur. Includes depth texture generation
*/

[RequireComponent(typeof(Camera))]
[AddComponentMenu("Indie Effects/IndieEffectsBase C#")]
public class IndieEffects : MonoBehaviour
{
    //base effects
    [HideInInspector]
    public Texture2D RT;
    public int textureSize;
    public bool capture;
    public Shader DepthShader;
    public Texture2D DNBuffer;
    public bool DNRequire;
    public GameObject DepthCam;
    [Range(0f, 0.04f)]
    public float latency;

    public bool useOldVersion; //enable old rendering method
    public Camera myCamera; //cache camera and transform component for 
    private Transform myTransform; //performance

    public static void FullScreenQuad(Material renderMat) 
    {
        GL.PushMatrix();
        for (var i = 0; i < renderMat.passCount; ++i) 
        {
            renderMat.SetPass(i);

            GL.LoadOrtho();
            GL.Begin(GL.QUADS); // Quad
            GL.Color(new Color(1f, 1f, 1f, 1f));
            GL.MultiTexCoord(0, new Vector3(0f, 0f, 0f));
            GL.Vertex3(0,0,0);
            GL.MultiTexCoord(0, new Vector3(0f, 1f, 0f));
            GL.Vertex3(0,1,0);
            GL.MultiTexCoord(0, new Vector3(1f, 1f, 0f));
            GL.Vertex3(1,1,0);
            GL.MultiTexCoord(0, new Vector3(1f, 0f, 0f));
            GL.Vertex3(1,0,0);
            GL.End();
        }
        GL.PopMatrix();
    }
    
    public static void FullScreenQuad(Material renderMat, int pass) 
    {
        GL.PushMatrix();
        for (var i = 0; i < pass; ++i) {
            renderMat.SetPass(i);
            GL.LoadOrtho();
            GL.Begin(GL.QUADS); // Quad
            GL.Color(new Color(1f, 1f, 1f, 1f));
            GL.MultiTexCoord(0, new Vector3(0f, 0f, 0f));
            GL.Vertex3(0,0,0);
            GL.MultiTexCoord(0, new Vector3(0f, 1f, 0f));
            GL.Vertex3(0,1,0);
            GL.MultiTexCoord(0, new Vector3(1f, 1f, 0f));
            GL.Vertex3(1,1,0);
            GL.MultiTexCoord(0, new Vector3(1f, 0f, 0f));
            GL.Vertex3(1,0,0);
            GL.End();
        }
        GL.PopMatrix();
    }

    public static Texture2D screenGrab( Texture2D rt, Rect camRect )
    {
        float asp = Camera.current.pixelWidth / Camera.current.pixelHeight;
        GameObject dom = new GameObject("capture", typeof(Camera));
        dom.camera.aspect = asp;
        dom.camera.pixelRect = camRect;
        dom.transform.position = Camera.current.transform.position;
        dom.transform.rotation = Camera.current.transform.rotation;
        dom.camera.Render();
        rt.ReadPixels(camRect, 0, 0);
        rt.Apply();
        Destroy(dom);

        return rt;
    }

    public Rect prevRect;
    public float asp;
    public GameObject dom;
    public void OnPreRender () 
    {
        if( !useOldVersion )
        {		
            asp = camera.pixelWidth/camera.pixelHeight;
            if (!DepthCam)
            {
                DepthCam = new GameObject("DepthCamera", typeof(Camera));
                DepthCam.camera.CopyFrom(camera);
                DepthCam.camera.depth = camera.depth-2;
            }
            if (!dom)
            {
                dom = new GameObject("capture", typeof(Camera));
                dom.camera.CopyFrom(camera);
                dom.camera.depth = camera.depth-3;
            }
            if (capture && DNRequire) 
            {
                DepthCam.transform.position = camera.transform.position;
                DepthCam.transform.rotation = camera.transform.rotation;
                DepthCam.camera.SetReplacementShader(DepthShader, "RenderType");
                DepthCam.camera.aspect = asp;
                DepthCam.camera.pixelRect = new Rect(0,0,textureSize,textureSize);
                DepthCam.camera.Render();
                DNBuffer.ReadPixels(new Rect(0, 0, textureSize, textureSize), 0, 0);
                DNBuffer.Apply();
            }
            if (capture) 
            {
                dom.transform.position = camera.transform.position;
                dom.transform.rotation = camera.transform.rotation;
                dom.camera.aspect = asp;
                dom.camera.pixelRect = new Rect(0, 0, textureSize, textureSize);
                dom.camera.Render();
                RT.ReadPixels(new Rect(camera.pixelRect.x, camera.pixelRect.y, textureSize, textureSize), 0, 0);
                RT.Apply();
            }
	
        } else 
        {
            if( DNRequire ) 
            {
                //for old rendering method
                if (!DepthCam){
                    DepthCam = new GameObject("DepthCamera", typeof(Camera));
                    DepthCam.camera.CopyFrom(myCamera);
                    DepthCam.camera.depth = myCamera.depth-2;
                }

                DepthCam.transform.position = myTransform.position;
                DepthCam.transform.rotation = myTransform.rotation;
                DepthCam.camera.SetReplacementShader(DepthShader, "RenderType");
                DepthCam.camera.aspect = myCamera.aspect;
                DepthCam.camera.pixelRect = myCamera.pixelRect;
                DepthCam.camera.Render();
                DNBuffer.Resize(Mathf.RoundToInt(myCamera.pixelWidth), Mathf.RoundToInt(myCamera.pixelHeight), TextureFormat.RGB24, false);
                DNBuffer.ReadPixels(myCamera.pixelRect, 0, 0);
                DNBuffer.Apply();
		
            }
		
        }
    }

    public void OnPostRender() 
    {
        if( useOldVersion )
        {
            RT.Resize(Mathf.RoundToInt(myCamera.pixelWidth), Mathf.RoundToInt(myCamera.pixelHeight), TextureFormat.RGB24, false);
            RT.ReadPixels(myCamera.pixelRect, 0, 0);
	   
            RT.Apply();	
        }
    }

    public IEnumerator Start () 
    {	
        myTransform = transform;
        myCamera = GetComponent<Camera>();
	
        if( !useOldVersion )
        {		
            capture = true;
            RT = new Texture2D(textureSize, textureSize, TextureFormat.RGB24, false);
            RT.wrapMode = TextureWrapMode.Clamp;
            DNBuffer = new Texture2D(textureSize, textureSize, TextureFormat.ARGB32, false);
            DNBuffer.wrapMode = TextureWrapMode.Clamp;

            while(Application.isPlaying)
            {
                capture = true;
                yield return new WaitForSeconds(latency);
            }
	
        } else 
        {
            //old approuch
            //possible for splitscreen too
            RT = new Texture2D(Mathf.RoundToInt(myCamera.pixelWidth), Mathf.RoundToInt(myCamera.pixelHeight), TextureFormat.RGB24, false);
            //RT.wrapMode = TextureWrapMode.Clamp;
            DNBuffer = new Texture2D(Mathf.RoundToInt(myCamera.pixelWidth), Mathf.RoundToInt(myCamera.pixelHeight), TextureFormat.ARGB32, false);
            yield break;
        }
    }
}