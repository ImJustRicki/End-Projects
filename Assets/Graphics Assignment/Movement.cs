using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour
{
    [SerializeField] public float translationMagnitude = 1f;
    [SerializeField] public float rotationMagnitude = 45f; // in degrees
    [SerializeField] public float scaleMagnitude = 0.5f;
    [SerializeField] public float frequency = 1f;

    private Vector3 initialPosition;
    private Quaternion initialRotation;
    private Vector3 initialScale;

    void Start()
    {
        // Store initial transform values
        initialPosition = transform.position;
        initialRotation = transform.rotation;
        initialScale = transform.localScale;
    }

    void Update()
    {
        // Calculate new transform values using sine and cosine functions
        float translationOffsetX = Mathf.Sin(Time.time * frequency) * translationMagnitude;
        float translationOffsetY = Mathf.Cos(Time.time * frequency) * translationMagnitude;
        float translationOffsetZ = Mathf.Sin(Time.time * frequency) * translationMagnitude;

        float rotationOffset = Mathf.Cos(Time.time * frequency) * rotationMagnitude;

        float scaleOffsetX = Mathf.Sin(Time.time * frequency) * scaleMagnitude;
        float scaleOffsetY = Mathf.Sin(Time.time * frequency) * scaleMagnitude;
        float scaleOffsetZ = Mathf.Sin(Time.time * frequency) * scaleMagnitude;

        // Apply changes to transform
        transform.position = initialPosition + new Vector3(translationOffsetX, translationOffsetY, translationOffsetZ);
        transform.rotation = initialRotation * Quaternion.Euler(rotationOffset, rotationOffset, rotationOffset);
        transform.localScale = initialScale + new Vector3(scaleOffsetX, scaleOffsetY, scaleOffsetZ);
    }
}
