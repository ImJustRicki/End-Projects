Shader "Unlit/SpotLight"
{
Properties
    {
        _SpotlightColor ("Spotlight Color", Color) = (1,1,1,1)
        _SpotlightPosition ("Spotlight Position", Vector) = (0,0,0,1)
        _SpotlightDirection ("Spotlight Direction", Vector) = (0,-1,0,0)
        _SpotlightIntensity ("Spotlight Intensity", Float) = 1.0
        _SpotlightAngle ("Spotlight Angle", Float) = 30.0
        _SpotlightRange ("Spotlight Range", Float) = 10.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 _SpotlightColor;
            float4 _SpotlightPosition;
            float4 _SpotlightDirection;
            float _SpotlightIntensity;
            float _SpotlightAngle;
            float _SpotlightRange;

            fixed4 frag (v2f i) : SV_Target
            {
                float3 toLight = _WorldSpaceLightPos0.xyz - _SpotlightPosition.xyz;
                float distanceToLight = length(toLight);
                toLight /= distanceToLight; // normalize

                // Calculate the angle between the light direction and the spotlight direction
                float spotDot = dot(toLight, -normalize(_SpotlightDirection.xyz));
                float spotlightFactor = smoothstep(cos(radians(_SpotlightAngle)), 1.0, spotDot);

                // Apply falloff
                float attenuation = clamp(1.0 - distanceToLight / _SpotlightRange, 0.0, 1.0);

                // Calculate final color
                fixed4 col = _SpotlightColor * _SpotlightIntensity * spotlightFactor * attenuation;
                return col;
            }
            ENDCG
        }
    }
}