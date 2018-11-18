Shader "Unlit/quad" 
{ 
	Properties 
	{
	
	}
	SubShader
	{
		Blend SrcAlpha OneMinusSrcAlpha
		Tags { "Queue"="Transparent" }

		Pass
		{
			CGPROGRAM
			
			#include "UnityCG.cginc"
			#include "ingredients/vertexShader.cginc"
			#include "ingredients/resonance.cginc"
			#include "ingredients/quadFrost.cginc"


			#pragma fragment frag
			#pragma vertex vert
			
			float time;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 waveCenter = float2(0,0);
				//float3 result = resonance(i.uv,_Time.y,6);
				float3 result = quadFrost(i.uv, _Time.y, 3);
				return float4(result,1.);
			}
			ENDCG
		}
	}
}
