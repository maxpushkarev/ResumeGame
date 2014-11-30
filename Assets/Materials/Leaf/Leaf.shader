Shader "Custom/Leaf" {
	Properties {
		_LeafColor ("Leaf Color", Color) = (1,1,1,1)
		_NormalMap ("Leaf Normal", 2D) = "bump" {}
		_NormalIntensity ("Normal Intensity", Range(0, 10)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf HalfLambert

		float4 _LeafColor;
		sampler2D _NormalMap;
		float _NormalIntensity;

		struct Input {
			float2 uv_NormalMap;
		};

		half4 LightingHalfLambert(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			float difLight = dot(s.Normal, lightDir);
			float halfDifLight = difLight;
			
			float4 col;
			
			col.rgb = s.Albedo * _LightColor0.rgb * (halfDifLight*atten * 2);
			col.a = s.Alpha;
			
			return col;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			
			float3  unpackedNormal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
			unpackedNormal = float3(
				unpackedNormal.x * _NormalIntensity, 
				unpackedNormal.y * _NormalIntensity, 
				unpackedNormal.z
			);
			
			o.Albedo = _LeafColor.rgb;
			o.Alpha = _LeafColor.a;
			o.Normal = unpackedNormal.rgb;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
