//
//  LSLiveEffectDefine.h
//  Pods
//
//  Created by 赵凯 on 2019/4/10.
//

#ifndef LSLiveEffectDefine_h
#define LSLiveEffectDefine_h

typedef struct LSLiveIntensityParam_t {
    // 通用
    float intensity;
    // 美颜
    float smoothIntensity;
    float whiteIntensity;
    float sharpIntensity;
    // 大眼瘦脸
    float eyeIntensity;
    float cheekIntensity;
    float fareyeIntensity;          // 眼间距
    float zoomeyeIntensity;         // 眼缩放
    float rotateeyeIntensity;       // 眼旋转
    float zoomnoseIntensity;        // 缩鼻翼
    float movnoseIntensity;         // 移鼻头
    float movmouthIntensity;        // 嘴巴移动
    float zoommouthIntensity;       // 嘴巴缩放
    float movchinIntensity;         // 下巴上下
    float zoomforeheadIntensity;    // 额头
    float zoomfaceIntensity;        // 瘦脸（拖拽）
    float cutfaceIntensity;         // 削脸
    float smallfaceIntensity;       // 小脸
    float zoomjawboneIntensity;     // 下颌骨
    float zoomcheekboneIntensity;   // 收颧骨
    float draglipsIntensity;        // 嘴角
    float cornereyeIntensity;       // 开眼角
    float lipenhanceIntensity;      // 丰唇
    float pointychinIntensity;      // 尖下巴
    float facesmoothIntensity;      // 脸平滑
    
    // 美黑
    float darkIntensity;
    // 夜间模式
    float nightGamma;           // 0.28
    float nightContrastK;       // 0.41
    float nightContrastB;       // 0.333
    // 彩妆
    float lipIntensity;         // 唇彩
    float blusherIntensity;     // 腮红
    float decreeIntensity;      // 法令纹
    float pouchIntensity;       // 黑眼圈
} LSLiveIntensityParam;

typedef NS_ENUM(NSInteger, LSLiveEffectType) {
    //无效果
    LSLiveEffectNone = 0,
    //美颜
    LSLiveEffectBeautify,
    //美黑
    LSLiveEffectSkinDark,
    //滤镜
    LSLiveEffectFilter,
    //音乐滤镜
    LSLiveEffectMusicFilter,
    //夜间模式
    LSLiveEffectNightMode,
    //变形
    LSLiveEffectReshape,
    //组合效果（2D\3D贴纸、组合）
    LSLiveEffectGroup,
    
    LSLiveEffectReshapeTwoParam,
    //彩妆（口红、腮红）
    LSLiveEffectMakeup,
    //游戏特效
    LSLiveEffectGame,
};

typedef NS_ENUM(NSUInteger, LSLiveEffectUsedType)
{
    LSLiveEffectUsedNone             = 0,
    LSLiveEffectUsedBeautify         = (0x01 << 0),
    LSLiveEffectUsedFilter           = (0x01 << 1),
    LSLiveEffectUsedReshape          = (0x01 << 2),
    LSLiveEffectUsedMusicFilter      = (0x01 << 3),
    LSLiveEffectUsedGroup            = (0x01 << 4),
    LSLiveEffectUsedDark             = (0x01 << 5),
    LSLiveEffectUsedNightMode        = (0x01 << 6),
    LSLiveEffectUsedAlgorithm        = (0x01 << 7),
    LSLiveEffectUsedComposer         = (0x01 << 8),
    LSLiveEffectUsedMakeup           = (0x01 << 9),
};

// EffectSDK Resource load Status 主要指贴纸类
typedef NS_OPTIONS(NSUInteger, LSLiveEffectResStatus) {
    LSLiveEffectResStatusUnknown = 0,
    LSLiveEffectResStatusInit,
    LSLiveEffectResStatusLoading,
    LSLiveEffectResStatusSuccess,
    LSLiveEffectResStatusFail,
};

typedef NS_OPTIONS(NSUInteger, LSLiveAlgorithm) {
    LSLiveAlgorithm_None                         = 0,
    LSLiveAlgorithm_FaceDetect                   = 1,
    LSLiveAlgorithm_Matting                      = 1 << 1,
    LSLiveAlgorithm_Hair                         = 1 << 2,
    LSLiveAlgorithm_SLAM                         = 1 << 3,
    LSLiveAlgorithm_Body                         = 1 << 4,
    LSLiveAlgorithm_FaceTrack                    = 1 << 5,
    LSLiveAlgorithm_Joint                        = 1 << 6,
    LSLiveAlgorithm_FaceCatDetect                = 1 << 7,
    LSLiveAlgorithm_FaceDetect240                = 1 << 8,
    LSLiveAlgorithm_HandBase                     = 1 << 10,
    LSLiveAlgorithm_Skeleton2                    = 1 << 11,
    LSLiveAlgorithm_ExpressionDetect             = 1 << 12,
    LSLiveAlgorithm_Face3DDetect                 = 1 << 13,
    LSLiveAlgorithm_SkySeg                       = 1 << 14,
    LSLiveAlgorithm_SkeletonLiuXing              = 1 << 15,
    LSLiveAlgorithm_Enigma                       = 1 << 16,
};


