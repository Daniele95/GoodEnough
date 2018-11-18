fixed Width; // 0 1 1
fixed Fuzziness; // 0 1 1

fixed ring(fixed2 uv, fixed t)
{
				// Helpers
    fixed fuzziness = Fuzziness * 2.0 + 0.5;
    fixed width = Width * 2.0;
			
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