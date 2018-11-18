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
			#include "ingredients/quadFrost.cginc"


			#pragma fragment frag
			#pragma vertex vert
			
			fixed time;

			fixed4 frag (v2f i) : SV_Target
			{
				float3 result = quadFrost(i.uv, _Time.y, 6);
				result += resonance(i.uv,_Time.y,6);
				return float4(result,1.);
			}
			ENDCG
		}
	}
}
