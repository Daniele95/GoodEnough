// props
fixed _FrostWidth;
fixed _FrostHeight;
fixed _FrostHeightDivider;
fixed _FrostMaxWidthTime;
fixed _FrostMaxHeightTime;
fixed _FrostSideHeightPercent;
fixed _RingWidth;
fixed _RingFuzziness;
//

// Frost functions
fixed plotWithBorders(fixed func, fixed y, fixed x, fixed xWidth)
{
    fixed plot = smoothstep(func + 0.025, func - 0.025, y) * (y > func - 0.5);
    plot *= smoothstep(xWidth, xWidth - 0.1, x);
    plot *= smoothstep(-xWidth, -xWidth + 0.1, x);
    return plot;
}
			
fixed squareRoot(fixed x, fixed xWidth, fixed ySize, fixed percent)
{
    fixed rightBorder = smoothstep(0.47 + percent, 0.47 - percent, x - percent) * (percent > 0.0) + (percent == 0.0);
    fixed leftBorder = smoothstep(-0.47 - percent, -0.47 + percent, x + percent) * (percent > 0.0) + (percent == 0.0);
    fixed output = ySize * sqrt(1.0 - pow(x / xWidth, 2.0)) * rightBorder * (x < xWidth && x > 0.0);
    output += ySize * sqrt(1.0 - pow(x / xWidth, 2.0)) * leftBorder * (x > -xWidth && x < 0.0);
    return output;
}
			
fixed frost(fixed2 uv, fixed t)
{
				// Helpers
    fixed width = _FrostWidth * smoothstep(0.0, _FrostMaxWidthTime, t);
    fixed height = smoothstep(0.0, _FrostMaxHeightTime, t);
    height *= (_FrostHeight / 4.0 + 0.75) / _FrostHeightDivider;
    fixed percent = (_FrostSideHeightPercent + 0.31) * 0.05;
				

				// Create frost
    fixed root = abs(squareRoot(uv.x, width, height / 2.0, percent));
    return plotWithBorders(root, uv.y, uv.x, width);
}

fixed ring(fixed2 uv, fixed t)
{
				// Helpers
    fixed fuzziness = _RingFuzziness * 2.0 + 0.5;
    fixed width = _RingWidth * 2.0;
			
				// Time and space coordinates
    uv *= 2.0;
    fixed r = 0.7 * sqrt(uv.x * uv.x + uv.y * uv.y);
    t /= 1.2;
    fixed ring = step(0.03, t);

				// Create ring
    fixed arg = 20.0 * (r - t) / width / (1.0 + fuzziness);
    ring *= pow(abs(cos(arg)), fuzziness) * step(-3.14159 / 2.0, arg) * step(arg, 3.14159 / 2.0);
    return ring;
}