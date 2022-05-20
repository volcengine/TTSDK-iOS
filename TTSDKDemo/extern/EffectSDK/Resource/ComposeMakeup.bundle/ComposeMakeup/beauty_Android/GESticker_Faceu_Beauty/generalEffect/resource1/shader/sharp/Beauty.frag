precision mediump float;
varying highp vec2 textureCoord;

varying highp vec2 textureShift_1;
varying highp vec2 textureShift_2;
varying highp vec2 textureShift_3;
varying highp vec2 textureShift_4;

uniform sampler2D srcImageTex;
uniform sampler2D blurImageTex;

uniform lowp float blurAlpha;
uniform lowp float sharpen;

uniform  vec4 frequencyRangeValue;
uniform  vec4 frequencyRangeBlur; 

const float theta = 0.1;

void main()
{
    //firstly, smooth
    lowp vec4 preColor = texture2D(blurImageTex, textureCoord);
    
    lowp vec4 inColor = texture2D(srcImageTex, textureCoord);
    lowp vec3 meanColor = preColor.rgb;
    
    
    mediump float p = clamp((min(inColor.r, meanColor.r-0.1)-0.2)*4.0, 0.0, 1.0);
    mediump float kMin = (1.0 - preColor.a / (preColor.a + theta)) * p * blurAlpha;
    
    if(kMin > 1.0 - frequencyRangeValue.x)
    {
        kMin = kMin * frequencyRangeBlur.x ; 
    }
    else if(kMin > 1.0 - frequencyRangeValue.y)
    {
        kMin = kMin * frequencyRangeBlur.y; 
    }
    else if(kMin > 1.0 - frequencyRangeValue.z)
    {
        kMin = kMin * frequencyRangeBlur.z; 
    }
    else
    {
        kMin = kMin * frequencyRangeBlur.w;       
    }   

    lowp vec3 smoothColor = mix(inColor.rgb, meanColor.rgb, kMin);
    
    //secondly, sharpen
    mediump float sum = texture2D(srcImageTex,textureShift_1).g;
    sum += texture2D(srcImageTex,textureShift_2).g;
    sum += texture2D(srcImageTex,textureShift_3).g;
    sum += texture2D(srcImageTex,textureShift_4).g;
    sum = sum * 0.25;
    
    
    float hPass = inColor.g - sum + 0.5;
    float flag = step(0.5, hPass);
    
    vec3 tmpColor = vec3(2.0 * hPass + smoothColor - 1.0);
    vec3 sharpColor = mix(max(vec3(0.0), tmpColor), min(vec3(1.0), tmpColor), flag);
    
    lowp vec3 epmColor = mix(smoothColor.rgb, sharpColor, sharpen);
    
    gl_FragColor = vec4(epmColor, 1.0);
}