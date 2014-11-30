﻿Shader "Building/Wall" {
	Properties {
		_NormalMap ("Normal Map", 2D) = "bump" {}
		_MainTint ("Diffuse Color", Color) = (1,1,1,1)
		_NormalIntensity ("Normal Intensity", Range(0, 10)) = 1
		
		_WallTex ("Wall Texture", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf HalfLambert

		sampler2D _NormalMap;
		float4 _MainTint;
		float _NormalIntensity;
		
		sampler2D _WallTex;

		struct Input {
			float2 uv_WallTex;
		};

		half4 LightingHalfLambert(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			float difLight = dot(s.Normal, lightDir);
			float halfDifLight = difLight * 0.5 + 0.5;
			
			float4 col;
			
			col.rgb = s.Albedo * _LightColor0.rgb * (halfDifLight*atten * 2);
			col.a = s.Alpha;
			
			return col;
		}


		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D(_WallTex, IN.uv_WallTex) * _MainTint;
		
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			
			float3  unpackedNormal = UnpackNormal(tex2D(_NormalMap, IN.uv_WallTex));
			unpackedNormal = float3(unpackedNormal.x * _NormalIntensity, unpackedNormal.y * _NormalIntensity, unpackedNormal.z);
			
			
			
			o.Normal = unpackedNormal.rgb;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
