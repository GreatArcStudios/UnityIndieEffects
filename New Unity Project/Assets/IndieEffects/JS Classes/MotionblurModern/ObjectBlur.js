var lastModelView : Matrix4x4 = Matrix4x4.identity;

function OnWillRenderObject()
{
	var view : Matrix4x4 = Camera.current.worldToCameraMatrix;
	var model : Matrix4x4 = calculateModelMatrix();
	
	lastModelView = view * model;
}

function calculateModelMatrix()
{
	if( renderer == SkinnedMeshRenderer )
	{
		var rootBone : Transform = (renderer).rootBone;
		return Matrix4x4.TRS( rootBone.position, rootBone.rotation, Vector3.one );
	}
	if( renderer.isPartOfStaticBatch )
	{
		return Matrix4x4.identity;
	}
	return Matrix4x4.TRS( transform.position, transform.rotation, calculateScale() );
}

function calculateScale()
{
	var scale : Vector3 = Vector3.one;
	
	// the model is uniformly scaled, so we'll use localScale in the model matrix
	if( transform.localScale.x == Vector3.one.x * transform.localScale.x )
	{
		scale = transform.localScale;
	}
	
	// recursively multiply scale by each parent up the chain
	var parent : Transform = transform.parent;
	while( parent != null )
	{
		scale = new Vector3( scale.x * parent.localScale.x, scale.y * parent.localScale.y, scale.z * parent.localScale.z );
		parent = parent.parent;
	}
	return scale;
}