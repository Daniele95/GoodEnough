Shader "Unlit/swipe" 
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
			#include "ingredients/slant.cginc"

			#pragma fragment frag
			#pragma vertex vert				

			fixed2 getUvs (fixed2 uv) {
			// Shape
				fixed x = slantedX( uv );
				fixed y = uv.y;
				shape = x >= 0.0 && x <= 1.0 && y >= 0.0 && y <= 1.0;

				getFuzzedAlpha(fixed2(x,y));

				// Horizontal frost
				x = _HorizontalFrost ? uv.y : x;
				y = _HorizontalFrost ? uv.x : y;
				return fixed2(x,y);
			}

			fixed4 frag (v2f i) : SV_Target
			{	
				// calls getUvs and gives me a 'uv' var suited to the object:
				setSpaceTime(i.uv);
				
				// Layers
				fixed3 baseLayer = _BaseColor;
				fixed3 resonanceLayer = resonance(i.uv,time,_ScaleY) * _ResonanceColor * _ShowResonance;

				// Correct frost tail with cue height
				if ( !_SlantSimple ) TailCap *= _ScaleY; 

				fixed3 frostLayer = quadFrost(myUv, time, _ScaleY) * _FrostColor * _ShowFrost;

				// Everything
				fixed4 layers = fixed4( resonanceLayer + layer3( frostLayer, baseLayer ), fuzzedAlpha );
				return layers * shape;

			}
			ENDCG
		}
	}
}