// 用于 pause/resume 所有游戏特效
#define LSLiveAllTypeEvent 0xFFFFFFFF

/**
 Effect 游戏相关
 */
typedef NS_ENUM(NSUInteger, LSLiveEffectMsg) {
    LSLiveEffectMsgTypeAudioPlayer      = 0x00000015,
    LSLiveEffectMsgTypeAudioRecord      = 0x0000002B,  //effect <-> 客户端 : 录音控制相关请求:1-开始录音，2.结束录音，3.录音文件回传
    LSLiveEffectMsgTypeGameREQ          = 0x0000002D,  //effect -> 客户端: 游戏相关请求, 1 - 开始/再玩, 0 - 退出
    LSLiveEffectMsgTypeGameNTF          = 0x0000002E,  //客户端 -> effect: 开始游戏通知
    LSLiveEffectMsgTypeGameMusic        = 0x0000002F,  //effect -> 客户端: 音乐相关请求, 1 - 开始播放, 0 - 结束播放
    LSLiveEffectMsgTypeGameStartRecord  = 0x00000030,  //effect -> 客户端: 开始录制
    LSLiveEffectMsgTypeGameStopRecord   = 0x00000031,  //effect -> 客户端: 结束录制
    LSLiveEffectMsgGameStartNTF         = 0x00001001,  //客户端 -> effect: 开始游戏告知
    LSLiveEffectMsgGameEndNTF           = 0x00001002,  //客户端 -> effect: 结束游戏告知
    LSLiveEffectMsgGameEndReq           = 0x00001003,  //effect -> 客户端: 结束游戏请求
    LSLiveEffectMsgGamePauseNTF         = 0x00001004,  //客户端 -> effect: 暂停游戏通知
    LSLiveEffectMsgGameResumeNTF        = 0x00001005,  //客户端 -> effect: 继续游戏通知
    LSLiveEffectMsgGameRestartNTF       = 0x00001006,  //客户端 -> effect: 重新开始游戏通知
    LSLiveEffectMsgGameChallengeNTF     = 0x00001007,  //客户端 -> effect: 挑战游戏通知, nArg1 挑战对方的分数
    LSLiveEffectMsgGameResourceLoaded   = 0x00001008,  //effect -> client: game resource is loaded
    LSLiveEffectMsgStickerRecognize     = 0x00001114,  //贴纸识别成功
    
    LSLiveEffectMsgFaceInfo             = 0x0000001D,  //
};

// effect sticker load status
typedef NS_ENUM(NSUInteger, LSStickerStatus) {
    LSStickerStatusInit = 0,
    LSStickerStatusLoading,
    LSStickerStatusValid,
    LSStickerStatusInvalid,
    LSStickerStatusAnimationFinish
};

typedef NS_ENUM(NSInteger, LSEffectAudioRecordStatus)
{
    eLSEffectAudioRecordStart = 0,
    eLSEffectAudioRecordStop = 1,
    eLSEffectAudioRecordComplete = 2
};

// effect gesture type
typedef NS_ENUM(NSUInteger, LSLiveEffectGestureType) {
    LSLiveEffectGestureTypeUnknown = 0,
    LSLiveEffectGestureTypeTap,     //tap 点击
    LSLiveEffectGestureTypePan,     //pan 推动
    LSLiveEffectGestureTypeRotate,  //rotate 旋转
    LSLiveEffectGestureTypePinch,   //pinch（scale）捏合
    LSLiveEffectGestureTypeLongPress    //longpress 长按
};

@interface LSLiveAlgorithmResultData : NSObject

@property (nonatomic, assign) LSLiveAlgorithm algorithmType;

- (instancetype) init;

@end

//人脸检测算法结果
@interface LSLiveFaceDetectResultData : LSLiveAlgorithmResultData

@property (nonatomic, assign) CGFloat yaw;
@property (nonatomic, assign) CGFloat pitch;
@property (nonatomic, assign) CGFloat roll;
@property (nonatomic, assign) NSUInteger action;

@end


#endif /* LSLiveEffectDefine_h */
