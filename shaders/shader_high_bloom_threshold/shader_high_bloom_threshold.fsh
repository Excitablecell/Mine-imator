uniform float uThreshold;

varying vec2 vTexCoord;

/*void main()
{
	vec4 baseColor = texture2D(gm_BaseTexture, vTexCoord);
	
	if (max(max(baseColor.r, baseColor.g), baseColor.b) > uThreshold)
		gl_FragColor = baseColor;
	else
		gl_FragColor = vec4(vec3(0.0), 1.0);
}*/

void main()
{
	vec4 baseColor = texture2D(gm_BaseTexture, vTexCoord);
	float brightness = 0.299*baseColor.r + 0.587*baseColor.g + 0.114*baseColor.b;
    if(brightness > uThreshold) {
       gl_FragColor = baseColor;
    }
    else
	{
		gl_FragColor = vec4(vec3(0.0), 1.0);
	}
}