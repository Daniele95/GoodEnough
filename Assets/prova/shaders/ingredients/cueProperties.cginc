fixed _Alpha; // 0 1 1
fixed3 _BaseColor; // 1 1 1
fixed3 _ResonanceColor; // 1 1 1
fixed _ShowResonance; // 1
fixed3 _FrostColor; // 1 1 1
fixed _ShowFrost; // 1
fixed _ResonanceDimmer; // 0 1 1
fixed _ScaleY; // 0 10 6
fixed time; // 0 2 1


fixed2 myUv;
float shape; //  https://fogbugz.unity3d.com/default.asp?934464_sjh4cs4ok77ne0cj

fixed2 getUvs(fixed2 uv);

void setSpaceTime(fixed2 standardUv)
{
    if (time == 0) time = _Time.y;
    myUv = getUvs(standardUv);
}



