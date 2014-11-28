Shader "MyOwnShaders/DiffuseConvolution" {
	Properties {
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_BumpMap ("Bump Map", 2D) = "bump" {}
		_AOMap ("Ambient Occlusion Map", 2D) = "white" {}
		_CubeMap ("Diffuse Convolution Cubemap", Cube) = "" {}
		_SpecIntencity ("Specular Intensity", Range(0, 1)) = 0.4
		_SpecWidth ("Specular Width", Range(0, 1)) = 0.2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf DiffuseConvolution
		#pragma target 3.0
		
		float4 _MainTint;
		sampler2D _BumpMap;
		sampler2D _AOMap;
		samplerCUBE _CubeMap;
		float _SpecIntencity;
		float _SpecWidth;
		

		struct Input {
			float2 uv_AOMap;
			float3 worldNormal;
			INTERNAL_DATA
		};

		float4 LightingDiffuseConvolution(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
		{
			lightDir = normalize(lightDir);
			viewDir = normalize(viewDir);
			
			s.Normal = normalize(s.Normal);
			
			float NdotL = dot(s.Normal, lightDir);
			float3 halfVec = normalize(lightDir + viewDir);
			
			float spec = pow(dot(s.Normal, halfVec), s.Specular * 128.0) * s.Gloss;
			
			float4 c;
			
			c.rgb = (s.Albedo * atten) + spec;
			c.a = 1.0f;
			
			return c;
			
		}


		void surf (Input IN, inout SurfaceOutput o) {
		
			half4 c = tex2D(_AOMap, IN.uv_AOMap);
			
			float3 normal = UnpackNormal(tex2D(_BumpMap, IN.uv_AOMap)).rgb;
			o.Normal = normal;
			
			float3 diffuseVal = texCUBE(_CubeMap, WorldNormalVector(IN, o.Normal)).rgb;
			
			o.Albedo = c.rgb * diffuseVal * _MainTint;
			o.Specular = _SpecWidth;
			o.Gloss = _SpecIntencity * c.rgb;
			
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
