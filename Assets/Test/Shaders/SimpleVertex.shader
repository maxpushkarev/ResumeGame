Shader "MyOwnShaders/SimpleVertex" {
	Properties {
		_MainTint ("Diffuse tint", Color) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		float4 _MainTint;

		struct Input {
			float4 vertColor;
		};

		void vert(inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);
			o.vertColor = v.color;
		} 

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = IN.vertColor.rgb * _MainTint.rgb;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
