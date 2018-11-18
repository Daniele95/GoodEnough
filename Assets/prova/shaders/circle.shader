Shader "Unlit/quad" 
{ 
	Properties 
	{
		// write after this line
		time("time",Range(0,2))=1
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
			#include "ingredients/circleFrost.cginc"
			#include "ingredients/circleRing.cginc"

			#pragma fragment frag
			#pragma vertex vert
			
			fixed time;

			fixed4 frag (v2f i) : SV_Target
			{
				float3 result = frost(i.uv,time);
				//result += ring(i.uv,time);
				return float4(result,1.);
			}
			ENDCG
		}
	}
}
