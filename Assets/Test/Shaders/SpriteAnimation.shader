Shader "MyOwnShaders/SpriteAnimation" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_CellAmount ("Cell Amount", float) = 0.0
		_Speed ("Speed", Range(0.01, 32)) = 12
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		float _Speed;
		float _CellAmount;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			
			fixed2 uvCoords = IN.uv_MainTex;
			fixed cellUVPercentage = 1/_CellAmount;
			
			float frame = fmod(_Time.y * _Speed, _CellAmount);
			frame = floor(frame);
			
			fixed xValue = (uvCoords.x + frame)* cellUVPercentage;
			uvCoords = fixed2(xValue, uvCoords.y);
			
			half4 c = tex2D (_MainTex, uvCoords);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
