attribute vec3 attPosition;
attribute vec2 attUV;

varying vec2 textureCoord;

uniform float widthOffset;
uniform float heightOffset;

varying vec2 textureShift_1;
varying vec2 textureShift_2;
varying vec2 textureShift_3;
varying vec2 textureShift_4;

void main()
{
    gl_Position = vec4(attPosition, 1.0);
    textureCoord = attUV;
    
    textureShift_1 = vec2(attUV + 0.5 * vec2(widthOffset,heightOffset));
    textureShift_2 = vec2(attUV + 0.5 * vec2(-widthOffset,-heightOffset));
    textureShift_3 = vec2(attUV + 0.5 * vec2(-widthOffset,heightOffset));
    textureShift_4 = vec2(attUV + 0.5 * vec2(widthOffset,-heightOffset));
}