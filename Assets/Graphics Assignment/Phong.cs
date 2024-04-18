using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Phong : MonoBehaviour
{
    public GameObject[] objects;
    Material phong;

    public Color lightColor;

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
        phong.SetColor("_LightColor", lightColor);
        phong.SetVector("_LightPosition", transform.position);
        phong.SetVector("_CameraPosition", Camera.main.transform.position);

        phong.SetFloat("_Ambient", ambient);
        phong.SetFloat("_Diffuse", diffuse);
        phong.SetFloat("_Specular", specular);
    }
}
