Shader "MyOwnShaders/BlinnPhong" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_SpecPower ("Specular Power", Range(0, 1)) = 0.5
		_Gloss ("Gloss", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BlinnPhong

		sampler2D _MainTex;
		float _SpecPower;
		float _Gloss;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			
			o.Specular = _SpecPower;
			o.Gloss = _Gloss;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
