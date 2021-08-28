varying vec2 vTexCoord;

uniform float uContrast;
uniform float uBrightness;
uniform float uSaturation;
uniform float uVibrance;
uniform vec4 uColorBurn;
uniform float uTemperature;

const lowp vec3 warmFilter =vec3(0.93,0.54,0.0);
const mediump mat3 RGBtoYIQ = mat3(0.299, 0.587, 0.114, 0.596, -0.274, -0.322, 0.212, -0.523, 0.311);
const mediump mat3 YIQtoRGB = mat3(1.0, 0.956, 0.621, 1.0, -0.272, -0.647, 1.0, -1.105, 1.702);
const mediump vec3 luminanceWeighting = vec3(0.2125,0.7154,0.0721);

vec4 rgbtohsb(vec4 c)
{
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec4(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x, c.a);
}


void main()
{
	// Get base
	vec4 baseColor = texture2D(gm_BaseTexture, vTexCoord);
	
	// Brightness and contrast
	//baseColor.rgb = (baseColor.rgb - vec3(0.5)) * vec3(uContrast) + vec3(uBrightness + 0.5);
	//Obsolete old algorithm
	
	baseColor.rgb = (baseColor.rgb - vec3(0.5)) * vec3(uContrast) + vec3(0.5);
	if(uBrightness>0.0)
	{
		baseColor.rgb = baseColor.rgb + baseColor.rgb * (1.0/(1.0-uBrightness)-1.0);
	}
	else
	{
		baseColor.rgb = baseColor.rgb + baseColor.rgb * uBrightness;
	}
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	
	// Saturation
	vec3 W = vec3(0.2125, 0.7154, 0.0721);
	vec3 satIntensity = vec3(dot(baseColor.rgb, W));
	baseColor.rgb = mix(satIntensity, baseColor.rgb, uSaturation);
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	
	// Vibrance(Saturates desaturated colors)
	satIntensity = vec3(dot(baseColor.rgb, W));
	float sat = rgbtohsb(baseColor).g;
	float vibrance = 1.0 - pow(pow(sat, 8.0), .15);
	baseColor.rgb = mix(satIntensity, baseColor.rgb, 1.0 + (vibrance * uVibrance));
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	

	// Color burn
	baseColor.rgb = 1.0 - (1.0 - baseColor.rgb) / uColorBurn.rgb; 
	
	// color temperature
	mediump vec3 yiq = RGBtoYIQ * baseColor.rgb;
	yiq.b = clamp(yiq.b,-0.5226,0.5226);
	lowp vec3 RGB = YIQtoRGB * yiq;
	lowp float A = (RGB.r <0.5? (2.0* RGB.r * warmFilter.r) : (1.0-2.0* (1.0 - RGB.r) * (1.0- warmFilter.r)));
	lowp float B = (RGB.g <0.5? (2.0* RGB.g * warmFilter.g) : (1.0-2.0* (1.0 - RGB.g) * (1.0- warmFilter.g)));
	lowp float C = (RGB.b <0.5? (2.0* RGB.b * warmFilter.b) : (1.0-2.0* (1.0 - RGB.b) * (1.0- warmFilter.b)));
	lowp vec3 processed = vec3(A,B,C);

	gl_FragColor = vec4(mix(RGB, processed,uTemperature), baseColor.a);
	
}


