precision highp float;

attribute vec3 attPosition;
attribute vec2 attUV;

uniform float angle;
uniform float scale;
uniform vec2 center;
uniform vec4 uv;

varying highp vec2 textureCoordinate;

void main() {
    vec2 pos = attPosition.xy;
    float cosAngle = cos(angle);
    float sinAngle = sin(angle);
    mat2 ratio = mat2(720.0, 0.0, 0.0, 1280.0);
    mat2 ratio_inv = mat2(0.0013888889, 0.0, 0.0, 0.00078125);
    mat2 rotation = mat2(cosAngle, sinAngle, -sinAngle, cosAngle);
    
    pos = ratio_inv * rotation * ratio * (scale * pos) + center;

    gl_Position = vec4(pos, 0.0, 1.0);
    textureCoordinate.x = uv.x + attUV.x * (uv.z - uv.x);
    textureCoordinate.y = uv.y + attUV.y * (uv.w - uv.y);
}
