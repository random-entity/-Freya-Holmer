using System.Collections.Generic;
using UnityEngine;

public class ProcGeo : MonoBehaviour
{
    private void Awake()
    {
        Mesh mesh = new Mesh();
        mesh.name = "Procedural Quad";

        List<Vector3> points = new List<Vector3>()
        {
            new Vector3(-1f, 1f),
            new Vector3(1f, 1f),
            new Vector3(-1f, -1f),
            new Vector3(1f, -1f),
        };

        int[] triIndices = new int[]{
            1,0,2,
            3,1,2,
        };
        
        List<Vector3> normals = new List<Vector3>(){
            Vector3.forward,
            Vector3.forward,
            Vector3.forward,
            Vector3.forward,
        };

        List<Vector2> uvs = new List<Vector2>(){
            new Vector2(1f, 1f),
            new Vector2(0f, 1f),
            new Vector2(1f, 0f),
            new Vector2(0f, 0f),
        };

        mesh.SetVertices(points);
        mesh.triangles = triIndices;

        mesh.SetNormals(normals);
        // mesh.RecalculateNormals();

        mesh.SetUVs(0, uvs);

        GetComponent<MeshFilter>().sharedMesh = mesh;
    }
}