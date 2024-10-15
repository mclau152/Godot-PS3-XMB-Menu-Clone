shader_type spatial;

uniform float amplitude : hint_range(0, 1) = 0.1;
uniform float frequency : hint_range(0, 2) = 1.0;
uniform float time_scale : hint_range(0, 5) = 1.0;
uniform vec4 color1 : source_color = vec4(0.0, 0.5, 1.0, 1.0);
uniform vec4 color2 : source_color = vec4(0.0, 1.0, 0.5, 1.0);
uniform float color_speed : hint_range(0, 2) = 0.5;
uniform float glow_strength : hint_range(0, 1) = 0.3;

void vertex() {
    // Get the vertex position
    vec3 vertex = VERTEX;
    
    // Calculate the wave effect
    float wave = sin(vertex.x * frequency + TIME * time_scale) * amplitude;
    wave += cos(vertex.z * frequency * 0.8 + TIME * time_scale * 1.2) * amplitude * 0.8;
    
    // Apply the wave to the y-coordinate
    vertex.y += wave;
    
    // Update the vertex position
    VERTEX = vertex;
    
    // Recalculate the normal
    NORMAL = normalize(vec3(
        -amplitude * frequency * cos(vertex.x * frequency + TIME * time_scale),
        1.0,
        -amplitude * frequency * 0.8 * sin(vertex.z * frequency * 0.8 + TIME * time_scale * 1.2)
    ));
}

void fragment() {
    // Calculate color interpolation factor
    float color_factor = (sin(TIME * color_speed) + 1.0) * 0.5;
    
    // Interpolate between two colors
    vec4 final_color = mix(color1, color2, color_factor);
    
    // Apply the color to the albedo
    ALBEDO = final_color.rgb;
    
    // Add emission for the glow effect
    EMISSION = final_color.rgb * glow_strength;
}