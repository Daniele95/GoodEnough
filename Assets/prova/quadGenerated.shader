Shader "Unlit/quadGenerated"
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
			
			float time;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 waveCenter = float2(0,0);
				//float3 result = resonance(i.uv,_Time.y,6);
				float3 result = quadFrost(i.uv, _Time.y, 3);
				return float4(result,1.);
			}
			ENDCG
		}
	}
}
