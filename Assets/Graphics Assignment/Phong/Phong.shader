Shader "Unlit/Phong"
{
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
                o.position = mul(unity_ObjectToWorld, v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv;
                return o;
            }

            float4 _LightColor;
            float3 _LightPosition;
            float3 _CameraPosition;
            float _Ambient;
            float _Diffuse;
            float _Specular;

            float4 frag (v2f i) : SV_Target
            {
                float3 N = normalize(i.normal);
                float3 L = normalize(_LightPosition - i.position);
                float3 V = normalize(_CameraPosition - i.position);
                float3 R = reflect(-L, N);

                float dotNL = max(dot(N, L), 0.0);
                float dotVR = max(dot(V, R), 0.0);

                float4 col = float4(0.0, 0.0, 0.0, 1.0);
                col += _LightColor * _Ambient;
                col += _LightColor * _Diffuse * dotNL;
                col += _LightColor * pow(dotVR, _Specular);
                return col;
            }
            ENDCG
        }
    }
}
