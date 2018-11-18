

struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
};

struct v2f
{
    fixed4 vertex : SV_POSITION;
    float2 uv : TEXCOORD0; // Use float for uv because it is used in resonance, where fixed causes problems on mobile
   // float4 waveCenter : TEXCOORD1; // Ditto
    fixed4 screenPos : TEXCOORD2;
};

v2f vert(appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = v.uv;
  //  o.waveCenter = mul(_ResonanceWaveCenter, unity_WorldToObject);
    o.screenPos = ComputeScreenPos(o.vertex);
    return o;
}