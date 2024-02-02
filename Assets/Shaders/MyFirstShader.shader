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
            //Originally standed for scale and translation but currently it is Tiling and Offset
            float4 _MainTex_ST;

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

                //Simply passing on original uv coords to fragment shader
                // i.uv = v.uv;

                //Take mesh's uv coord and Tile it according to provided input
                // i.uv = v.uv * _MainTex_ST.xy;

                //Take mesh's uv coord and account for Tiling(Scaling) and Offset (Translation)
                i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;

                //Storing the vertex's position in model space and passed onto fragment for fragment interpolation
                // localPosition = position.xyz;

                //Convert the vertex's position in model space to projection space
                i.position = UnityObjectToClipPos(v.position); 
                return i;
            }

            float4 MyFragmentProgram(Interpolators i) : SV_TARGET
            {

                //To display the representation of localCoords
                // return float4(localPosition, 1)

                //To fix the colours being clamped to 0.5, as some channels end up becoming -1/2
                //  return float4(localPosition + 0.5, 1)

                //Sample the texture with the provided uv coordinates
                // return tex2D(_MainTex, i.uv);

                //Factor in tint when utilising texture
                return tex2D(_MainTex, i.uv) * _Tint;
            }
            ENDCG
        }
    }
}