using UnityEngine;

public class ObjectBlur : MonoBehaviour
{
    public Matrix4x4 lastModelView = Matrix4x4.identity;

    public void OnWillRenderObject()
    {
	    Matrix4x4 view = Camera.current.worldToCameraMatrix;
        Matrix4x4 model = calculateModelMatrix();
	
	    lastModelView = view * model;
    }

    public Matrix4x4 calculateModelMatrix()
    {
	    if( renderer is SkinnedMeshRenderer )
	    {
            Transform rootBone = (renderer as SkinnedMeshRenderer).rootBone;
		    return Matrix4x4.TRS( rootBone.position, rootBone.rotation, Vector3.one );
	    }
	    if( renderer.isPartOfStaticBatch )
	    {
		    return Matrix4x4.identity;
	    }
	    return Matrix4x4.TRS( transform.position, transform.rotation, calculateScale() );
    }

    public Vector3 calculateScale()
    {
	    Vector3 scale = Vector3.one;
	
	    // the model is uniformly scaled, so we'll use localScale in the model matrix
	    if( transform.localScale.x == Vector3.one.x * transform.localScale.x )
	    {
		    scale = transform.localScale;
	    }
	
	    // recursively multiply scale by each parent up the chain
        Transform parent = transform.parent;
	    while( parent != null )
	    {
		    scale = new Vector3( scale.x * parent.localScale.x, scale.y * parent.localScale.y, scale.z * parent.localScale.z );
		    parent = parent.parent;
	    }
	    return scale;
    }
}