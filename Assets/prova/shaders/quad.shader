Shader "Unlit/quad" 
{ 
	Properties 
	{
		// write after this line
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
			
			#include "ingredients/cueProperties.cginc"
			#include "ingredients/fuzz.cginc"
			#include "ingredients/colorMixing.cginc"

			#include "ingredients/resonance.cginc"
			#include "ingredients/quadFrost.cginc"


			#pragma fragment frag
			#pragma vertex vert
			

			fixed4 frag (v2f i) : SV_Target
			{
				if(time==0) time=_Time.y;
				// Fuzz
				fixed fuzzedAlpha = getFuzzedAlpha( ( i.uv.x - 0.5 ) * _FuzzLengthMultiplier, _Alpha );

				// Layers
				fixed3 baseLayer = _BaseColor;
				fixed3 resonanceLayer = resonance(i.uv,time,_ScaleY) * _ResonanceColor * _ShowResonance;		
				fixed3 frostLayer = quadFrost(i.uv,time, _ScaleY) * _FrostColor * _ShowFrost;
				
				// Everything
				return fixed4( resonanceLayer + layer3( frostLayer, baseLayer ), fuzzedAlpha );

			}
			ENDCG
		}
	}
}
