shader_type fog;

uniform sampler2D noise_text:repeat_enable;
uniform float noise_scale = 1.0;

void fog() {
	vec2 move_uv = vec2(0.0, 0.4)*TIME;
	float noise = texture(noise_text, WORLD_POSITION.xz*noise_scale + move_uv).r;
	DENSITY = noise / 60.0;
	DENSITY *= step(0.0, -SDF);
	ALBEDO = vec3(1.0);

}
