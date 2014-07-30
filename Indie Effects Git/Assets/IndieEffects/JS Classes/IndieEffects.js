#pragma strict
/*
----------Indie Effects Base----------
This is the base for all other image effects to occur. Includes depth texture generation
*/

@script RequireComponent(Camera);
@script AddComponentMenu("Indie Effects/IndieEffectsBase")

//base effects
@script HideInInspector var RT : Texture2D;
var textureSize : int;
var capture : boolean;
var DepthShader : Shader;
var DNBuffer : Texture2D;
var DNRequire : boolean;
var DepthCam : GameObject;
@Range(0,0.04)
var latency : float;

static function FullScreenQuad(renderMat : Material) {
	GL.PushMatrix();
	for (var i = 0; i < renderMat.passCount; ++i) {
		renderMat.SetPass(i);
		GL.LoadOrtho();
		GL.Begin(GL.QUADS); // Quad
		GL.Color(Color(1,1,1,1));
		GL.MultiTexCoord(0,Vector3(0,0,0));
		GL.Vertex3(0,0,0);
		GL.MultiTexCoord(0,Vector3(0,1,0));
		GL.Vertex3(0,1,0);
		GL.MultiTexCoord(0,Vector3(1,1,0));
		GL.Vertex3(1,1,0);
		GL.MultiTexCoord(0,Vector3(1,0,0));
		GL.Vertex3(1,0,0);
		GL.End();
	}
	GL.PopMatrix();
}

static function FullScreenQuadPass(renderMat : Material, pass : int){
	GL.PushMatrix();
	for (var i = 0; i < pass; ++i) {
		renderMat.SetPass(i);
		GL.LoadOrtho();
		GL.Begin(GL.QUADS); // Quad
		GL.Color(Color(1,1,1,1));
		GL.MultiTexCoord(0,Vector3(0,0,0));
		GL.Vertex3(0,0,0);
		GL.MultiTexCoord(0,Vector3(0,1,0));
		GL.Vertex3(0,1,0);
		GL.MultiTexCoord(0,Vector3(1,1,0));
		GL.Vertex3(1,1,0);
		GL.MultiTexCoord(0,Vector3(1,0,0));
		GL.Vertex3(1,0,0);
		GL.End();
	}
	GL.PopMatrix();
}

static function screenGrab ( rt : Texture2D, camRect : Rect ) {
	var asp = Camera.current.pixelWidth/Camera.current.pixelHeight;
	var dom = new GameObject("capture", Camera);
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

var prevRect : Rect;
var asp : float;
var dom : GameObject;
function OnPreRender () {
	asp = camera.pixelWidth/camera.pixelHeight;
	if (!DepthCam){
		DepthCam = new GameObject("DepthCamera",Camera);
		DepthCam.camera.CopyFrom(camera);
		DepthCam.camera.depth = camera.depth-2;
	}
	if (!dom){
		dom = new GameObject("capture", Camera);
		dom.camera.CopyFrom(camera);
		dom.camera.depth = camera.depth-3;
	}
	if (capture && DNRequire) {
		DepthCam.transform.position = camera.transform.position;
		DepthCam.transform.rotation = camera.transform.rotation;
		DepthCam.camera.SetReplacementShader(DepthShader, "RenderType");
		DepthCam.camera.aspect = asp;
		DepthCam.camera.pixelRect = Rect(0,0,textureSize,textureSize);
		DepthCam.camera.Render();
		DNBuffer.ReadPixels(Rect(0,0,textureSize,textureSize), 0, 0);
		DNBuffer.Apply();
	}
	if (capture) {
		dom.transform.position = camera.transform.position;
		dom.transform.rotation = camera.transform.rotation;
		dom.camera.aspect = asp;
		dom.camera.pixelRect = Rect(0,0,textureSize,textureSize);
		dom.camera.Render();
		RT.ReadPixels(Rect(camera.pixelRect.x,camera.pixelRect.y,textureSize,textureSize), 0, 0);
		RT.Apply();
	}
}

function Start () {
	capture = true;
	RT = new Texture2D(textureSize, textureSize, TextureFormat.RGB24, false);
	RT.wrapMode = TextureWrapMode.Clamp;
	DNBuffer = new Texture2D(textureSize, textureSize, TextureFormat.ARGB32, false);
	DNBuffer.wrapMode = TextureWrapMode.Clamp;
	while(true) {
		capture = true;
		yield WaitForSeconds(latency);
	}
}