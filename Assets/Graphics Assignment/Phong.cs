using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Phong : MonoBehaviour
{
    public GameObject[] objects;
    Material phong;

    public Color pointLightColor;
    public Vector3 pointLightPosition;
    public float pointLightIntensity;

    public Color[] spotLightColors;
    public Vector3[] spotLightPositions;
    public float[] spotLightIntensities;

    public Color directionalLightColor;
    public Vector3 directionalLightDirection;
    public float directionalLightIntensity;

    [Range(0.0f, 1.0f)]
    public float ambient;

    [Range(0.0f, 1.0f)]
    public float diffuse;

    [Range(2.0f, 256.0f)]
    public float specular;

    // Clamps x to a power of 2 (specular exponent)!
    float ToNearest(float x)
    {
        return Mathf.Pow(2, Mathf.Round(Mathf.Log(x) / Mathf.Log(2.0f)));
    }

    void Start()
    {
        phong = GetComponent<MeshRenderer>().material;
        for (int i = 0; i < objects.Length; i++)
            objects[i].GetComponent<MeshRenderer>().material = phong;
    }

    void Update()
    {
        specular = ToNearest(specular);
        phong.SetColor("_PointLightColor", pointLightColor);
        phong.SetVector("_PointLightPosition", pointLightPosition);
        phong.SetFloat("_PointLightIntensity", pointLightIntensity);

        for (int i = 0; i < spotLightColors.Length; i++)
        {
            phong.SetColor("_SpotLightColor" + (i + 1), spotLightColors[i]);
            phong.SetVector("_SpotLightPosition" + (i + 1), spotLightPositions[i]);
            phong.SetFloat("_SpotLightIntensity" + (i + 1), spotLightIntensities[i]);
        }

        phong.SetColor("_DirectionalLightColor", directionalLightColor);
        phong.SetVector("_DirectionalLightDirection", directionalLightDirection);
        phong.SetFloat("_DirectionalLightIntensity", directionalLightIntensity);

        phong.SetVector("_CameraPosition", Camera.main.transform.position);

        phong.SetFloat("_Ambient", ambient);
        phong.SetFloat("_Diffuse", diffuse);
        phong.SetFloat("_Specular", specular);
    }
}
