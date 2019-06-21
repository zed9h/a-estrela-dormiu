Shader "handwritten"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _VecTex ("Vector", 2D) = "white" {}
        _UScale ("UScale", Float) = 1
        _Offset ("Offset", Float) = 0.5
        _Scale ("Scale", Float) = 40
        _Thresh ("Threshold", Float) = 0.67
        _MinThresh ("MinThreshold", Float) = 0.3
        _Pow ("Power", Float) = 1
        _PScale ("PScale", Float) = 1
        _Mult ("Mult", Float) = 1
        _Circle ("Circle", Float) = 10
        _Emission ("Emission", Float) = 1
        _StarPow ("Star Power", Float) = 3
        _MergePow ("Merge Power", Float) = 2
        _Fade ("Fade", Range(0,1)) = 0.5
		_Color("Color", Color) = (0,0,0,1)
		_Focus("Focus", Float) = 7
		_HFocus("HFocus", Float) = 2
        _Col("Column", Float) = 0.5
        _Cel("Cel", Float) = 1
		_Row("Row", Range(0,1)) = 0.5
		_Rot("Rotation", Range(0,360)) = 0
		_Elevation("Elevation", Range(-1,1)) = 0.2


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
                float3 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 uv : TEXCOORD0;
            };

            half4 _MainTex_ST;
            sampler2D _MainTex;
            sampler2D _VecTex;
            half _Offset;
            half _UScale;
            half _Scale;
            half _Thresh;
            half _MinThresh;
            half _Pow;
            half _PScale;
            half _Mult;
            half _Circle;
            half _Emission;
			half _Fade;
			half _Focus;
			half _HFocus;
			half _Row;
			half4 _Color;
            half _StarPow;
			half _MergePow;
			half _Rot;
			half _Col;
			half _Elevation;
            half _Cel;

            half n21 (half2 p) {
                return frac(dot(sin(
                    p * half2(131, 159)),123.3213213));
            }
            
            half n21s (half2 p) {
                half2 i = floor(p);
                half2 f = frac(p);
                half n00 = n21(i);
                half n01 = n21(i + half2(0,1));
                half n10 = n21(i + half2(1,0));
                half n11 = n21(i + half2(1,1));
                return lerp(lerp(n00,n01,f.y), lerp(n10,n11,f.y), f.x);
            }

			float4x4 Rotation() {
				float a = _Rot * 0.0174532925;
				float s = sin(a);
				float c = cos(a);
				return float4x4(
					 c, 0, s, 0,
					 0, 1, 0, 0,
					-s, 0, c, 0,
					 0, 0, 0, 1
				);
			}


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(mul(Rotation(), v.vertex));
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float2 uv = i.uv * _UScale;
				uv.x = uv.x + 0.5;
				uv.y = uv.y + _Row - _Elevation;
                fixed4 vec = tex2D(_VecTex, uv);
                fixed4 off = (vec - _Offset) * _Scale;
                off.xy *= _ScreenParams.zw;
                fixed4 col = tex2D(_MainTex, uv);
                fixed star = 0;
				float s = vec.z * _Fade 
					* (1 - saturate(pow((uv.y - _Row)*_Focus, 2)))
					* (1 - saturate(pow((uv.x - _Col)*_HFocus, 2)))
					* step(0, i.uv.z);
                float2 p = i.uv * _PScale //+ vec.z * _SinTime.y * 4 * s +
                    - off.xy * s // * (_SinTime.y * 0.5 + 0.5)
                    + float2(_CosTime.y,_SinTime.y) * _Circle * s;
                star += n21s(p) * 0.4; p *= 2.029;
                star += n21s(p) * 0.3; p *= 3.023;
                star += n21s(p) * 0.2; p *= 5.017;
                //star += n21s(p) * 0.1; p *= 7.013;
                half t = lerp(_Thresh, _MinThresh, pow(s, _StarPow));
                star = pow(saturate(star - t) / (1-t), _Pow) * _Mult;
                return lerp(star, _Emission * col, saturate(vec.z * pow(s, _MergePow))) 
                    + lerp(0,_Color,i.uv.y);
            }
            ENDCG
        }
    }
}
