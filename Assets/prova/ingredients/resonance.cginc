// props
float4 WaveCenter; // 1 1 1 1
float WaveFront; // 0 1 1
float4 Randoms; // 1 1 1 1
float WaveDensity; // 0 100 15
float Speed; // 0 100 9
float CircleDensity; // 0 10 0.7
float Amplitude; // 0 1 0.67
float Frequency; // 0 10 4.6
float Pitch; // 0 127 30
float Circularity; // 0 1 0.68
float Sharpness; // 0 10 1.2
float Strength; // 0 10 1.9
float TimeMultiplier; // 0 10 0.5
//

float resonance(float2 uv, float time, float scaleY)
{

	// Using floats in this function because fixed caused problems on Android

	// Helpers
    float2 scaledUv = uv * float2(1.0, scaleY / 5.0);
    float speed = Speed * 10.0;
    float frequency = Frequency * 10.0;
    float pitchMultiplier = pow(Pitch / 100.0, 3.0);
	
	// Time and space coordinates
    float2 r = (scaledUv - WaveCenter.xy + Randoms.xy) * WaveDensity;
    float t = time * speed * pitchMultiplier;
	
	// Create wave
    float linear1 = sin(r.x) * sin(t);
    float linear2 = sin(r.y) * sin(t);
    float radius = sqrt(r.x * r.x + r.y * r.y);
    float circular = sin(CircleDensity * (Randoms.z + 0.5) * radius - t);
    float wave = (1 - Circularity) * (linear1 + linear2) + Circularity * circular + 1;

	// Pulsing
    float amplitude = Amplitude * sin(time * frequency * pitchMultiplier) + 1.0;
    float pulsedWave = max(0.0, 0.5 * amplitude * wave);

	// Add in sharpness, strength, and random tuning factors
    float tunedWave = pow(pulsedWave, Sharpness * (Randoms.w + 0.5)) * Strength;

	// Reveal wave up to the "front"
    float waveFront = clamp((WaveFront - uv.y) * 3.0, 0.0, 1.0);

    return tunedWave * waveFront;
}