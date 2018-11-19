Shader "Unlit/circleGenerated"
{
    Properties
    {

        [Header(cueProperties)]

        _Alpha("_Alpha", Range(0, 1)) = 1
        _BaseColor("_BaseColor", Color ) = (1, 1, 1)
        _ResonanceColor("_ResonanceColor", Color ) = (1, 1, 1)
        [Toggle] _ShowResonance("_ShowResonance", Float ) = 1
        _FrostColor("_FrostColor", Color ) = (1, 1, 1)
        [Toggle] _ShowFrost("_ShowFrost", Float ) = 1
        _ResonanceDimmer("_ResonanceDimmer", Range(0, 1)) = 1
        _ScaleY("_ScaleY", Range(0, 10)) = 6
        time("time", Range(0, 2)) = 1

        [Header(fuzz)]

        _FuzzLengthMultiplier("_FuzzLengthMultiplier", Range(0, 1)) = 0.6
        _FuzzAmount("_FuzzAmount", Range(0, 10)) = 6
        _FuzzPower("_FuzzPower", Range(0, 10)) = 2.5

        [Header(colorMixing)]


        [Header(resonance)]

        WaveCenter("WaveCenter", Vector) = (1, 1, 1, 1)
        WaveFront("WaveFront", Range(0, 1)) = 1
        Randoms("Randoms", Vector) = (1, 1, 1, 1)
        WaveDensity("WaveDensity", Range(0, 100)) = 15
        Speed("Speed", Range(0, 100)) = 9
        CircleDensity("CircleDensity", Range(0, 10)) = 0.7
        Amplitude("Amplitude", Range(0, 1)) = 0.67
        Frequency("Frequency", Range(0, 10)) = 4.6
        Pitch("Pitch", Range(0, 127)) = 30
        Circularity("Circularity", Range(0, 1)) = 0.68
        Sharpness("Sharpness", Range(0, 10)) = 1.2
        Strength("Strength", Range(0, 10)) = 1.9
        TimeMultiplier("TimeMultiplier", Range(0, 10)) = 0.5

        [Header(circleFrost)]

        _FrostWidth("_FrostWidth", Range(0, 1)) = 1
        _FrostHeight("_FrostHeight", Range(0, 1)) = 1
        _FrostHeightDivider("_FrostHeightDivider", Range(0, 10)) = 5
        _FrostMaxWidthTime("_FrostMaxWidthTime", Range(0, 1)) = 1
        _FrostMaxHeightTime("_FrostMaxHeightTime", Range(0, 1)) = 1
        _FrostSideHeightPercent("_FrostSideHeightPercent", Range(0, 1)) = 1

        [Header(circleRing)]

        Width("Width", Range(0, 1)) = 1
        Fuzziness("Fuzziness", Range(0, 1)) = 1

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

				getFuzzedAlpha(fixed2(length(centeredUv)+.5,0.));

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
