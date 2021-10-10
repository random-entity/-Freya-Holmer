Shader "Custom/SimpleShader1"
{
    // UV coordinates to color
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

                // float4 color : COLOR;
                // float4 normal : NORMAL;
                // float4 tangent : TANGENT;
                // float2 uv1 : TEXTCOORD1;
            };

            struct VertexOutput // v2f
            {
                float4 clipSpacePos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };

            // sampler2D _MainTex;
            // float4 _MainTex_ST;

            // The Actual Vertex shader function!
            VertexOutput vert (VertexInput v) // "VertexInput" renamed from "appdata"
            {
                VertexOutput o;
                o.uv0 = v.uv0;
                o.clipSpacePos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            float4 frag (VertexOutput o) : SV_Target
            {
                float2 uv = o.uv0;
                return float4(uv,0,0);
            }
            ENDCG
        }
    }
}