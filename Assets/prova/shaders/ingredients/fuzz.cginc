fixed _FuzzLengthMultiplier; // 0 1 0.6
fixed _FuzzAmount; // 0 10 6
fixed _FuzzPower; // 0 10 2.5


fixed fuzzedAlpha;

void getFuzzedAlpha(fixed2 uv)
{
    fuzzedAlpha = smoothstep(0.5, 0.4, abs(uv.x - 0.5));
    fuzzedAlpha *= 1. - smoothstep(0.9, 1., uv.y);
}
