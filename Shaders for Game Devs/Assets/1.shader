Shader "Unlit/1"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1, 0, 0, 1)
        _ColorB ("Color B", Color) = (0, 1, 0, 1)
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Transparent" 
            "Queue"="Transparent"
        }
        Pass
        {
            ZTest Always
            ZWrite Off
            Cull Off
            Blend One One // additive
            // Blend DstColor Zero // multiplicative

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            float4 _ColorA;
            float4 _ColorB;

            #include "UnityCG.cginc"

            #define TAU 6.28318530718

            float inverseLerp(float a, float b, float x) 
            {
                return (x - a) / (b - a);
            }

            struct MeshData
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                float offset = 0.02 * cos(i.uv.x * TAU * 8);
                float t = 0.5 * (1 - cos((i.uv.y + offset - 0.1 * _Time.y) * TAU * 5));
                t *= 1 - i.uv.y;

                float topBottomRemover = abs(i.normal.y) < 0.999;
                float waves = t * topBottomRemover;
                float4 gradient = lerp(_ColorA, _ColorB, i.uv.y);

                return waves * gradient;
            }
            ENDCG
        }
    }
}