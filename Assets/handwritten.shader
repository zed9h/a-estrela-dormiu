Shader "handwritten"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _VecTex ("Vector", 2D) = "white" {}
        _OffsetScale ("Offset", Vector) = (0.5,0.5,1,1)
        _Thresh ("Threshold", Float) = 0.67
        _MinThresh ("MinThreshold", Float) = 0.3
        _Pow ("Power", Float) = 1
        _Scale ("Scale", Float) = 1
        _Mult ("Mult", Float) = 1
        _Circle ("Circle", Float) = 10
        _Emission ("Emission", Float) = 1
        _StarPow ("Star Power", Float) = 3
        _MergePow ("Merge Power", Float) = 2
        _Fade ("Fade", Range(0,1)) = 0.5
        _Color ("Color", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float4 _MainTex_ST;
            sampler2D _MainTex;
            sampler2D _VecTex;
            float4 _OffsetScale;
            float _Thresh;
            float _MinThresh;
            float _Pow;
            float _Scale;
            float _Mult;
            float _Circle;
            float _Emission;
            float _Fade;
            float4 _Color;
            float _StarPow;
            float _MergePow;
            
            float n21 (float2 p) {
                return frac(dot(sin(
                    p * float2(131, 159)),123.3213213));
            }
            
            float n21s (float2 p) {
                float2 i = floor(p);
                float2 f = frac(p);
                float n00 = n21(i);
                float n01 = n21(i + float2(0,1));
                float n10 = n21(i + float2(1,0));
                float n11 = n21(i + float2(1,1));
                return lerp(lerp(n00,n01,f.y), lerp(n10,n11,f.y), f.x);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 vec = tex2D(_VecTex, i.uv);
                fixed4 off = (vec - _OffsetScale.x) * _OffsetScale.z;
                off.xy *= _ScreenParams.zw;
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed star = 0;
                float s = vec.z * _Fade;
                float2 p = i.uv * _Scale //+ vec.z * _SinTime.y * 4 * s +
                    - off.xy * s // * (_SinTime.y * 0.5 + 0.5)
                    + float2(_CosTime.y,_SinTime.y) * _Circle * s;
                star += n21s(p) * 0.4; p *= 2.029;
                star += n21s(p) * 0.3; p *= 3.023;
                star += n21s(p) * 0.2; p *= 5.017;
                star += n21s(p) * 0.1; p *= 7.013;
                float t = lerp(_Thresh, _MinThresh, pow(s, _StarPow));
                star = pow(saturate(star - t) / (1-t), _Pow) * _Mult;
                return lerp(star, _Emission * col, saturate(vec.z * pow(s, _MergePow))) 
                    + lerp(0,_Color,i.uv.y);
            }
            ENDCG
        }
    }
}
