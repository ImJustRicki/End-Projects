Shader "Unlit/Phong"
{
    Properties
    {
        _PointLightColor ("Point Light Color", Color) = (1, 1, 1, 1)
        _PointLightIntensity ("Point Light Intensity", Range(0, 10)) = 1.0
        _SpotLightColor1 ("Spot Light Color 1", Color) = (1, 0, 0, 1)
        _SpotLightIntensity1 ("Spot Light Intensity 1", Range(0, 10)) = 1.0
        _SpotLightColor2 ("Spot Light Color 2", Color) = (0, 1, 0, 1)
        _SpotLightIntensity2 ("Spot Light Intensity 2", Range(0, 10)) = 1.0
        _SpotLightColor3 ("Spot Light Color 3", Color) = (0, 0, 1, 1)
        _SpotLightIntensity3 ("Spot Light Intensity 3", Range(0, 10)) = 1.0
        _DirectionalLightColor ("Directional Light Color", Color) = (1, 1, 1, 1)
        _DirectionalLightIntensity ("Directional Light Intensity", Range(0, 10)) = 1.0
        _Ambient ("Ambient Intensity", Range(0, 1)) = 0.1
        _Diffuse ("Diffuse Intensity", Range(0, 1)) = 1.0
        _Specular ("Specular Intensity", Range(0, 1)) = 1.0
        _Radius ("Light Radius", Float) = 15.0
        _Cutoff ("Spot Light Cutoff", Float) = 0.707 // Cosine of 45 degrees
    }

    SubShader
    {
        Pass
         {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 position : TEXCOORD2;
                float3 normal : TEXCOORD1;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.position = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv;
                return o;
            }

            // Uniform variables declaration
            uniform float4 _PointLightColor;
            uniform float _PointLightIntensity;
            uniform float3 _PointLightPosition;
            uniform float3 _SpotLightColor1;
            uniform float _SpotLightIntensity1;
            uniform float3 _SpotLightPosition1; // Declaration for spot light position 1
            uniform float3 _SpotLightColor2;
            uniform float _SpotLightIntensity2;
            uniform float3 _SpotLightPosition2; // Declaration for spot light position 2
            uniform float3 _SpotLightColor3;
            uniform float _SpotLightIntensity3;
            uniform float3 _SpotLightPosition3; // Declaration for spot light position 3
            uniform float3 _DirectionalLightColor;
            uniform float _DirectionalLightIntensity;
            uniform float3 _DirectionalLightDirection; // Add declaration for directional light direction
            uniform float3 _CameraPosition;
            uniform float _Ambient;
            uniform float _Diffuse;
            uniform float _Specular;
            uniform float _Radius;
            uniform float _Cutoff;

            float4 frag (v2f i) : SV_Target
            {
                float3 N = normalize(i.normal);
                float3 V = normalize(_CameraPosition - i.position);

                // Phong lighting contribution from point light
                float3 pointLightColor = _PointLightColor.rgb * _Ambient * _PointLightIntensity;
                float3 pointToLight = _PointLightPosition - i.position;
                float distanceToPointLight = length(pointToLight);
                float attenuation = clamp(1.0 - distanceToPointLight / _Radius, 0.0, 1.0);
                float3 L = normalize(pointToLight);
                float dotNL = max(dot(N, L), 0.0);
                pointLightColor += _PointLightColor.rgb * _Diffuse * dotNL * attenuation * _PointLightIntensity;
                float3 R = reflect(-L, N);
                float dotVR = max(dot(V, R), 0.0);
                pointLightColor += _PointLightColor.rgb * pow(dotVR, _Specular) * attenuation * _PointLightIntensity;

                // Phong lighting contribution from spot lights
                float3 spotLightColor = float3(0.0, 0.0, 0.0);
                float3 spotLightPositions[3] = { _SpotLightPosition1, _SpotLightPosition2, _SpotLightPosition3 };
                float spotLightIntensities[3] = { _SpotLightIntensity1, _SpotLightIntensity2, _SpotLightIntensity3 };
                float3 spotLightColors[3] = { _SpotLightColor1, _SpotLightColor2, _SpotLightColor3 };
                for (int j = 0; j < 3; j++)
                {
                    float3 spotToLight = spotLightPositions[j] - i.position;
                    float distanceToSpotLight = length(spotToLight);
                    float spotAttenuation = clamp(1.0 - distanceToSpotLight / _Radius, 0.0, 1.0);
                    float3 spotDirection = normalize(spotToLight); // Corrected spot light direction calculation
                    float spotAngle = dot(-spotDirection, _DirectionalLightDirection); // Use the direction of the light source
                    if (spotAngle > _Cutoff)
                    {
                        L = normalize(spotToLight);
                        dotNL = max(dot(N, L), 0.0);
                        spotLightColor += spotLightColors[j] * _Diffuse * dotNL * spotAttenuation * spotLightIntensities[j];
                        R = reflect(-L, N);
                        dotVR = max(dot(V, R), 0.0);
                        spotLightColor += spotLightColors[j] * pow(dotVR, _Specular) * spotAttenuation * spotLightIntensities[j];
                    }
                }

                // Phong lighting contribution from directional light
                float3 directionLightColor = _DirectionalLightColor.rgb * _Diffuse * dotNL * _DirectionalLightIntensity;
                R = reflect(-L, N);
                dotVR = max(dot(V, R), 0.0);
                directionLightColor += _DirectionalLightColor.rgb * pow(dotVR, _Specular) * _DirectionalLightIntensity;

                
                float3 finalColor = pointLightColor + spotLightColor + directionLightColor;
                return float4(finalColor, 1.0);
            }
            ENDCG
        }
    }
}
