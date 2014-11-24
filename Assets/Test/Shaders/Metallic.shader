Shader "MyOwnShaders/Metallic" {
	Properties {
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
		_Roughness ("Roughness", Range(0, 1)) = 0.5
		_RoughnessTex ("Roughness Texture", 2D) = "white" {}
		
		_SpecularColor ("SpecularColor", Color) = (1,1,1,1)
		_SpecularPower ("Specular Power", Range(0, 30)) = 2
		
		_Fresnel ("Fresnel value", Range(0, 1.0)) = 0.05
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf CookTorrance
		#pragma target 3.0

		sampler2D _MainTex;
		float4  _MainTint;
		
		float4 _SpecularColor;
		float _SpecularPower;
		
		sampler2D _RoughnessTex;
		float _Roughness;
		
		float _Fresnel; 


		float4 LightingCookTorrance(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
		{
			float3 halfVector = normalize(lightDir+viewDir);
			
			float NdotL = saturate(normalize(dot(s.Normal, normalize(lightDir))));
			float NdotH_raw = normalize(dot(s.Normal, halfVector));
			float NdotH = saturate(normalize(dot(s.Normal, halfVector)));
			float NdotV = saturate(normalize(dot(s.Normal, normalize(viewDir))));
			float VdotH = saturate(normalize(dot(halfVector, normalize(viewDir))));
			
			//Micro facets distribution
			float geoEnum = 2.0 * NdotH;
			float3 G1 = (geoEnum * NdotV) / NdotH;
			float3 G2 = (geoEnum * NdotL) / NdotH;
			float G = min(1.0f, min(G1, G2));
			
			float roughness = tex2D(_RoughnessTex, float2(NdotH_raw*0.5 + 0.5, _Roughness)).r;
			
			float fresnel = pow(1.0 - VdotH, 5.0);
			fresnel *= (1.0 - _Fresnel);
			fresnel += _Fresnel;
			
			float spec = float3(fresnel * G * roughness * roughness) * _SpecularPower;
			float3 modifiedSpecular = _SpecularColor.rgb * spec;
			
			float4 c;
			
			c.rgb = (s.Albedo * _LightColor0.rgb * NdotL) + (_SpecularColor.rgb * modifiedSpecular) * (atten * 2f);
			c.a = s.Alpha;
			
			return c;
		}



		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
