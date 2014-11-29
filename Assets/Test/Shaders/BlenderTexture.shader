Shader "MyOwnShaders/BlenderTexture" {
	Properties {
		
		_ColorA ("ColorA", color) = (1,1,1,1)
		_ColorB ("ColorB", color) = (0.5,0.5,0.5,1)
	
		_RTexture ("RTexture", 2D) =  "" {}
		_GTexture ("GTexture", 2D) =  "" {}
		_BTexture ("BTexture", 2D) =  "" {}
		_ATexture ("ATexture", 2D) =  "" {}
		_BlendTexture ("BlendTexture", 2D) =  "" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf HalfLambert

		sampler2D _RTexture;
		sampler2D _GTexture;
		sampler2D _BTexture;
		sampler2D _ATexture;
		sampler2D _BlendTexture;

		float4 _ColorA;
		float4 _ColorB;

		struct Input {
			float2 uv_RTexture;
			float2 uv_GTexture;
			float2 uv_BTexture;
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
		
			float4 blendData = tex2D(_BlendTexture, IN.uv_BlendTexture);
			float4 rData = tex2D(_RTexture, IN.uv_RTexture);
			float4 gData = tex2D(_GTexture, IN.uv_GTexture);
			float4 bData = tex2D(_BTexture, IN.uv_BTexture);
			float4 aData = tex2D(_ATexture, IN.uv_ATexture);
		
			float4 mixedColor;
			mixedColor = lerp(rData, gData, blendData.g);
			mixedColor = lerp(mixedColor, bData, blendData.b);
			mixedColor = lerp(mixedColor, aData, blendData.a);
			mixedColor.a = 1.0;
		
			//float4 terrainLayers = lerp(_ColorA, _ColorB, mixedColor.r);
			//mixedColor *= terrainLayers;
			//mixedColor = saturate(mixedColor);

			o.Albedo = mixedColor;
			o.Alpha = mixedColor.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
