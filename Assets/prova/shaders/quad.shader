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
			#include "ingredients/utilities.cginc"
			
			#include "ingredients/cueProperties.cginc"
			#include "ingredients/fuzz.cginc"
			#include "ingredients/colorMixing.cginc"

			#include "ingredients/resonance.cginc"
			#include "ingredients/quadFrost.cginc"


			#pragma fragment frag
			#pragma vertex vert
			
			fixed2 getUvs(fixed2 uv) {
				uv.x = abs(uv.x-.5)+.5;
				getFuzzedAlpha(uv);
				return uv;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				// calls getUvs and gives me a 'uv' var suited to the object:
				setSpaceTime(i.uv); 

				// Layers
				fixed3 baseLayer = _BaseColor;
				fixed3 resonanceLayer = resonance(i.uv,time,_ScaleY) * _ResonanceColor * _ShowResonance;		
				fixed3 frostLayer = quadFrost(myUv,time, _ScaleY) * _FrostColor * _ShowFrost;
				
				// Everything
				return fixed4( resonanceLayer + layer3( frostLayer, baseLayer ), fuzzedAlpha );				
			}
			ENDCG
		}
	}
}
