using UnityEngine;

public class MouseGlow : MonoBehaviour
{
    void Update()
    {
        Plane p = new Plane(Vector3.up, Vector3.zero);
        Vector2 mousePos = Input.mousePosition;
        Ray ray = GetComponent<Camera>().ScreenPointToRay(mousePos);
        if(p.Raycast(ray, out float enterDist)) {
            Vector3 mouseWorldPos = ray.GetPoint(enterDist);
            Shader.SetGlobalVector("_MouseWorldPos", mouseWorldPos);
        }
    }
}
