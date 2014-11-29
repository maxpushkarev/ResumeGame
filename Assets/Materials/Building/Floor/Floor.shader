Shader "Building/Floor" {
	Properties {
	
		_NormalMap ("Normal Map", 2D) = "bump" {}
		_NormalLevel ("Normal Level", Range(0, 10)) = 1
		
		_FloorTex ("Floor Texture", 2D) = "white" {}
		_DustTex ("Dust", 2D) =  "" {}
		_MoldTex ("Mold", 2D) =  "" {}
		_BlendTexture ("BlendTexture", 2D) =  "" {}
		
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf HalfLambert

		float _NormalLevel;
		sampler2D _NormalMap;
		
		sampler2D _FloorTex;
		sampler2D _DustTex;
		sampler2D _MoldTex;
		sampler2D _BlendTexture;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalMap;
			float2 uv_FloorTex;
			float2 uv_DustTex;
			float2 uv_MoldTex;
			float2 uv_ATexture;
			float2 uv_BlendTexture;
		};
		
		half4 LightingHalfLambert(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			float difLight = dot(s.Normal, lightDir);
			float halfDifLight = difLight * 0.5 + 0.5;
			
			float4 col;
			
			col.rgb = s.Albedo * _LightColor0.rgb * (halfDifLight*atten * 2);
			col.a = s.Alpha;
			
			return col;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			
			float4 floor = tex2D(_FloorTex, IN.uv_FloorTex);
			
			float3 unpackedNormal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
			unpackedNormal = float3(unpackedNormal.x * _NormalLevel, unpackedNormal.y * _NormalLevel, unpackedNormal.z);
			o.Normal = unpackedNormal.rgb;
			
			float4 blendData = tex2D(_BlendTexture, IN.uv_BlendTexture);
			float4 dust = tex2D(_DustTex, IN.uv_DustTex);
			float4 mold = tex2D(_MoldTex, IN.uv_MoldTex);
		
			float4 mixedColor;
			mixedColor = lerp(floor, dust, blendData.g);
			mixedColor = lerp(mixedColor, mold, blendData.b);
			mixedColor.a = 1.0;

			o.Albedo = mixedColor;
			o.Alpha = mixedColor.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
