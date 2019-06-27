Shader "additive" {
    Properties {
        _MainTex ("Texture", 2D) = "black" {}
    }
    SubShader {
        Tags { "Queue" = "Transparent" }
        Pass {
            Blend SrcAlpha One
            SetTexture [_MainTex] { combine texture }
        }
    }
}