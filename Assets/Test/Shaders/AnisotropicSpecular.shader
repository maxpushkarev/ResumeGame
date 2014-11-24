Shader "MyOwnShaders/AnisotropicSpecular" {
	Properties {
	
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
		_SpecularAmount ("Specular Amount", Range(0, 1)) = 0.5
		_SpecularColor ("SpecularColor", Color) = (1,1,1,1)
		_SpecularPower ("Specular Power", Range(0, 1)) = 0.5
		
		_AnisoDir ("Anisotropic Direction", 2D) = "" {}
		_AnisoOffset ("Anisotropic Offset", Range(-1, 1)) = -0.2
		
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Anisotropic
		#pragma target 3.0

		sampler2D _MainTex;
		float4 _MainTint;
		
		float _SpecularAmount;
		float4 _SpecularColor;
		float _SpecularPower;
		
		sampler2D _AnisoDir;
		float _AnisoOffset;

		struct Input {
			float2 uv_MainTex;
			float2 uv_AnisoDir;
		};


		struct SurfaceAnisoOutput
		{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			fixed3 AnisoDirection;
			half Specular;
			fixed Gloss;
			fixed Alpha;
		};
		

		float4 LightingAnisotropic(SurfaceAnisoOutput s, float3 lightDir, float3 viewDir, float atten)
		{
			float3 halfVector = normalize(normalize(lightDir) + normalize(viewDir));
			
			float NdotL = saturate(dot(s.Normal, lightDir));
			float HdotA = dot(normalize(s.Normal + s.AnisoDirection), halfVector);
			float aniso = max(0, sin(radians((HdotA + _AnisoOffset) * 180.0f)));
			
			float spec = saturate(pow(aniso, s.Gloss * 128) * s.Specular);
			
			float4 c;
			
			c.rgb = (s.Albedo * _LightColor0.rgb * NdotL) + (_LightColor0.rgb * _SpecularColor.rgb * spec) * (atten * 2);
			c.a = s.Alpha;
			
			return c;
		}



		void surf (Input IN, inout SurfaceAnisoOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			float3 anisoNormal = UnpackNormal(tex2D (_AnisoDir, IN.uv_AnisoDir) );
			
			o.AnisoDirection = anisoNormal;
			
			o.Gloss = _SpecularPower;
			o.Specular = _SpecularAmount;
			
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
