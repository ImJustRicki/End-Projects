using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DirectionalLight : MonoBehaviour
{
    public Color color;
    public float intensity;
    public Vector3 direction;

    void Update()
    {
        Shader.SetGlobalVector("_DirectionalLightDirection", direction.normalized);
        Shader.SetGlobalColor("_DirectionalLightColor", color * intensity);
    }
}
