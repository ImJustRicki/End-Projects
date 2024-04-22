using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpotlightProjector : MonoBehaviour
{
    Material phong;

    public Color[] spotLightColors;
    public Vector3[] spotLightPositions;
    public float[] spotLightIntensities;

    void Start()
    {
        phong = GetComponent<MeshRenderer>().material;
    }

    void Update()
    {
        for (int i = 0; i < spotLightColors.Length; i++)
        {
            phong.SetColor("_SpotLightColor" + (i + 1), spotLightColors[i]);
            phong.SetVector("_SpotLightPosition" + (i + 1), spotLightPositions[i]);
            phong.SetFloat("_SpotLightIntensity" + (i + 1), spotLightIntensities[i]);
        }
    }
}