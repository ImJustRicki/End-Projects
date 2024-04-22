Shader"Unlit/Phong"
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

v2f vert(appdata v)
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

            // point light
float3 _PointLightPosition;
float3 _PointLightColor;
float _PointLightRange;

            // directional light
float3 _DirectionalLightDirection;
float3 _DirectionalLightColor;

            // spotlight
float3 _SpotLightPosition;
float3 _SpotLightDirection;
float3 _SpotLightColor;
float _SpotLightRange;
float _SpotLightAngle;

float4 frag(v2f i) : SV_Target
{
                // point light
    float3 pointLightDir = normalize(_PointLightPosition - i.position);
    float pointLightAttenuation = saturate(1.0 - distance(i.position, _PointLightPosition) / _PointLightRange);
    float3 pointLightDiffuse = _PointLightColor * _Diffuse * max(dot(i.normal, pointLightDir), 0.0) * pointLightAttenuation;

                // directional light
    float3 directionalLightDir = normalize(_DirectionalLightDirection);
    float3 directionalLightDiffuse = _DirectionalLightColor * _Diffuse * max(dot(i.normal, directionalLightDir), 0.0);

                // spotlight
    float3 spotLightDir = normalize(_SpotLightPosition - i.position);
    float spotLightAttenuation = saturate(1.0 - distance(i.position, _SpotLightPosition) / _SpotLightRange);
    float spotLightDot = dot(-spotLightDir, normalize(_SpotLightDirection));
    float spotLightDiffuse = _SpotLightColor * _Diffuse * max(dot(i.normal, spotLightDir), 0.0) * saturate((spotLightDot - _SpotLightAngle) / (1.0 - _SpotLightAngle)) * spotLightAttenuation;

               
    float4 col = float4(0.0, 0.0, 0.0, 1.0);
    col += _LightColor * _Ambient;
    col += pointLightDiffuse;
    col += directionalLightDiffuse;
    col += _LightColor * pow(dot(-normalize(_CameraPosition - i.position), reflect(-normalize(_LightPosition - i.position), normalize(i.normal))), _Specular);
    col += spotLightDiffuse;

    return col;
}
            ENDCG
        }
    }
}                               