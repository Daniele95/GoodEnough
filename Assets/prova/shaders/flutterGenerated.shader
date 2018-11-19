Shader "Unlit/flutterGenerated"
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

        [Header(quadFrost)]

        TailCap("TailCap", Range(0, 1)) = 0.08
        TailSlope("TailSlope", Range(0, 5)) = 1.31
        TailSmoothness("TailSmoothness", Range(0, 1)) = 0.712
        StartTime("StartTime", Range(0, 1)) = 1
        T1("T1", Range(0, 1)) = 0.15
        T2("T2", Range(0, 1)) = 0.25
        T3("T3", Range(0, 1)) = 0.9
        TailHeight("TailHeight", Range(0, 1)) = 0.158
        TailHeightOffset("TailHeightOffset", Range(0, 1)) = 0.3
        TailFalloff("TailFalloff", Range(0, 10)) = 2.1
        TailHeightPow("TailHeightPow", Range(0, 3)) = 2

        [Header(utilities)]


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
