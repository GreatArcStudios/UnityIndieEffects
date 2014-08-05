<h1> Unity Indie Effects </h1>

![iFx](http://i.imgur.com/0VxIOeL.png "iFx")

<h2> <b>True Image Effects for Unity free</b> </h2>
<hr>
<h3> <i style="color:blue"> Introduction: </i> </h3>
<h4><b>Welcome!</b></h4> <p> This here is <b><i><u>the</u></i></b> Indie Effects pack, one of the <b><u>only free</u></b> ways of getting image effects in Unity free. With this epic pack, you can do fisheye lensing, motion blur, bloom and lighting FX, SSAO, vignetting, chromatic aberration, radial blur, and an easy to use API to code your own FX!
But where’s the motion blur you ask? Unfortunately, an improvement in performance came at the cost of breaking the original motion blur, so for now, there is none. I am working on a camera-based solution that uses motion vectors instead.</p> 
<hr></	hr>
<b>Basic Setup and Use in Unity Free:</b>

Here are the basic setup steps. Unlike previous versions, it isn’t as fiddly as it was anymore! Now, let’s get started:
<ul>
<li>First, open the project you are going to use these FX in, then extract the IndieEffects.zip to your assets folder. This can be done in windows by opening the .zip, then clicking “extract all files” at the top.</li>
<li>Once Unity finishes importing the package, go to your main camera, and click “Add Component” then browse to the newly created “Indie Effects” section, then add an effect of your choice. <del>To use motion blur, add the base script, then enable motion blur.</del> For other FX, these auto-add the base script automatically, if it isn’t there already.</li>
<li>If you want to tweak your newly added FX, then head to the “Tweaking” section of this doc for details, otherwise skip this step.</li>
<li>To use some fx, you will need to tick the checkbox marked “DNRequire” mainly for DoF</li>
<li>Click play to preview. Behold… YOUR NEW FX!</li>
</ul>

<b>Examples of effects (more to come): </b>
![iFx](http://i.imgur.com/do1EofT.png "iFx")

<h3>Custom Image Effects:<h3>
![iFx](http://i.imgur.com/ncq0KXI.png "iFx")

When writing your own effects for Indie Effects API you will need knowledge of the functions contained within.


For a basic view of how a script interfacing to this API should work, here is a basic template for any “indie effect” (you can use this as a base if you like!) Copy and paste this code into a new JavaScript, then tweak it however you like:

Javascript example:

```javascript
	#pragma strict
	@script RequireComponent(IndieEffects)
	@script AddComponentMenu(“Indie Effects/FX Skeleton”)

	Import IndieEffects;
	var fxRes : IndieEffects;

	private var mat : Material;
	var shader : Shader;

	function Start () {
		fxRes = GetComponent(IndieEffects);
		mat : new Material(shader);
	}

	function Update () {
		mat.SetTexture(“_MainTex”, fxRes.RT);
		//if your effect doesn’t use depth buffer, comment this out
		mat.SetTexture(“_Depth”, fxRes.DNBuffer);
	}

	function OnPostRender () {
		FullScreenQuad(mat);
	}
```
C# example:

<i> note the c# version still needs to be ported.</i>
```csharp

  using IndieEffects;
  
  [RequireComponent(IndieEffects)]
  [AddComponentMenu(“Indie Effects/FX Skeleton”)]
  public class ExampleEffect : MonoBehaviour {
    private Material mat;
    public Shader shader;
    public IndieEffects fxRes;
    
    void Start (){
      fxRes = GetComponent(IndieEffects);
      mat = new Material(shader);
    }
    
    void Update (){
      mat.SetTexture(“_MainTex”, fxRes.RT);
	  	//if your effect doesn’t use depth buffer, comment this out
		  mat.SetTexture(“_Depth”, fxRes.DNBuffer);
    }
    
    void OnPostRender (){
      fxRes.FullScreenQuad(mat);
    }
    
  }
```


When using effects with depth buffer, use the variable DNBuffer in the base script to assign to the shader. It is also possible to remove the @script lines up top for a performance boost, but it is not recommended you do this until final build time.

Effects Included in the package:
<ol>
<li>Fisheye (adapted from the Unity Pro Fisheye effect)</li>
<li>	Simply adjust the X and Y values to get the fisheye. DO NOT USE NEGATIVE VALUES!!!</li>
<li>Negative (this reverses colour)</li>
<li>	A drag ‘n’ drop effect. Reverses and distorts color.</li>
<li>	Anti-Aliasing (Ported From Unity Pro)</li>
<li>	A port of the FXAA shaders from Unity Pro! Simply adjust the settings to your liking, or pick the FXAAPresetB or A for smoothest Plug ‘n’ Play result!</li>
<li>	Vignetting (may darken screen too much, so use sparingly)</li>
<li>	Simply adjust the value, then set the vignette texture. Some textures are included for you to experiment.</li>



<li>	Radial Blur/God Rays (God rays deprecated. A new effect is going to be made soon that uses gameObject origin instead. FuzzyQuills suggests sticking with radial blur only!)</li>
<li>	Adjust the values carefully, and make sure Radial Blur is selected, otherwise the screen will be FLOODED with sunlight!</li>
<li>	Colour Balance (A nice colour adjustment script for your games)</li>
<li>	Simply adjust the values. Note the script is reported to be not working in the latest version of unity 4. </li>
<li>	Image Bloom (a new bloom effect from my labs)</li>
<li>	This bloom effect uses a new and improved blurring algorithm, and looks real nice.</li>
<li>	Blur (based on the Image Bloom)</li>
<li>	Adjust the slider to blur the scene</li>
<li>	SSAO:
<li>	A new SSAO implementation without needing a blur pass! This implementation uses the Bunell disk algorithm. For best results, I recommend setting the strength to 2. If you wish, feel free to fiddle with the other settings!</li>
<li>	DoF (A nice thing to add, er, depth to the scene!)</li>
<li>	This effect has two sliders – A blurring slider and an F-Stop. Adjust the values to get the desired effect. This effect now culls trees and other transparent objects better.</li>
<li>	A nice toon outline for games where using multiple toon variants isn’t feasible. To make the lines either thicker or thinner, set intensity to anything other than 0. Having it at 0 gives a black screen which kinda defeats the purpose, so it isn’t recommended you do this!</li>
<li>Chromatic Abberation: A brand-new vignetting/chroma effect. Make your games go HIIIGH, with this sick-as effect!</li>
<hr></hr>
<b><h3>Help:</h3></b>

If you want to make a comment, give credit, or need help with this, you can email FuzzyQuills at neubot321@gmail.com. You can also post on the Indie Effects thread at [Indie Effects Thread](http://forum.unity3d.com/threads/indieeffects-bringing-almost-aaa-quality-post-process-fx-to-unity-indie.198568/"Indie Effects Thread")  if you like to help other users or want to give credit! (Or even suggest a new effect you think FuzzyQuills could do. There are lots of suggestions being posted all the time)
Coming soon:
Various bloom fx, to spruce up scenes. Thanks to FrostBite23 for offering to port them!
Sun shafts effect. Again, thank Frosty!
Cyrien5100, for helping out with SSAO. FrostBite23 now has a new SSAO coming as well.

Credits:


Main Project Lead: FuzzyQuills

Color Balance Script provided by Tryder.
Bloom script written by me. Base Bloom shader provided by Tryder, and tweaked by FuzzyQuills.

Special Thanks:
<ul>
<li>Tryder, for the colour balance script and the base bloom shader.</li>
<li>Unity Technologies, for giving us the most epic game engine ever!</li>
<li>All of the community, for giving my thread the best feedback, including inspiration for depth of field!</li>
<li>Cyrien5100 and related users for their dedication to the creation of the SSAO effect!</li>
<li>0tacun, for several contributions and ideas, example: outline effect.</li>
<li>FrostBite23, for porting a bunch of dirty lens effects and other nice eye-candy.</li>
<li>Eric2241, for helping support the project, hosting and maintaing the GitHub repo! He also the one  to thank for other fx found on page 13-14 of the thread!</li>
</ul>
