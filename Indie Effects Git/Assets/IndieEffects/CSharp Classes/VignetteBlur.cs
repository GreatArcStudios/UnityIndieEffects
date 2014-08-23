using UnityEngine;

[RequireComponent(typeof(Camera))]
[AddComponentMenu("Indie Effects/Vignette C#")]
public class VignetteBlur : MonoBehaviour
{
    public IndieEffects fxRes;

    private Material sampleMat;
    public Shader shader;
    public Texture2D Vignette;

    public void RadialBlurQuad1 (Material renderMat) 
    {
	    GL.PushMatrix();
	    for (var i = 0; i < renderMat.passCount; ++i) 
        {
		    renderMat.SetPass(i);
		    GL.LoadOrtho();
		    GL.Begin(GL.QUADS); // Quad
		    GL.Color(new Color(1f, 1f, 1f, 1f));
		    GL.MultiTexCoord(0, new Vector3(0,0,0));
		    GL.Vertex3(-0.01f,-0.01f,0);
		    GL.MultiTexCoord(0, new Vector3(0,1,0));
		    GL.Vertex3(-0.01f,1.01f,0);
		    GL.MultiTexCoord(0, new Vector3(1,1,0));
		    GL.Vertex3(1.01f,1.01f,0);
		    GL.MultiTexCoord(0, new Vector3(1,0,0));
		    GL.Vertex3(1.01f,-0.01f,0);
		    GL.End();
	    }
	    GL.PopMatrix();
    }

    public void RadialBlurQuad2 (Material renderMat) {
	    GL.PushMatrix();
	    for (var i = 0; i < renderMat.passCount; ++i) {
		    renderMat.SetPass(i);
		    GL.LoadOrtho();
		    GL.Begin(GL.QUADS); // Quad
		    GL.Color(new Color(1f, 1f, 1f, 1f));
		    GL.MultiTexCoord(0, new Vector3(0,0,0));
		    GL.Vertex3(-0.02f,-0.02f,0);
		    GL.MultiTexCoord(0, new Vector3(0,1,0));
		    GL.Vertex3(-0.02f,1.02f,0);
		    GL.MultiTexCoord(0, new Vector3(1,1,0));
		    GL.Vertex3(1.02f,1.02f,0);
		    GL.MultiTexCoord(0, new Vector3(1,0,0));
		    GL.Vertex3(1.02f,-0.02f,0);
		    GL.End();
	    }
	    GL.PopMatrix();
    }

    public void RadialBlurQuad3 (Material renderMat) {
	    GL.PushMatrix();
	    for (var i = 0; i < renderMat.passCount; ++i) {
		    renderMat.SetPass(i);
		    GL.LoadOrtho();
		    GL.Begin(GL.QUADS); // Quad
		    GL.Color(new Color(1f, 1f, 1f, 1f));
		    GL.MultiTexCoord(0, new Vector3(0,0,0));
		    GL.Vertex3(-0.04f,-0.04f,0);
		    GL.MultiTexCoord(0, new Vector3(0,1,0));
		    GL.Vertex3(-0.04f,1.04f,0);
		    GL.MultiTexCoord(0, new Vector3(1,1,0));
		    GL.Vertex3(1.04f,1.04f,0);
		    GL.MultiTexCoord(0, new Vector3(1,0,0));
		    GL.Vertex3(1.04f,-0.04f,0);
		    GL.End();
	    }
	    GL.PopMatrix();
    }

    public void RadialBlurQuad4 (Material renderMat) {
	    GL.PushMatrix();
	    for (var i = 0; i < renderMat.passCount; ++i) {
		    renderMat.SetPass(i);
		    GL.LoadOrtho();
		    GL.Begin(GL.QUADS); // Quad
		    GL.Color(new Color(1f, 1f, 1f, 1f));
		    GL.MultiTexCoord(0, new Vector3(0,0,0));
		    GL.Vertex3(-0.06f,-0.06f,0);
		    GL.MultiTexCoord(0, new Vector3(0,1,0));
		    GL.Vertex3(-0.06f,1.06f,0);
		    GL.MultiTexCoord(0, new Vector3(1,1,0));
		    GL.Vertex3(1.06f,1.06f,0);
		    GL.MultiTexCoord(0, new Vector3(1,0,0));
		    GL.Vertex3(1.06f,-0.06f,0);
		    GL.End();
	    }
	    GL.PopMatrix();
    }

    public void RadialBlurQuad5 (Material renderMat) {
	    GL.PushMatrix();
	    for (var i = 0; i < renderMat.passCount; ++i) {
		    renderMat.SetPass(i);
		    GL.LoadOrtho();
		    GL.Begin(GL.QUADS); // Quad
		    GL.Color(new Color(1f, 1f, 1f, 1f));
		    GL.MultiTexCoord(0, new Vector3(0,0,0));
		    GL.Vertex3(-0.08f,-0.08f,0);
		    GL.MultiTexCoord(0, new Vector3(0,1,0));
		    GL.Vertex3(-0.08f,1.08f,0);
		    GL.MultiTexCoord(0, new Vector3(1,1,0));
		    GL.Vertex3(1.08f,1.08f,0);
		    GL.MultiTexCoord(0, new Vector3(1,0,0));
		    GL.Vertex3(1.08f,-0.08f,0);
		    GL.End();
	    }
	    GL.PopMatrix();
    }

    public void RadialBlurQuad6(Material renderMat)
    {
	    GL.PushMatrix();
	    for (var i = 0; i < renderMat.passCount; ++i) {
		    renderMat.SetPass(i);
		    GL.LoadOrtho();
		    GL.Begin(GL.QUADS); // Quad
		    GL.Color(new Color(1f, 1f, 1f, 1f));
		    GL.MultiTexCoord(0, new Vector3(0,0,0));
		    GL.Vertex3(-0.1f,-0.1f,0);
		    GL.MultiTexCoord(0, new Vector3(0,1,0));
		    GL.Vertex3(-0.1f,1.1f,0);
		    GL.MultiTexCoord(0, new Vector3(1,1,0));
		    GL.Vertex3(1.1f,1.1f,0);
		    GL.MultiTexCoord(0, new Vector3(1,0,0));
		    GL.Vertex3(1.1f,-0.1f,0);
		    GL.End();
	    }
	    GL.PopMatrix();
    }


    public void Start () {
	    fxRes = GetComponent<IndieEffects>();
	    sampleMat = new Material(shader);
    }

    public void Update () {
	    sampleMat.SetTexture("_MainTex",fxRes.RT);
	    sampleMat.SetTexture("_Vignette",Vignette);
    }

    public void OnPostRender () 
    {
	    IndieEffects.FullScreenQuad(sampleMat);

	    RadialBlurQuad1(sampleMat);
	    RadialBlurQuad2(sampleMat);
	    RadialBlurQuad3(sampleMat);
	    RadialBlurQuad4(sampleMat);
	    RadialBlurQuad5(sampleMat);
	    RadialBlurQuad6(sampleMat);
    }
}