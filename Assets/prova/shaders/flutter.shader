Shader "Unlit/flutter" 
{ 
	Properties 
	{
		// write after this line
		_SlantAmount ( "_SlantAmount" , Range( 0 , 1 ) ) = 0.72
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
			
			fixed _SlantAmount;


			fixed2 getUvs(fixed2 uv) {
				// Slant shape
				fixed x = uv.x;
				fixed y = uv.y;
				fixed slant = ( 1.0 - _SlantAmount ) / 2.0;

				shape = step( slant * y, x );  // Left side
				shape *= step( x, 1.0 - slant * y );  // Right side

				x = 0.5 - abs( x - 0.5 ) - slant * y;
				x = 1.-x;
				x*2.+.5;

				getFuzzedAlpha(fixed2(x,y));

				return fixed2(x,y);
			}
			
			
			#include "ingredients/utilities.cginc"

			fixed4 frag (v2f i) : SV_Target
			{
				// calls getUvs and gives me a 'uv' var suited to the object:
				setSpaceTime(i.uv);

				// Layers
				fixed3 baseLayer = _BaseColor;
				fixed3 resonanceLayer = resonance(i.uv,time,_ScaleY) * _ResonanceDimmer * _ResonanceColor * _ShowResonance;			
				fixed3 frostLayer = quadFrost(myUv, time, _ScaleY) * _FrostColor * _ShowFrost;

				// Everything
				fixed3 layers = resonanceLayer + layer3( frostLayer, baseLayer );
				//return fixed4( layers * shape, fuzzedAlpha );
				
				return finalCol(debugVariable(i.uv.y));
			}

			ENDCG
		}
	}
}
