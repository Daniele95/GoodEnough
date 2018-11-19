fixed _FuzzLengthMultiplier; // 0 1 0.6
fixed _FuzzAmount; // 0 10 6
fixed _FuzzPower; // 0 10 2.5


fixed getFuzzedAlpha(fixed d, fixed alpha)
{
    fixed fuzz = 1.0 - pow(abs(d), _FuzzPower);
    fuzz += 1.0 - _FuzzAmount;
    return min(fuzz, alpha);
}