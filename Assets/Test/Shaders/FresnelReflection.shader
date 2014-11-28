Shader "Custom/FresnelReflection" {
	Properties {
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Cubemap ("Cubemap", CUBE) = "" {}
		_ReflAmount ("Reflection amount", Range(0.01, 1)) = 0.5
		
		_FresnelFalloff ("Fresnel Falloff", Range(0.1, 3)) = 2
		
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_SpecPower ("Specular Power", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BlinnPhong
		#pragma target 3.0

		sampler2D _MainTex;
		float4 _MainTint;
		
		samplerCUBE _Cubemap;
		float _ReflAmount;
		
		float _FresnelFalloff;
		float _SpecPower;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
			float3 viewDir;
		};

		void surf (Input IN, inout SurfaceOutput o) {
		
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			
			float rim = 1.0 - saturate(dot(o.Normal, normalize(IN.viewDir)));
			rim = pow(rim, _FresnelFalloff);
			
			o.Emission = texCUBE(_Cubemap, IN.worldRefl).rgb *_ReflAmount * rim;
			o.Albedo = c.rgb * _MainTint;
			
			o.Gloss = 1.0;
			o.Specular = _SpecPower;
			
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
