Shader "MyOwnShaders/SpecularTexture" {
	Properties {
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
		_SpecularColor ("SpecularColor", Color) = (1,1,1,1)
		_SpecularMask ("SpecularMask", 2D) = "white" {}
		_SpecularPower ("Specular Power", Range(0.1, 120)) = 3
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf MyPhong

		sampler2D _MainTex;
		sampler2D _SpecularMask;
		
		float4 _MainTint;
		float4 _SpecularColor;
		float _SpecularPower;

		struct Input {
			float2 uv_MainTex;
			float2 uv_SpecularMask;
		};

		struct SpecularTextureSurfaceOutput
		{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			fixed3 SpecularColor;
			
			half Specular;
			fixed Gloss;
			fixed Alpha;
		
		};
		
		
		float4 LightingMyPhong(SpecularTextureSurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
		{
			float diffuseComponent = dot(s.Normal, lightDir);
			float3 reflectionVector = normalize(2.0 * s.Normal * diffuseComponent - lightDir);
			float spec = pow(max(0, dot(reflectionVector, viewDir)), _SpecularPower) * s.Specular;
			
			float3 modifiedSpecular = _SpecularColor.rgb * spec * s.SpecularColor;
			
			float4 c;
			
			c.rgb = (s.Albedo * _LightColor0.rgb * diffuseComponent) + (_LightColor0.rgb * modifiedSpecular);
			c.a = 1.0;
			
			return c;
		}
		

		void surf (Input IN, inout SpecularTextureSurfaceOutput o) 
		{
		
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			half4 specularData = tex2D (_SpecularMask, IN.uv_SpecularMask) * _SpecularColor;
			
			o.SpecularColor = specularData.rgb;
			o.Specular = specularData.r;
			
			o.Albedo = c.rgb * _MainTint;
			o.Alpha = c.a;
		}
		
		ENDCG
	} 
	FallBack "Diffuse"
}
