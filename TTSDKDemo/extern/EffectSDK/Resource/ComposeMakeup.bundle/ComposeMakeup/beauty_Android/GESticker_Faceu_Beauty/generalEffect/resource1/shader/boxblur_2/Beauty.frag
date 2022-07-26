varying highp vec2 textureCoord;

varying highp vec4 texBlurShift1;
varying highp vec4 texBlurShift2;
varying highp vec4 texBlurShift3;
varying highp vec4 texBlurShift4;

uniform sampler2D srcImageTex;
uniform sampler2D blurImageTex;

void main()
{
    //firstly, boxblur src image horizontally
    mediump vec3 sum = texture2D(blurImageTex, textureCoord).rgb;
    sum += texture2D(blurImageTex, texBlurShift1.xy).rgb;
    sum += texture2D(blurImageTex, texBlurShift1.zw).rgb;
    sum += texture2D(blurImageTex, texBlurShift2.xy).rgb;
    sum += texture2D(blurImageTex, texBlurShift2.zw).rgb;
    sum += texture2D(blurImageTex, texBlurShift3.xy).rgb;
    sum += texture2D(blurImageTex, texBlurShift3.zw).rgb;
    sum += texture2D(blurImageTex, texBlurShift4.xy).rgb;
    sum += texture2D(blurImageTex, texBlurShift4.zw).rgb;
    
    mediump vec3 meanColor = sum * 0.1111;
    
    lowp vec3 inColor = texture2D(srcImageTex, textureCoord).rgb;
    
    highp vec3 diffColor = (inColor - meanColor) * 7.07;
    diffColor = min(diffColor * diffColor, 1.0);
    
    gl_FragColor = vec4(meanColor, (diffColor.r + diffColor.g + diffColor.b) * 0.3333);
}