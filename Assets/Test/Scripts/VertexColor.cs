using UnityEngine;
using System.Collections;

public class VertexColor : MonoBehaviour {

	// Sets the vertex color to be red at the y=0 and green at y=1.
	// (Note that most builtin shaders don't display vertex colors, you can
	// use eg. a particle shader to see vertex colors)
	void Start () {

		Mesh mesh = GetComponent<MeshFilter>().mesh;
		Vector3[] vertices = mesh.vertices;
		Color[] colors  = new Color[vertices.Length];

		Debug.Log (vertices.Length);

		for (var i = 0; i < vertices.Length;i++)
			colors[i] = Color.Lerp(Color.red, Color.green, vertices[i].y);
		mesh.colors = colors;
	}
}
