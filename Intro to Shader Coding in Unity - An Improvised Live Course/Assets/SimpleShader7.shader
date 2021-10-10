Shader "Custom/SimpleShader7"
{
    // Mouse glow
    Properties
    {
        _Color ("Color", Color) = (1,1,1,0)
        _Gloss ("Gloss", Float) = 1
        _Steps ("Steps", Int) = 3
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
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            // The Mesh data: vertex positions, vertex normals, UVs, tangents, colors
            struct VertexInput // "VertexInput" renamed from "appdata"
            {
                float4 vertex : POSITION; // Mesh local position
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;

                // float4 color : COLOR;
                // float4 tangent : TANGENT;
                // float2 uv1 : TEXCOORD1;
            };

            struct VertexOutput // v2f 
            { // These are interpolated automatically for each fragment
                float4 clipSpacePos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            float4 _Color;
            float _Gloss;
            float _Threshold;
            int _Steps;
            uniform float3 _MouseWorldPos;

            // sampler2D _MainTex;
            // float4 _MainTex_ST;

            // The Actual Vertex shader function!
            VertexOutput vert (VertexInput v) // "VertexInput" renamed from "appdata"
            {
                VertexOutput o;
                o.clipSpacePos = UnityObjectToClipPos(v.vertex);
                o.uv0 = v.uv0;
                o.normal = v.normal;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            float3 Posterize(int steps, float3 value) 
            {
                return floor(steps * value) / steps;
            }

            float4 frag (VertexOutput o) : SV_Target
            {
                float dist = distance(_MouseWorldPos, o.worldPos);
                float glow = saturate(1 - dist);

                float2 uv = o.uv0;
                float3 normal = normalize(o.normal); // Interpolated, so length can be <= 1.

                // Lighting
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float3 lightColor = _LightColor0.rgb; // https://docs.unity3d.com/Manual/SL-UnityShaderVariables.html
                
                // Direct diffuse light
                float lightFalloff = max(0, dot(lightDir, normal));
                // lightFalloff = step(_Threshold, lightFalloff);
                // lightFalloff = floor(lightFalloff * 8) / 8;
                float3 directDiffuseLight = lightFalloff * lightColor;
                
                // Ambient light
                float3 ambientLight = float3(0.1, 0.1, 0.1);

                // Direct specular light
                float3 camPos = _WorldSpaceCameraPos;
                float3 fragToCam = camPos - o.worldPos;
                float3 viewDir = normalize(fragToCam);
                float3 viewReflection = reflect(-viewDir, normal);
                float specularFalloff = max(0, dot(viewReflection, lightDir));
                // specularFalloff = step(_Threshold, specularFalloff);
                // specularFalloff = floor(specularFalloff * 8) / 8;

                specularFalloff = pow(specularFalloff, _Gloss);

                float3 directSpecular = specularFalloff * lightColor;

                // Composite
                float3 diffuseLight = ambientLight + directDiffuseLight;
                float3 finalSurfaceColor = (diffuseLight + directSpecular) * _Color.rgb + glow;
                finalSurfaceColor = Posterize(_Steps, finalSurfaceColor);
                
                return float4(finalSurfaceColor, 0);
            }
            ENDCG
        }
    }
}