#version 110

uniform float fade_factor;
uniform sampler2D textures[2];
varying vec2 texcoord;

void main()
{

//    gl_FragColor = vec4(0.0, 0.0, 1.0, 0.0);
      gl_FragColor[0] = gl_FragCoord.x/640.0;
      gl_FragColor[1] = gl_FragCoord.y/480.0;
      gl_FragColor[2] = 0.5;
}
