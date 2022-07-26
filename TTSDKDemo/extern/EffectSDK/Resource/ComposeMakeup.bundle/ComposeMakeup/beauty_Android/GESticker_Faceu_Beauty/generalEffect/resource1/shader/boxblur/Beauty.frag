uniform sampler2D srcImageTex;

varying highp vec2 textureCoord;

varying highp vec4 texBlurShift1;
varying highp vec4 texBlurShift2;
varying highp vec4 texBlurShift3;
varying highp vec4 texBlurShift4;

void main()
{
    mediump vec3 sum = texture2D(srcImageTex, textureCoord).rgb;
    sum += texture2D(srcImageTex, texBlurShift1.xy).rgb;
    sum += texture2D(srcImageTex, texBlurShift1.zw).rgb;
    sum += texture2D(srcImageTex, texBlurShift2.xy).rgb;
    sum += texture2D(srcImageTex, texBlurShift2.zw).rgb;
    sum += texture2D(srcImageTex, texBlurShift3.xy).rgb;
    sum += texture2D(srcImageTex, texBlurShift3.zw).rgb;
    sum += texture2D(srcImageTex, texBlurShift4.xy).rgb;
    sum += texture2D(srcImageTex, texBlurShift4.zw).rgb;
    
    gl_FragColor = vec4(sum * 0.1111, 1.0);
}