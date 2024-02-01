using UnityEngine;

public class ScaleTransform : Transformation
{
    public Vector3 scale = new Vector3(1, 1, 1);

    public override Vector3 Apply(Vector3 point)
    {
        point.x *= scale.x;
        point.y *= scale.y;
        point.z *= scale.z;

        return point;
    }
}
