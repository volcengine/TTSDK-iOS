uniform sampler2D varImageTex;

varying highp vec2 textureCoord;

varying highp vec4 texBlurShift1;
varying highp vec4 texBlurShift2;
varying highp vec4 texBlurShift3;
varying highp vec4 texBlurShift4;

void main()
{
    lowp vec4 color = texture2D(varImageTex, textureCoord);
    mediump float sum = color.a;
    sum += texture2D(varImageTex, texBlurShift1.xy).a;
    sum += texture2D(varImageTex, texBlurShift1.zw).a;
    sum += texture2D(varImageTex, texBlurShift2.xy).a;
    sum += texture2D(varImageTex, texBlurShift2.zw).a;
    sum += texture2D(varImageTex, texBlurShift3.xy).a;
    sum += texture2D(varImageTex, texBlurShift3.zw).a;
    sum += texture2D(varImageTex, texBlurShift4.xy).a;
    sum += texture2D(varImageTex, texBlurShift4.zw).a;
    
    //rgb channel for smoothSrcImage, alpha channel for smoothVarImage
    gl_FragColor = vec4(color.rgb, sum * 0.1111);
}