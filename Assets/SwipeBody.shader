Shader "Cues/SwipeBody"
{
	Properties
	{		
		[Header( Size )]
		_ScaleY ( "Scale Y", Range( 0, 20 ) ) = 3

		[Header( Color )]
		_BaseColor( "Base color", Color ) = ( 1, 1, 1 )
		_ResonanceColor( "Resonance color", Color ) = ( 1, 1, 1 )
		_FrostColor( "Frost color", Color ) = ( 1, 1, 1 )
		
		[Header( Visibility )]
		_Alpha( "Alpha", Range( 0, 1 ) ) = 1
		_InvisibleBelow( "Invisible below", Range( 0, 1 ) ) = 1
		[Toggle] _ShowResonance( "Show resonance", Float ) = 1
		[Toggle] _ShowFrost( "Show frost", Float ) = 1
		_FuzzAmount( "Fuzz amount", Range( 0, 1 ) ) = 0.67
		_FuzzPower( "Fuzz power", Range( 0, 10 ) ) = 6.0
		_FuzzLengthMultiplier( "Fuzz length multiplier", Range( 0, 10 ) ) = 2.5
		
		[Header( Slant shape )]
		[Toggle] _SlantSimple ( "Simple (as opposed to extended)", float ) = 1
		[Toggle] _SlantRight ( "Slant right (as opposed to left)", float ) = 1
		_SlantHeight ( "Height" , Range( 0 , 1 ) ) = 0.2
		_SlantAmount ( "Amount" , Range( 0 , 1 ) ) = 0.72

		[Header( Time )]		
		_FrostLeadingInTime( "Frost leading in time", Range( 0, 1 ) ) = 1
		_FrostRiseTime( "Frost rise time", Range( 0, 1 ) ) = 1
		
		[Header( Resonance )]
		_ResonanceWaveCenter( "Wave center", Vector ) = ( 0, 0, 0, 0 )
		_ResonanceWaveFront( "Wave front", Range( 0, 1 ) ) = 1
		_ResonanceRandoms( "Randoms", Vector ) = ( 1, 1, 1, 1 )
		_ResonanceWaveDensity( "Wave density", Range( 0, 100 ) ) = 14.26
		_ResonanceSpeed( "Wave speed", Range( 0, 100 ) ) = 7.78
		_ResonanceCircleDensity( "Circle density", Range( 0, 10 ) ) = 2
		_ResonanceAmplitude( "Amplitude", Range( 0, 1 ) ) = 0.232
		_ResonanceFrequency( "Frequency", Range( 0, 10 ) ) = 5
		_ResonancePitch( "Pitch", Range( 0, 127 ) ) = 1
		_ResonanceCircularity( "Circularity", Range( 0, 1 ) ) = 0  // Animated
		_ResonanceSharpness( "Sharpness", Range( 0, 10 ) ) = 2
		_ResonanceStrength( "Strength", Range( 0, 10 ) ) = 0  // Animated
		
		[Header( Frost )]
		[Toggle] _HorizontalFrost ( "Horizontal frost", Float ) = 0
		_FrostTailCap( "Tail cap", Range( 0, 100 ) ) = 0.35
		_FrostTailSlope( "Tail slope", Range( 0, 5 ) ) = 1.31
		_FrostTailSmoothness( "Tail smoothness", Range( 0, 1 ) ) = 0.712
		_FrostStartTime( "Start time", Range( 0, 1 ) ) = 1
		_FrostT1( "Time head reaches max", Range( 0, 1 ) ) = 0.15
		_FrostT2( "Time sides reach max", Range( 0, 1 ) ) = 0.25
		_FrostT3( "Time whole tail reaches top", Range( 0, 1 ) ) = 0.9
		_FrostTailHeight( "Tail height", Range( 0, 1 ) ) = 0.53
		_FrostTailHeightOffset( "Tail height offset", Range( 0, 1 ) ) = 0.3
		_FrostTailFalloff( "Tail falloff", Range( 0, 10 ) ) = 1
	}

	SubShader
	{
		Blend SrcAlpha OneMinusSrcAlpha
		Tags { "Queue"="Transparent" }
		
		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "CueShared.cginc"

			// Color
			float3 _BaseColor;
			float3 _ResonanceColor;
			float3 _FrostColor;			

			// Visibility
			fixed _Alpha;
			float _InvisibleBelow;
			fixed _FuzzAmount;			
			fixed _FuzzPower;			
			fixed _FuzzLengthMultiplier;			
			bool _ShowResonance;
			bool _ShowFrost;
					
			// Slant shape
			fixed _SlantSimple;
			fixed _SlantRight;
			fixed _SlantHeight;
			fixed _SlantAmount;

			// Frost
			bool _HorizontalFrost;
			fixed _FrostLeadingInTime;
			fixed _FrostRiseTime;
			
			fixed slantedX( fixed2 uv )
			{
				if ( _SlantSimple )
				{
					_SlantHeight = 1.0;
				}

				fixed s = _SlantHeight;  // Slant height (y of the corner)
				fixed d = _SlantAmount;  // Slant amount (cue's x size)
				fixed m = s / ( 1.0 - d );
				fixed x = uv.x;

				if ( _SlantRight )
				{
					x = 1.0 - x;
				}

				x = ( x - min( uv.y, s ) / m ) / d;  // Transform
				return x;
			}

			fixed4 frag( v2f i ) : SV_Target
			{
				// Discard below
				if( i.uv.y < _InvisibleBelow )
				{
					discard;
				}

				// Shape
				fixed x = slantedX( i.uv );
				fixed y = i.uv.y;
				fixed shape = x >= 0.0 && x <= 1.0 && y >= 0.0 && y <= 1.0;

				// Fuzz
				fixed d = ( x - 0.5 ) * _FuzzLengthMultiplier;
				fixed fuzzedAlpha = getFuzzedAlpha( d, _FuzzAmount, _FuzzPower, _Alpha );
				
				// Horizontal frost
				x = _HorizontalFrost ? i.uv.y : i.uv.x;
				y = _HorizontalFrost ? i.uv.x : i.uv.y;

				// Layers
				fixed3 baseLayer = _BaseColor;
				fixed3 resonanceLayer = resonance( i.uv, i.waveCenter.xy, _Time.y ) * _ResonanceColor * _ShowResonance;
				if ( !_SlantSimple )
				{
					_FrostTailCap *= _ScaleY;  // So that the tails will the same absolute height as simple cues
				}
				fixed3 frostLayer = quadFrost( fixed2( x, y ), _FrostLeadingInTime, _FrostRiseTime, i.screenPos, 8.0 ) * _FrostColor * _ShowFrost;

				// Everything
				fixed4 layers = fixed4( resonanceLayer + layer3( frostLayer, baseLayer ), fuzzedAlpha );
				return layers * shape;
			}
			ENDCG
		}
	}
}
				