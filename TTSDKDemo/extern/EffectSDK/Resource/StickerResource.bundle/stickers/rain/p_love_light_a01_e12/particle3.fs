precision mediump float;
uniform sampler2D diffuseMap;
varying vec2 v_texCoord;
varying vec4 v_color;

void main()
{
    vec4 color = texture2D(diffuseMap, v_texCoord);
	gl_FragColor = vec4(color.rgb*1.3, color.a);
	}