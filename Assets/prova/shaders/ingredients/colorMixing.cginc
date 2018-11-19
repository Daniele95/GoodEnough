
fixed4 layer4(fixed4 top, fixed4 bottom)
{
    return top + bottom * (1 - top);
}

fixed3 layer3(fixed3 top, fixed3 bottom)
{
    return top + bottom * (1 - top);
}
