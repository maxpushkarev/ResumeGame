Shader "MyOwnShaders/ScrollTexture" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_ScrollXSpeed ("Scroll Speed X", Range(0,10)) = 2
		_ScrollYSpeed ("Scroll Speed Y", Range(0,10)) = 2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		fixed4 _MainTint;
		fixed _ScrollXSpeed;
		fixed _ScrollYSpeed;
		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			
			fixed2 uvCoords = IN.uv_MainTex;
			
			fixed scrollX = _ScrollXSpeed * _Time.x;
			fixed scrollY = _ScrollYSpeed * _Time.y;
			
			uvCoords += fixed2(scrollX, scrollY);
			
			half4 c = tex2D (_MainTex, uvCoords);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
