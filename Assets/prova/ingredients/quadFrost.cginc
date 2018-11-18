// props
fixed TailCap; // 0 1 0.08
fixed TailSlope; // 0 5 1.31
fixed TailSmoothness; // 0 1 0.712
fixed StartTime; // 0 1 1
fixed T1; // 0 1 0.15
fixed T2; // 0 1 0.25
fixed T3; // 0 1 0.9
fixed TailHeight; // 0 1 0.158
fixed TailHeightOffset; // 0 1 0.3
fixed TailFalloff; // 0 10 2.1
fixed TailHeightPow; // 0 3 2
//


fixed ratioFunc(fixed x, fixed cap, fixed slope, fixed smoothness)
{
    return 1.0 / (cap + pow(x / slope, smoothness));
}

// Draws on the cue using a and b as outline
fixed quadDraw(fixed x, fixed a, fixed b, fixed ramp)
{
	// pow uses uneven exponent to avoid artifacts on top of cue
    fixed smoothLower = clamp(pow(1.0 + (x - a), 3.0), 0.0, 1.0);
    fixed smoothUpper = clamp(pow(1.0 - (x - b), 3.0), 0.0, 1.0);
    fixed s = smoothLower * (x < 0.0) + smoothUpper * (x > 0.0); // smoother
    return pow(s, TailFalloff) * 2.5 * ramp * (TailHeight + TailHeightOffset);
}


fixed between(fixed x, fixed a, fixed b)
{
    return x * step(a, x) * step(x, b);;
}

fixed quadFrost(fixed2 uv, fixed time, float ScaleY)
{

    fixed leadingInTime = between(time, 0., 1.);
    fixed riseTime = between(time, 1., 2.);

	// Helpers
    fixed scaleY = ScaleY * 10.0;
    fixed tailCap = TailCap * 8.0 / scaleY * 60.0;
    fixed tailSlope = TailSlope * 0.058;
    fixed tailSmoothness = TailSmoothness * 7.6;

	// Time and space coordinates
    if (leadingInTime != 1.0)
    {
        riseTime = 0.0;
    }
    if (riseTime != 0.0)
    {
        leadingInTime = 1.0;
    }

    fixed posY = leadingInTime;
    fixed tailHeadUp = (fixed) smoothstep(0.0, T1, posY);
    fixed tailSidesUp = (fixed) smoothstep(T1, T2, posY);
    fixed tailGoesUp = (fixed) smoothstep(0.0, T3, riseTime);
    fixed x = uv.x;
    if (x > 0.5)
    {
        x = 1.0 - x;
    }
    fixed shiftY = (fixed) (uv.y - tailGoesUp) * scaleY / 20.0;
    fixed height = (fixed) (pow(TailHeight, TailHeightPow) * tailHeadUp);
	
	// Create frost
    fixed function = (fixed) ratioFunc(x, tailCap, tailSlope, tailSmoothness);
    fixed funcUp = height + (tailSidesUp - tailGoesUp) * function;
    fixed funcLow = -height - tailGoesUp * function;
	
	// To gain correct smooth transition in the first part
    funcUp += (-0.4 + tailHeadUp / 4.0) * pow(posY - T3, 2);

    return quadDraw(shiftY, funcLow, funcUp, tailHeadUp);
}