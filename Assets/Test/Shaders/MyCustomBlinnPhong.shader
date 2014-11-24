Shader "MyOwnShaders/MyCustomBlinnPhong" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpecularColor ("Specular Color", color) = (1,1,1,1)
		_SpecularPower ("Specular Power", Range(0, 30)) = 1
		_Gloss ("Gloss", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf MyCustomBlinnPhong

		sampler2D _MainTex;
		float4 _SpecularColor;
		float _SpecularPower;
		float _Gloss;


		float4 LightingMyCustomBlinnPhong(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
		{
			float diffuseComponent = dot(s.Normal, lightDir);
			
			float3 h = normalize((lightDir+viewDir));
			float spec = pow(max(0, dot(s.Normal, h)), _SpecularPower);
			
			float3 modifiedSpecular = _SpecularColor.rgb * spec;
			
			float4 c;
			
			c.rgb = (s.Albedo * _LightColor0.rgb * diffuseComponent) + (_LightColor0.rgb * modifiedSpecular * atten *2);
			c.a = 1.0;
			
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
