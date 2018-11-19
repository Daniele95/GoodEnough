fixed _SlantSimple; // 1
fixed _SlantRight; // 1
fixed _SlantHeight; // 0 1 0.2
fixed _SlantAmount; // 0 1 0.72
fixed _HorizontalFrost; // 0

fixed slantedX(fixed2 uv)
{
    if (_SlantSimple) _SlantHeight = 1.0; 

    fixed s = _SlantHeight; // Slant height (y of the corner)
    fixed d = _SlantAmount; // Slant amount (cue's x size)
    fixed m = s / (1.0 - d);
    fixed x = uv.x;

    if (_SlantRight) x = 1.0 - x;

    x = (x - min(uv.y, s) / m) / d; // Transform
    return x;
}
