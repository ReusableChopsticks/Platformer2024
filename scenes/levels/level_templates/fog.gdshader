shader_type canvas_item;
//render_mode unshaded; // optional

// Noise texture
uniform sampler2D noise_texture: repeat_enable, filter_nearest;
// Fog density
uniform float density: hint_range(0.0, 1.0) = 0.25;
// Fog speed
uniform vec2 speed = vec2(0.02, 0.01);

uniform vec4 base_color: source_color;

// Called for every pixel the material is visible on
void fragment() {
	// Make the fog slowly move
	vec2 uv = UV + speed * TIME;
	// Sample the noise texture
	float noise = texture(noise_texture, uv).r;
	// Convert the noise from the (0.0, 1.0) range to the (-1.0, 1.0) range
	// and clamp it between 0.0 and 1.0 again
	float fog = clamp(noise * 2.0 - 1.0, 0.0, 1.0);
	
	vec3 fog_color_1 = texture(TEXTURE, vec2(UV.x / 2.0 + TIME / 100.0, UV.y / 4.0 - TIME / 100.0)).rgb;
	vec3 fog_color_2 = texture(TEXTURE, vec2(UV.x / 2.0 + 0.5 + TIME / 50.0, UV.y / 4.0 +0.5 - TIME / 160.0)).rgb;
	vec3 fog_color_3 = texture(TEXTURE, vec2(UV.x / 2.0 + 0.25 + TIME / 25.0, UV.y / 4.0 - 0.25 + TIME / 160.0)).rgb;
	vec3 fog_color = mix(fog_color_3, mix(fog_color_1, fog_color_2, 0.5), 0.7);
	
	COLOR.rgb *= fog_color * base_color.rgb;
	
	// Apply the fog effect
	COLOR.a *= fog * density;
}