Shader "MyOwnShadersUnlitLighting" {
	Properties {
	
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainTint ("Diffuse tint", Color) = (1,1,1,1)
		
		_NormalMap ("Normal map", 2D) = "" {}
		
		}
		
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Unlit vertex:vert

		sampler2D _MainTex;
		sampler2D _NormalMap;
		float4 _MainTint;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalMap;
			float3 tan1;
			float3 tan2;
		};

		float4 LightingUnlit (SurfaceOutput s, float3 lightDir, float atten)
		{
			float4 c = float4(1,1,1,1);
			
			c.rgb = c * s.Albedo;
			c.a = s.Alpha;
			
			return c;
		
		}
		
		void vert(inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input,o);
			
			TANGENT_SPACE_ROTATION;
			o.tan1 = mul(rotation, UNITY_MATRIX_IT_MV[0].xyz);
			o.tan1 = mul(rotation, UNITY_MATRIX_IT_MV[1].xyz);
		
		}

		void surf (Input IN, inout SurfaceOutput o) {
			
			float normal = UnpackNormal(tex2D (_NormalMap, IN.uv_NormalMap));
			
			o.Normal = normal;
			
			float2 litSphereUV;
			
			litSphereUV.x = dot(IN.tan1, o.Normal);
			litSphereUV.y = dot(IN.tan2, o.Normal);
		
			half4 c = tex2D (_MainTex, litSphereUV * 0.5 + 0.5) * _MainTint;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
