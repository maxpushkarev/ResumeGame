﻿Shader "MyOwnShaders/MaskingReflection" {
	Properties {
	
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Cubemap ("Cubemap", CUBE) = "" {}
		_ReflAmount ("Reflection amount", Range(0.01, 1)) = 0.5
		_ReflMask ("Reflection Mask", 2D) = "" {}
	}
	
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		float4 _MainTint;
		
		samplerCUBE _Cubemap;
		float _ReflAmount;
		sampler2D _ReflMask;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
		};

		void surf (Input IN, inout SurfaceOutput o) {
		
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			half4 reflLevel = tex2D (_ReflMask, IN.uv_MainTex);
			
			o.Emission = texCUBE(_Cubemap, IN.worldRefl).rgb * reflLevel.r * _ReflAmount;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
