Shader "MyOwnShaders/MyCustomDiffuseLightingModel" {
	Properties {
		_EmissiveColor ("Emissive Color", Color) = (1,1,1,1)
		_AmbientColor ("Ambient Color", Color) = (1,1,1,1)
		_UserValue ("User Value", Range(0, 10)) = 2.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf MyCustomDiffuseLightingModel


		//Собствнно, модель освещения ламберта
		inline float4 LightingMyCustomDiffuseLightingModel(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			float difLight = max(0, dot(s.Normal, lightDir));
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * (difLight*atten*2);
			col.a = s.Alpha;
			return col;
		}


		float4 _EmissiveColor; //color that object emits
		float4 _AmbientColor; //color in shadow
		float _UserValue; //user coeff

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float4 c;
			c = pow((_EmissiveColor+_AmbientColor), _UserValue); //output is mix between two colors (with coeff)
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
