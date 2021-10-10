Shader "Custom/SimpleShader3"
{
    // Hardcoded light. Lambert shading?
    Properties
    {
        // _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        // LOD 100 // LOD = Level of Detail : 여러 shader들 중 쉬운 것부터 시키려 하기 때문에 필요하다고...

        Pass
        {
            CGPROGRAM
            // what's the names of the vertex shader & fragment shader
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // The Mesh data: vertex positions, vertex normals, UVs, tangents, colors
            struct VertexInput // "VertexInput" renamed from "appdata"
            {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;

                // float4 color : COLOR;
                // float4 tangent : TANGENT;
                // float2 uv1 : TEXCOORD1;
            };

            struct VertexOutput // v2f
            {
                float4 clipSpacePos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : TEXCOORD1;
            };

            // sampler2D _MainTex;
            // float4 _MainTex_ST;

            // The Actual Vertex shader function!
            VertexOutput vert (VertexInput v) // "VertexInput" renamed from "appdata"
            {
                VertexOutput o;
                o.clipSpacePos = UnityObjectToClipPos(v.vertex);
                o.uv0 = v.uv0;
                o.normal = v.normal;
                return o;
            }

            float4 frag (VertexOutput o) : SV_Target
            {
                float2 uv = o.uv0;

                float3 lightDir = normalize(float3(1,1,1));
                float3 lightColor = float3(0.9, 0.8, 0.2);
                float3 ambientLight = float3(0.1, 0.2, 0.4);

                float lightFalloff = max(0, dot(lightDir, o.normal));
                float3 diffuseLight = lightFalloff * lightColor;

                float3 lambert = diffuseLight + ambientLight;

                return float4(lambert,0);
            }
            ENDCG
        }
    }
}