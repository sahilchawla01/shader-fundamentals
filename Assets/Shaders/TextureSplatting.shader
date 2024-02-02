// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Texture Splatting" 
{

    Properties
    {
        _MainTex("Texture", 2D) = "White" 

        //The [NoScaleOffset] attribute doesn't display Tiling and Offset in Material Inspector
        [NoScaleOffset] _Texture1("Texture", 2D) = "white"
        [NoScaleOffset] _Texture2("Texture", 2D) = "white"
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            //Originally standed for scale and translation but currently it is Tiling and Offset
            float4 _MainTex_ST;
            
            sampler2D _Texture1, _Texture2;

            struct Interpolators {
                float4 position: SV_POSITION;
                float2 uv: TEXCOORD0;
                float2 uvSplat: TEXCOORD1;
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

                //Provide the non-scaled uv to fragment
                i.uvSplat = v.uv;

                //Convert the vertex's position in model space to projection space
                i.position = UnityObjectToClipPos(v.position); 
                return i;
            }

            float4 MyFragmentProgram(Interpolators i) : SV_TARGET
            {
                float splat = tex2D(_MainTex, i.uvSplat);


                //Both textures are added
                // return tex2D(_Texture1, i.uv) + tex2D(_Texture2, i.uv);

                return tex2D(_Texture1, i.uv) * splat.r + tex2D(_Texture2, i.uv) * (1 - splat.r);
            }
            ENDCG
        }
    }
}