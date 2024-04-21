Shader "Unlit/Phong"
{
    Properties
    {
        // Common properties for all shapes
        _Ambient ("Ambient Intensity", Range(0, 1)) = 0.1
        _Diffuse ("Diffuse Intensity", Range(0, 1)) = 1.0
        _Specular ("Specular Intensity", Range(0, 1)) = 1.0
        _Radius ("Light Radius", Float) = 15.0
        _Cutoff ("Spot Light Cutoff", Float) = 0.707 // Cosine of 45 degrees

        // Properties for each shape
        _PointLightColor ("Point Light Color", Color) = (1, 1, 1)
        _SpotLightColor ("Spot Light Color", Color) = (1, 1, 1)
        _DirectionalLightColor ("Directional Light Color", Color) = (1, 1, 1)
        _PointLightIntensity ("Point Light Intensity", Range(0, 1)) = 1.0
        _SpotLightIntensity ("Spot Light Intensity", Range(0, 1)) = 1.0
        _DirectionalLightIntensity ("Directional Light Intensity", Range(0, 1)) = 1.0
        _PointLightPosition ("Point Light Position", Vector) = (0, 0, 0)
        _SpotLightPosition ("Spot Light Position", Vector) = (0, 0, 0)
        _DirectionalLightDirection ("Directional Light Direction", Vector) = (0, 0, -1)
        _CameraPosition ("Camera Position", Vector) = (0, 0, 0)
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
            uniform float _Ambient;
            uniform float _Diffuse;
            uniform float _Specular;
            uniform float _Radius;
            uniform float _Cutoff;

            uniform float4 _PointLightColor;
            uniform float4 _SpotLightColor;
            uniform float4 _DirectionalLightColor;
            uniform float _PointLightIntensity;
            uniform float _SpotLightIntensity;
            uniform float _DirectionalLightIntensity;
            uniform float3 _PointLightPosition;
            uniform float3 _SpotLightPosition;
            uniform float3 _DirectionalLightDirection;
            uniform float3 _CameraPosition;

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

                // Phong lighting contribution from spot light
                float3 spotLightColor = float3(0.0, 0.0, 0.0);
                float3 spotToLight = _SpotLightPosition - i.position;
                float distanceToSpotLight = length(spotToLight);
                float spotAttenuation = clamp(1.0 - distanceToSpotLight / _Radius, 0.0, 1.0);
                float3 spotDirection = normalize(spotToLight);
                float spotAngle = dot(-spotDirection, _DirectionalLightDirection);
                if (spotAngle > _Cutoff)
                {
                    L = normalize(spotToLight);
                    dotNL = max(dot(N, L), 0.0);
                    spotLightColor += _SpotLightColor.rgb * _Diffuse * dotNL * spotAttenuation * _SpotLightIntensity;
                    R = reflect(-L, N);
                    dotVR = max(dot(V, R), 0.0);
                    spotLightColor += _SpotLightColor.rgb * pow(dotVR, _Specular) * spotAttenuation * _SpotLightIntensity;
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