//HSL brightness adjustment(Replaceable)
/*void main()
{
	vec4 baseColor = texture2D(gm_BaseTexture, vTexCoord);
	
	//Convert the RGB value in the range of 0-1 to 0-255
	float r = baseColor.r * 255.0;
	float g = baseColor.g * 255.0;
	float b = baseColor.b * 255.0;
	
	//float L=((max(r,max(g,b))+min(r,min(g,b)))/2.0);
	//Another brightness calculation formula(Replaceable)
	float L=0.3*r+0.6*g+0.1*b;
	float rHS = 0.0;
	float gHS = 0.0;
	float bHS = 0.0;
	
	if(L > 128.0)
	{
		rHS = (r * 128.0 - (L - 128.0) * 256.0) / (256.0 - L);
        gHS = (g * 128.0 - (L - 128.0) * 256.0) / (256.0 - L);
        bHS = (b * 128.0 - (L - 128.0) * 256.0) / (256.0 - L);
	}
	else
	{
		rHS = r * 128.0 / L;
        gHS = g * 128.0 / L;
        bHS = b * 128.0 / L;
    }
	
	float delta = uBrightness*256.0;
    float newL = L + delta - 128.0;
    float newR = .0;
    float newG = .0;
    float newB = .0;
	
    if(newL > 0.0) {
        newR = rHS + (256.0 - rHS) * newL / 128.0;
        newG = gHS + (256.0 - gHS) * newL / 128.0;
        newB = bHS + (256.0 - bHS) * newL / 128.0;
    } else {
        newR = rHS + rHS * newL / 128.0;
        newG = gHS + gHS * newL / 128.0;
        newB = bHS + bHS * newL / 128.0;
		
    }
	baseColor.rgb =vec3(newR/255.0, newG/255.0, newB/255.0);
	baseColor.rgb = (baseColor.rgb - vec3(0.5)) * vec3(uContrast) + vec3(0.5);
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	
	vec3 W = vec3(0.2125, 0.7154, 0.0721);
	vec3 satIntensity = vec3(dot(baseColor.rgb, W));
	baseColor.rgb = mix(satIntensity, baseColor.rgb, uSaturation);
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	
	satIntensity = vec3(dot(baseColor.rgb, W));
	float sat = rgbtohsb(baseColor).g;
	float vibrance = 1.0 - pow(pow(sat, 8.0), .15);
	baseColor.rgb = mix(satIntensity, baseColor.rgb, 1.0 + (vibrance * uVibrance));
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	
	baseColor.rgb = 1.0 - (1.0 - baseColor.rgb) / uColorBurn.rgb; 
	
	gl_FragColor = baseColor;
}


//HSL brightness adjustment(Replaceable)
/*void main()
{
	vec4 baseColor = texture2D(gm_BaseTexture, vTexCoord);
	
	//Convert the RGB value in the range of 0-1 to 0-255
	float r = baseColor.r * 255.0;
	float g = baseColor.g * 255.0;
	float b = baseColor.b * 255.0;
	
	//float L=((max(r,max(g,b))+min(r,min(g,b)))/2.0);
	//Another brightness calculation formula(Replaceable)
	float L=0.3*r+0.6*g+0.1*b;
	float rHS = 0.0;
	float gHS = 0.0;
	float bHS = 0.0;
	
	if(L > 128.0)
	{
		rHS = (r * 128.0 - (L - 128.0) * 256.0) / (256.0 - L);
        gHS = (g * 128.0 - (L - 128.0) * 256.0) / (256.0 - L);
        bHS = (b * 128.0 - (L - 128.0) * 256.0) / (256.0 - L);
	}
	else
	{
		rHS = r * 128.0 / L;
        gHS = g * 128.0 / L;
        bHS = b * 128.0 / L;
    }
	
	float delta = uBrightness*256.0;
    float newL = L + delta - 128.0;
    float newR = .0;
    float newG = .0;
    float newB = .0;
	
    if(newL > 0.0) {
        newR = rHS + (256.0 - rHS) * newL / 128.0;
        newG = gHS + (256.0 - gHS) * newL / 128.0;
        newB = bHS + (256.0 - bHS) * newL / 128.0;
    } else {
        newR = rHS + rHS * newL / 128.0;
        newG = gHS + gHS * newL / 128.0;
        newB = bHS + bHS * newL / 128.0;
		
    }
	baseColor.rgb =vec3(newR/255.0, newG/255.0, newB/255.0);
	baseColor.rgb = (baseColor.rgb - vec3(0.5)) * vec3(uContrast) + vec3(0.5);
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	
	vec3 W = vec3(0.2125, 0.7154, 0.0721);
	vec3 satIntensity = vec3(dot(baseColor.rgb, W));
	baseColor.rgb = mix(satIntensity, baseColor.rgb, uSaturation);
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	
	satIntensity = vec3(dot(baseColor.rgb, W));
	float sat = rgbtohsb(baseColor).g;
	float vibrance = 1.0 - pow(pow(sat, 8.0), .15);
	baseColor.rgb = mix(satIntensity, baseColor.rgb, 1.0 + (vibrance * uVibrance));
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	
	baseColor.rgb = 1.0 - (1.0 - baseColor.rgb) / uColorBurn.rgb; 
	
	gl_FragColor = baseColor;
	
}*/
