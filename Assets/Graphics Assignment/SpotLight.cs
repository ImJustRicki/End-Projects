using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpotLight : MonoBehaviour
{
    public Color color;
    public float intensity;
    public float range;
    public Vector3 direction;
    public float spotAngle;

    void Update()
    {
        Shader.SetGlobalVector("_SpotLightPosition", transform.position);
        Shader.SetGlobalVector("_SpotLightDirection", direction.normalized);
        Shader.SetGlobalColor("_SpotLightColor", color * intensity);
        Shader.SetGlobalFloat("_SpotLightRange", range);
        Shader.SetGlobalFloat("_SpotLightAngle", Mathf.Cos(spotAngle * 0.5f * Mathf.Deg2Rad));
    }
}