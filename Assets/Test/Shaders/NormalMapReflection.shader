Shader "MyOwnShaders/NormalMapReflection" {
	Properties {
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Cubemap ("Cubemap", CUBE) = "" {}
		_ReflAmount ("Reflection amount", Range(0.01, 1)) = 0.5
		_NormalMap ("Normal map", 2D) = "" {}
		
		
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
		sampler2D _NormalMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalMap;
			float3 worldRefl;
			INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			
			float3 normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap)).rgb;
			
			o.Normal = normal;
			o.Emission = texCUBE(_Cubemap, WorldReflectionVector(IN, o.Normal)).rgb *_ReflAmount;
			o.Albedo = c.rgb * _MainTint;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
