﻿




float4 finalCol(fixed a)
{
    return float4(a, a, a, 1.);
}

float4 finalCol(fixed3 a)
{
    return float4(a, 1.);
}

fixed _between(float a, float b, float x)
{
    return step(a, x) * step(x, b);
}



float3 debugVar(fixed x,fixed left, fixed right)
{
    fixed pace = abs(right - left)/15.;

    fixed3 result = float3(0., 0., 0.);
    fixed a = 0;
    for (float i = left; i < right; i += pace)
    {
        a = _between(i - pace / 2., i + pace / 2., x);

        if (i > 0. && i < 1.)
            result += float3(0., a * i, 0.);
        if (i > 1. && i < 2.)
            result += float3(a * (i - 1.), a * (2. - i), 0.);
        if (i > 2.)
            result += float3(a, a * (i - 2.), 0.);

        if (i < 0. && i > -1.)
            result += float3(0., 0., a * abs(i));
        if (i < -1. && i > -2.)
            result += float3(a * (abs(i) - 1.), 0., a);
        if (i < -2. && i > -3.)
            result += float3(a, a * (abs(i) - 2.), a) / (abs(i) - 2. + 1.);
    }
    return result;
}
