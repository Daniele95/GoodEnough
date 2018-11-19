Shader "Unlit/circle" 
{ 
	Properties 
	{
		// write after this line
		[Toggle]_ShowRing("_ShowRing",Float) = 1
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
			#include "ingredients/circleFrost.cginc"
			#include "ingredients/circleRing.cginc"


			#pragma fragment frag
			#pragma vertex vert
			
			fixed  _ShowRing;

			fixed2 getUvs(fixed2 uv) {
				fixed2 centeredUv = uv - 0.5;
				centeredUv.y += .5;
				centeredUv.y /= 2;

				// Circle shape
				shape = ( ( centeredUv.x * centeredUv.x + centeredUv.y * centeredUv.y ) < 0.25 );	

				getFuzzedAlpha(fixed2((length(centeredUv)+.5),0.));

				return centeredUv;
			}


			fixed4 frag (v2f i) : SV_Target
			{						
				// calls getUvs and gives me a 'uv' var suited to the object:		
				setSpaceTime(i.uv);

				// Non-ring layers (not individually fuzzed/alphaed)
				fixed3 baseLayer = _BaseColor;
				fixed3 resonanceLayer = resonance(i.uv,time,_ScaleY)/6. * _ResonanceColor * _ShowResonance; 
				// Non-centered uv
				fixed3 frostLayer = frost(myUv,time) * _FrostColor * _ShowFrost;

				// Ring layer -- no fuzz/alpha
				fixed4 ringLayer = ring(myUv,time-1.)  * fixed4( _FrostColor, 1.0 ) * _ShowRing;
				
				// Blending
				fixed4 layers = layer4( ringLayer, fixed4( resonanceLayer + layer3( frostLayer, baseLayer ), fuzzedAlpha ) );
				return layers * shape;
			}
			ENDCG
		}
	}
}
