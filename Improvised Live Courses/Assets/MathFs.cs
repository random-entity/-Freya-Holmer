using UnityEngine;

public static class MathFs
{
    public const float TWOPI = 6.28318530718f;

    public static Vector2 GetUnitVectorByAngle(float angRad)
    {
        return new Vector2(Mathf.Cos(angRad), Mathf.Sin(angRad));
    }
}
