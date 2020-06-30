precision highp float;

uniform sampler2D inputImageTexture;
varying highp vec2 textureCoordinate;

void main() {
    gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
}
