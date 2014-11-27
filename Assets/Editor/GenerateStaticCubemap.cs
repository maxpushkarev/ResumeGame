using UnityEngine;
using UnityEditor;
using System.Collections;

public class GenerateStaticCubemap : ScriptableWizard {

	public Transform renderPosition;
	public Cubemap cubemap;

	[MenuItem("MyOwnShaders/Render cubemap")]
	static void RenderCubeMap()
	{
		ScriptableWizard.DisplayWizard ("RenderCubemap", typeof(GenerateStaticCubemap), "Render!");
	}


	void OnWizardUpdate() 
	{
		helpString = "Select transform to render from and cubemap to render into";

		if ((renderPosition == null) || (cubemap == null)) {
			isValid = false;
		} else {
			isValid = true;
		}

	}

	void OnWizardCreate() 
	{
		GameObject go = new GameObject("CubeCam", typeof(Camera));

		go.transform.position = renderPosition.position;
		go.transform.rotation = Quaternion.identity;

		go.camera.RenderToCubemap (cubemap);
		DestroyImmediate (go);
	}

}
