// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/My First Shader" 
{

    Properties
    {
        _Tint ("Tint", Color) = (1, 1, 1, 1)
        _MainTex("Texture", 2D) = "White" 
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram

            #include "UnityCG.cginc"

            float4 _Tint;
            sampler2D _MainTex;

            struct Interpolators {
                float4 position: SV_POSITION;
                float2 uv: TEXCOORD0;
            };

            struct VertexData {
                float4 position: POSITION;
                float2 uv: TEXCOORD0;
            };

            Interpolators MyVertexProgram (VertexData v)
            {
                //Define a struct of interpolators
                Interpolators i;

                i.uv = v.uv;

                //Convert the vertex's position in model space to projection space
                i.position = UnityObjectToClipPos(v.position); 
                return i;
            }

            float4 MyFragmentProgram(Interpolators i) : SV_TARGET
            {
                return float4(i.uv, 1, 1);
            }
            ENDCG
        }
    }
}