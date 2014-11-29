Shader "MyOwnShaders/Cloth" {
	Properties {
		_MainTint ("Diffuse tint", Color) = (1,1,1,1)
		_BumpMap ("Normal map", 2D) = "bump" {}
		_DetailBump ("Detail Normal Map", 2D) = "bump" {}
		_DetailTex ("Fabric weave", 2D) = "white" {}
		_FresnelColor ("Fresnel color", Color) = (1,1,1,1)
		_FresnelPower ("Fresnel power", Range(0, 12)) = 3
		_RimPower ("Rim Falloff", Range(0, 12)) = 3
		_SpecIntensity ("Specular Intensity", Range(0, 1)) = 0.2
		_SpecWidth ("Specular Width", Range(0, 1)) = 0.2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Velvet
		#pragma target 3.0
		
		sampler2D _BumpMap;
		sampler2D _DetailBump;
		sampler2D _DetailTex;
		float4 _MainTint;
		float4 _FresnelColor;
		float _FresnelPower;
		float _RimPower;
		float _SpecIntensity;
		float _SpecWidth;

		struct Input {
			float2 uv_BumpMap;
			float2 uv_DetailBump;
			float2 uv_DetailTex;
		};


		float4 LightingVelvet(SurfaceOutput s, float3 lightDir, half3 viewDir, fixed atten)
		{
			viewDir = normalize(viewDir);
			lightDir = normalize(lightDir);
			
			float3 halfVec = normalize(lightDir + viewDir);
			float NdotL = max(0, dot(s.Normal, lightDir));
			
			float NdotH = max(0, dot(s.Normal, halfVec));
			float spec = pow(NdotH, s.Specular * 128.0) * s.Gloss;
			
			float HdotV = pow(1 - max(0, dot(halfVec, viewDir)), _FresnelPower);
			float NdotE = pow(1 - max(0, dot(s.Normal, viewDir)), _RimPower);
			float finalSpecMask = NdotE * HdotV;
			
			float4 c;
			
			c.rgb = (s.Albedo * NdotL * _LightColor0.rgb) + (spec * finalSpecMask * _FresnelColor) * (atten * 2);
			c.a = 1.0;
			
			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_DetailTex, IN.uv_DetailTex);
			
			float3 normal = UnpackNormal(tex2D (_BumpMap, IN.uv_BumpMap)).rgb;
			float3 detailNormal = UnpackNormal(tex2D (_DetailBump, IN.uv_DetailBump)).rgb;
			
			float3 finalNormal = float3(
				normal.x + detailNormal.x,
				normal.y + detailNormal.y,
				normal.z + detailNormal.z
			);
			
			o.Normal = normalize(finalNormal);
			o.Specular = _SpecWidth;
			o.Gloss = _SpecIntensity;
			
			o.Albedo = c.rgb * _MainTint;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
