// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Texture with Detail" 
{

    Properties
    {
        _Tint ("Tint", Color) = (1, 1, 1, 1)
        _MainTex("Texture", 2D) = "white" 
        _DetailTex("Detail Texture", 2D) = "gray"
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
            sampler2D _MainTex, _DetailTex;
            //Originally standed for scale and translation but currently it is Tiling and Offset
            float4 _MainTex_ST, _DetailTex_ST;

            struct Interpolators {
                float4 position: SV_POSITION;
                float2 uv: TEXCOORD0;
                float2 uvDetail: TEXCOORD1;
            };

            struct VertexData {
                float4 position: POSITION;
                float2 uv: TEXCOORD0;
            };

            Interpolators MyVertexProgram (VertexData v)
            {
                //Define a struct of interpolators
                Interpolators i;

                //Take mesh's uv coord and account for Tiling(Scaling) and Offset (Translation)
                i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;

                //Account for Tiling and Offset for DETAIL Texture
                i.uvDetail = v.uv * _DetailTex_ST.xy + _DetailTex_ST.zw;

                //Convert the vertex's position in model space to projection space
                i.position = UnityObjectToClipPos(v.position); 
                return i;
            }

            float4 MyFragmentProgram(Interpolators i) : SV_TARGET
            {
                //Factor in tint when utilising texture
                float4 color =  tex2D(_MainTex, i.uv) * _Tint;

                //Samples and adds detail along with brightening it
                // color *= tex2D(_MainTex, i.uv * 10) * 2;

                //Samples a detail texture
                color *= tex2D(_DetailTex, i.uvDetail);
                return color;
            }
            ENDCG
        }
    }
}