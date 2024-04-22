using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PointLight : MonoBehaviour
{
    public Color color;
    public float intensity;
    public float range;

    void Update()
    {
        Shader.SetGlobalVector("_PointLightPosition", transform.position);
        Shader.SetGlobalColor("_PointLightColor", color * intensity);
        Shader.SetGlobalFloat("_PointLightRange", range);
    }
}
