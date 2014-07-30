#pragma strict
import IndieEffects;

var fxRes : IndieEffects;
@script RequireComponent(Camera);
@script AddComponentMenu("Indie Effects/Vignette");

private var sampleMat : Material;
var shader : Shader;
var Vignette : Texture2D;

function RadialBlurQuad1 (renderMat : Material) {
	GL.PushMatrix();
	for (var i = 0; i < renderMat.passCount; ++i) {
		renderMat.SetPass(i);
		GL.LoadOrtho();
		GL.Begin(GL.QUADS); // Quad
		GL.Color(Color(1,1,1,1));
		GL.MultiTexCoord(0,Vector3(0,0,0));
		GL.Vertex3(-0.01,-0.01,0);
		GL.MultiTexCoord(0,Vector3(0,1,0));
		GL.Vertex3(-0.01,1.01,0);
		GL.MultiTexCoord(0,Vector3(1,1,0));
		GL.Vertex3(1.01,1.01,0);
		GL.MultiTexCoord(0,Vector3(1,0,0));
		GL.Vertex3(1.01,-0.01,0);
		GL.End();
	}
	GL.PopMatrix();
}

function RadialBlurQuad2 (renderMat : Material) {
	GL.PushMatrix();
	for (var i = 0; i < renderMat.passCount; ++i) {
		renderMat.SetPass(i);
		GL.LoadOrtho();
		GL.Begin(GL.QUADS); // Quad
		GL.Color(Color(1,1,1,1));
		GL.MultiTexCoord(0,Vector3(0,0,0));
		GL.Vertex3(-0.02,-0.02,0);
		GL.MultiTexCoord(0,Vector3(0,1,0));
		GL.Vertex3(-0.02,1.02,0);
		GL.MultiTexCoord(0,Vector3(1,1,0));
		GL.Vertex3(1.02,1.02,0);
		GL.MultiTexCoord(0,Vector3(1,0,0));
		GL.Vertex3(1.02,-0.02,0);
		GL.End();
	}
	GL.PopMatrix();
}

function RadialBlurQuad3 (renderMat : Material) {
	GL.PushMatrix();
	for (var i = 0; i < renderMat.passCount; ++i) {
		renderMat.SetPass(i);
		GL.LoadOrtho();
		GL.Begin(GL.QUADS); // Quad
		GL.Color(Color(1,1,1,1));
		GL.MultiTexCoord(0,Vector3(0,0,0));
		GL.Vertex3(-0.04,-0.04,0);
		GL.MultiTexCoord(0,Vector3(0,1,0));
		GL.Vertex3(-0.04,1.04,0);
		GL.MultiTexCoord(0,Vector3(1,1,0));
		GL.Vertex3(1.04,1.04,0);
		GL.MultiTexCoord(0,Vector3(1,0,0));
		GL.Vertex3(1.04,-0.04,0);
		GL.End();
	}
	GL.PopMatrix();
}

function RadialBlurQuad4 (renderMat : Material) {
	GL.PushMatrix();
	for (var i = 0; i < renderMat.passCount; ++i) {
		renderMat.SetPass(i);
		GL.LoadOrtho();
		GL.Begin(GL.QUADS); // Quad
		GL.Color(Color(1,1,1,1));
		GL.MultiTexCoord(0,Vector3(0,0,0));
		GL.Vertex3(-0.06,-0.06,0);
		GL.MultiTexCoord(0,Vector3(0,1,0));
		GL.Vertex3(-0.06,1.06,0);
		GL.MultiTexCoord(0,Vector3(1,1,0));
		GL.Vertex3(1.06,1.06,0);
		GL.MultiTexCoord(0,Vector3(1,0,0));
		GL.Vertex3(1.06,-0.06,0);
		GL.End();
	}
	GL.PopMatrix();
}

function RadialBlurQuad5 (renderMat : Material) {
	GL.PushMatrix();
	for (var i = 0; i < renderMat.passCount; ++i) {
		renderMat.SetPass(i);
		GL.LoadOrtho();
		GL.Begin(GL.QUADS); // Quad
		GL.Color(Color(1,1,1,1));
		GL.MultiTexCoord(0,Vector3(0,0,0));
		GL.Vertex3(-0.08,-0.08,0);
		GL.MultiTexCoord(0,Vector3(0,1,0));
		GL.Vertex3(-0.08,1.08,0);
		GL.MultiTexCoord(0,Vector3(1,1,0));
		GL.Vertex3(1.08,1.08,0);
		GL.MultiTexCoord(0,Vector3(1,0,0));
		GL.Vertex3(1.08,-0.08,0);
		GL.End();
	}
	GL.PopMatrix();
}

function RadialBlurQuad6 (renderMat : Material) {
	GL.PushMatrix();
	for (var i = 0; i < renderMat.passCount; ++i) {
		renderMat.SetPass(i);
		GL.LoadOrtho();
		GL.Begin(GL.QUADS); // Quad
		GL.Color(Color(1,1,1,1));
		GL.MultiTexCoord(0,Vector3(0,0,0));
		GL.Vertex3(-0.1,-0.1,0);
		GL.MultiTexCoord(0,Vector3(0,1,0));
		GL.Vertex3(-0.1,1.1,0);
		GL.MultiTexCoord(0,Vector3(1,1,0));
		GL.Vertex3(1.1,1.1,0);
		GL.MultiTexCoord(0,Vector3(1,0,0));
		GL.Vertex3(1.1,-0.1,0);
		GL.End();
	}
	GL.PopMatrix();
}


function Start () {
	fxRes = GetComponent(IndieEffects);
	sampleMat = new Material(shader);
}

function Update () {
	sampleMat.SetTexture("_MainTex",fxRes.RT);
	sampleMat.SetTexture("_Vignette",Vignette);
}

function OnPostRender () {
	FullScreenQuad(sampleMat);
	RadialBlurQuad1(sampleMat);
	RadialBlurQuad2(sampleMat);
	RadialBlurQuad3(sampleMat);
	RadialBlurQuad4(sampleMat);
	RadialBlurQuad5(sampleMat);
	RadialBlurQuad6(sampleMat);
}