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
			float shape;  //  https://fogbugz.unity3d.com/default.asp?934464_sjh4cs4ok77ne0cj
			fixed fuzzedAlpha;
			
			fixed2 getUvs(fixed2 uv) {
				// Slant shape
				fixed x = uv.x;
				fixed y = uv.y;
				fixed slant = ( 1.0 - _SlantAmount ) / 2.0;

				shape = step( slant * y, x );  // Left side
				shape *= step( x, 1.0 - slant * y );  // Right side

				x = 0.5 - abs( x - 0.5 ) - slant * y;
				// Fuzz
				fuzzedAlpha = getFuzzedAlpha(  ( x - 0.5 ) * _FuzzLengthMultiplier, _Alpha );
				return fixed2(x,y);
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				if(time==0) time=_Time.y;

				// Layers
				fixed3 baseLayer = _BaseColor;
				fixed3 resonanceLayer = resonance(i.uv,time,_ScaleY) * _ResonanceDimmer * _ResonanceColor * _ShowResonance;			
				fixed3 frostLayer = quadFrost(getUvs(i.uv), time, _ScaleY) * _FrostColor * _ShowFrost;

				// Everything
				fixed3 layers = resonanceLayer + layer3( frostLayer, baseLayer );
				return fixed4( layers * shape, fuzzedAlpha );

			}

			ENDCG
		}
	}
}
