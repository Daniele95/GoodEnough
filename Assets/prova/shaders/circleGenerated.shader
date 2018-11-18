Shader "Unlit/circleGenerated"
{
    Properties
    {

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
