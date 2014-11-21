Shader "MyOwnShaders/NewShader" {
	Properties {
		_NormalMap ("Normal Map", 2D) = "bump" {}
		_MainTint ("Diffuse Color", Color) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _NormalMap;
		float4 _MainTint;

		struct Input {
			float2 uv_NormalMap;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float3  unpackedNormal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
			o.Albedo = _MainTint.rgb;
			o.Normal = unpackedNormal.rgb;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
