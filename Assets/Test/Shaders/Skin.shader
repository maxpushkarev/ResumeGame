Shader "MyOwnShaders/Skin" {
	Properties {
	
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)	
		_BumpMap ("Bump Map", 2D) = "bump" {}
		_CurveScale ("Curvature Scale", Range(0.001, 0.09)) = 0.01
		//_CurveAmount ("Curvature Amount", Range(0, 1)) = 0.5
		_BumpBias ("Normal Map Blur", Range(0, 5)) = 2.0
		_BRDFTex ("BRDF Texture", 2D) = "white" {}
		_FresnelVal ("Fresnel Value", Range(0.01, 0.3)) = 0.05
		_RimPower ("Rim Falloff", Range(0, 5)) = 2
		_RimColor ("Rim Color", Color) = (1,1,1,1)
		_SpecIntencity ("Specular Intensity", Range(0, 1)) = 0.4
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_SpecWidth ("Specular Width", Range(0, 1)) = 0.2
		
		
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Skin
		#pragma target 3.0
		#pragma only_renderers d3d9

		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _BRDFTex;
		float4 _MainTint;
		float4 _RimColor;
		float _CurveScale;
		float _BumpBiass;
		//float _CurveAmount;
		float _FresnelVal;
		float _RimPower;
		float _SpecIntensity;
		float _SpecWidth;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		struct SurfaceOutputSkin
		{
			float3 Albedo;
			float3 Normal;
			float3 Emission;
			float3 Specular;
			float Gloss;
			float Alpha;
			float Curvature;
			float3 BlurredNormal;
		};

		float4 LightingSkin(SurfaceOutputSkin s, float3 lightDir, float3 viewDir, float atten)
		{
			viewDir = normalize(viewDir);
			lightDir = normalize(lightDir);
			s.Normal = normalize(s.Normal);
			
			float NdotL = dot(s.BlurredNormal, lightDir);
			float3 halfVec = normalize(viewDir + lightDir);
			
			float3 brdf = tex2D(_BRDFTex, float2((NdotL * 0.5 + 0.5) * atten, s.Curvature)).rgb;
			
			float fresnel = saturate(pow(1 - dot(viewDir, halfVec), 5.0));
			fresnel += _FresnelVal * (1 - fresnel);
			
			float rim = saturate(pow(1 - dot(viewDir, s.BlurredNormal), _RimPower)) * fresnel;
			
			float specBase = max(0, dot(s.Normal, halfVec));
			float spec = pow(specBase, s.Specular * 128.0) * s.Gloss;
			
			float4 c;
			
			c.rgb = (s.Albedo * brdf * _LightColor0.rgb * atten) + (spec  + (rim *_RimColor));
			c.a = 1.0;
			
			return c;
		}

		void surf (Input IN, inout SurfaceOutputSkin o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			float3 normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
			float3 normalBlur = UnpackNormal(tex2Dbias(_BumpMap, float4(IN.uv_MainTex, 0.0, _BumpBiass)));
			
			float curvature = length( fwidth(WorldNormalVector(IN, normalBlur)) ) / length( fwidth(IN.worldPos) ) * _CurveScale;
			
			o.Normal = normal;
			o.BlurredNormal = normalBlur;
			o.Albedo = c.rgb * _MainTint;
			o.Curvature = curvature;
			o.Specular = _SpecWidth;
			o.Gloss = _SpecIntensity;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
