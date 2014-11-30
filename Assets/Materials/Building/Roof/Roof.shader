Shader "Building/Roof" {
	Properties {
		_NormalMap ("Normal Map", 2D) = "bump" {}
		_MainTint ("Diffuse Color", Color) = (1,1,1,1)
		_NormalIntensity ("Normal Intensity", Range(0, 10)) = 1
		
		_CeilingTex ("Ceiling Texture", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _NormalMap;
		float4 _MainTint;
		float _NormalIntensity;
		
		sampler2D _CeilingTex;

		struct Input {
			float2 uv_CeilingTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D(_CeilingTex, IN.uv_CeilingTex) * _MainTint;
		
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			
			float3  unpackedNormal = UnpackNormal(tex2D(_NormalMap, IN.uv_CeilingTex));
			unpackedNormal = float3(unpackedNormal.x * _NormalIntensity, unpackedNormal.y * _NormalIntensity, unpackedNormal.z);
			
			
			
			o.Normal = unpackedNormal.rgb;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}