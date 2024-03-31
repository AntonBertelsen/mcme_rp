//objmc
//https://github.com/Godlander/objmc



#define MIP_FADE (0.8)
#define BASE_BRIGHTNESS (0.2)
#define AO_INTENSIITY (0.7)
#define CUSTOM_MODEL_NORMAL_SHADING (3.0)
#define UNDER_SHADOW_STRENGTH (0.2)
#define DISTANCE_DENSITY (1.25)

//default lighting
if (isCustom == 0) {color *= vertexColor * lightColor * ColorModulator;}
//custom lighting
else if (noshadow == 0) {
    //normal from position derivatives
    vec3 normal = normalize(cross(dFdx(Pos), dFdy(Pos)));

    //block lighting
    #ifdef BLOCK
    float vertical = sign(normal.y) * 0.22 + 0.5;
    float horizontal = abs(normal.z) * 0.15 + 0.7;
	float undershadow =  abs(normal.y);
	if ((normal.y) < 0.7) {
	    undershadow = undershadow * UNDER_SHADOW_STRENGTH * underShadowStrength;
	}
    float brightness = BASE_BRIGHTNESS * baseBrightness + mix(horizontal, vertical, undershadow);
    color *= vec4(vec3(mix(1.0,brightness,CUSTOM_MODEL_NORMAL_SHADING * customModelNormalShading)), 1.0);
    color *= mix(vec4(1.0),vertexColor,AO_INTENSIITY * aoIntensity);
    color *= vec4(1.0,1.0,1.0,DISTANCE_DENSITY * distanceDensity);
    if (color.a < MIP_FADE * customMipFade) discard;
    #endif

    //entity lighting
    #ifdef ENTITY
    //flip normal for gui
    if (isGUI == 1) normal.y *= -1;
    color *= minecraft_mix_light(Light0_Direction, Light1_Direction, normal, overlayColor);
    #endif
    vec4 lightColor2 = lightColor;
	// Assuming lightColor2 is an RGB vec4 representing the light color
	vec3 lightColorRGB = lightColor2.rgb;

	// Calculate the luminance of the fragment color
	float luminance = dot(lightColor.rgb, vec3(0.199, 0.587, 0.414));

	// Define a factor to control the amount of darkening in darker areas
	float darkeningFactor = 0.4; // Adjust this factor as needed

	// Apply darkening only in darker areas (luminance < threshold)
	if (luminance < 20.0) {
		lightColorRGB *= darkeningFactor;
	}

	// Reconstruct the final color with the modified lightColor2
	//lightColor2.rgb = lightColorRGB;
	//lightColor2.w *= 1.8;
    color *= lightColor2 * ColorModulator;
}