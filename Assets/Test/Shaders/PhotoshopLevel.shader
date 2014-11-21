Shader "MyOwnShaders/PhotoshopLevel" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
		_inBlack ("Input Black", Range(0, 255)) = 0
		_inGamma ("Input Gamma", Range(0, 2)) = 1.61
		_inWhite ("Input White", Range(0, 255)) = 255
		
		_outBlack ("Output Black", Range(0, 255)) = 0
		_outWhite ("Output White", Range(0, 255)) = 255
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		
		float _inBlack;
		float _inGamma;
		float _inWhite;
		
		float _outBlack;
		float _outWhite;
		

		struct Input {
			float2 uv_MainTex;
		};

		float GetPixelLevel(float input){
		
			float output = input * 255;
			
			output = max(0, (output - _inBlack));
			output = saturate(pow( output / (_inWhite - _inBlack), _inGamma ));  
			output = (output * (_outWhite - _outBlack) + _outBlack) / 255;
			
			return output;
		
		}

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);

			o.Albedo = float3(GetPixelLevel(c.r), GetPixelLevel(c.g), GetPixelLevel(c.b));
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
