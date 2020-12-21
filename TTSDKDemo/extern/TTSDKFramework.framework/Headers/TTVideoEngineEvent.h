//
//  TTVideoEngineEvent.h
//  Pods
//
//  Created by guikunzhi on 16/12/23.
//
//

#import <Foundation/Foundation.h>

@interface TTVideoEngineEvent : NSObject

@property (nonatomic, copy) NSString *logType;
@property (nonatomic, copy) NSString *sv;   //统计接口的服务端版本号
@property (nonatomic, copy) NSString *pv;   //播放器版本号
@property (nonatomic, copy) NSString *pc;   //内核版本号
@property (nonatomic, copy) NSString *sdk_version;  //sdk版本号
@property (nonatomic, copy) NSString *v;    //视频ID
@property (nonatomic, assign) long long pt;  //用户点击播放的时间戳，单位为毫秒
@property (nonatomic, assign) long long at;  //获取视频列表结束的时间戳，单位是毫秒
@property (nonatomic, assign) long long dns_t; //播放器DNS结束的时间戳，单位是毫秒
@property (nonatomic, assign) long long tran_ct; //TCP连接成功的时间戳，单位是毫秒
@property (nonatomic, assign) long long tran_ft; //TCP第一报时间戳，单位是毫秒
@property (nonatomic, assign) long long re_f_videoframet; //demuxer读到首帧未解码视频数据，单位是毫秒
@property (nonatomic, assign) long long re_f_audioframet; //demuxer读到首帧未解码音频数据，单位是毫秒
@property (nonatomic, assign) long long de_f_videoframet; //decoder解码出第一帧视频帧，单位是毫秒
@property (nonatomic, assign) long long de_f_audioframet; //decoder解码出第一帧音频帧，单位是毫秒
@property (nonatomic, assign) long long bu_acu_t; //卡顿累计时长
@property (nonatomic, assign) long long vt;  //第一帧画面的时间戳，单位是毫秒
@property (nonatomic, assign) long long et;  //用户本次点播视频播放结束的时间戳，单位是毫秒
@property (nonatomic, assign) long long lt;  //用户没有播放视频就离开的时间，单位是毫秒
@property (nonatomic, assign) long long st;  //用户本次拖动点播视频的结束的时间戳，单位是毫秒
@property (nonatomic, assign) long long bft; //用户本次点播视频流加载结束的时间戳，单位是毫秒
@property (nonatomic, assign) NSInteger bc; //网络引起卡顿的次数
@property (nonatomic, assign) NSInteger dbc; //解码慢引起的卡顿次数
@property (nonatomic, assign) NSInteger br; //用户是否发生播放中断
@property (nonatomic, copy) NSArray *vu; //播放url
@property (nonatomic, assign) NSInteger vd; //视频总片长
@property (nonatomic, assign) NSInteger vs; //视频总大小
@property (nonatomic, copy) NSString *codec;    //视频编码类型
@property (nonatomic, assign) NSInteger vps;    //视频播放的字节数
@property (nonatomic, assign) NSInteger vds;    //视频加载的字节数
@property (nonatomic, assign) NSInteger video_preload_size; //视频预加载大小(播放前)
@property (nonatomic, copy) NSString *df;   //视频清晰度(360p, 480p, 720p)
@property (nonatomic, copy) NSString *lf;   //切换前的清晰度
@property (nonatomic, assign) NSInteger errt;   //播放器返回的错误类型
@property (nonatomic, assign) NSInteger errc;   //播放器返回的错误码
@property (nonatomic, strong) NSDictionary *merror;  //main error
@property (nonatomic, assign) BOOL hijack;      // 是否被劫持
@property (nonatomic, strong) NSDictionary *ex;  //附加信息
@property (nonatomic, assign) NSInteger vsc;    //视频状态码
@property (nonatomic, strong) NSDictionary *preload;
@property (nonatomic, strong) NSDictionary *playItem;
@property (nonatomic, strong) NSDictionary *feed;
@property (nonatomic, copy) NSString *initialURL;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *subtag;
@property (nonatomic, assign) BOOL hw; //是否启用硬解
@property (nonatomic, assign) long long downloadSpeed; // 下载速度
@property (nonatomic, assign) NSInteger lc; // loopCount 循环播放次数
@property (nonatomic, assign) long long first_buf_startt; //首次卡顿开始
@property (nonatomic, assign) long long first_buf_endt; //首次卡顿结束
@property (nonatomic, copy) NSString *vtype; //video type
@property (nonatomic, assign) int width; //视频宽
@property (nonatomic, assign) int height; //视频高
@property (nonatomic, assign) NSInteger cache_file;///< 是否启用边播边下
@property (nonatomic, copy) NSString *initial_host;///< 初始播放host
@property (nonatomic, copy) NSString *initial_ip;///< 初始播放使用的ip
@property (nonatomic, copy) NSString *initial_resolution;///< 初始播放使用的分辨率
@property (nonatomic, assign) long long prepare_start_time;///< prepare开始的时间戳，单位是毫秒
@property (nonatomic, assign) long long prepare_end_time;///< prepared的时间戳，单位是毫秒
@property (nonatomic, copy) NSString* render_type;///< 渲染类型
@property (nonatomic, assign) NSInteger use_preload;///< 是否使用了预加载
@property (nonatomic, assign) long long vpls; ///< video_preload_size, 视频预加载大小(播放前)
@property (nonatomic, copy) NSString *wifi_identify;///< wifi名称
@property (nonatomic, assign) NSInteger finish;///< 播放是否完成
@property (nonatomic, assign) long cur_play_pos;///< 当前视频的播放进度：ms
@property (nonatomic, assign) NSInteger pause_acu_t;///< 暂停累积时长
@property (nonatomic, strong) NSMutableArray* per_buffer_duration;///< 每次缓冲的时间段(取绝对时间)
@property (nonatomic, assign) NSInteger try_err_c;///< 错误重试次数非累积（不为0时，表示此次播放错误重试次数超过最大限制）
@property (nonatomic, assign) NSInteger accu_errc;///< 累积错误次数（不为0时 表示此次播放累积错误次数超过了最大限制）
@property (nonatomic, strong) NSMutableDictionary* playparam;///< 业务方设置的播放参数
@property (nonatomic, assign) NSInteger decoder_type;///< 解码器类型（0表示使用FFMPEG解码器 1表示使用金山解码器）
@property (nonatomic, assign) NSInteger play_type;///< 0表示点播，1表示直播回放
@property (nonatomic, assign) CGFloat video_out_fps;///< 渲染帧率
@property (nonatomic, assign) NSInteger watch_dur;///<本次观看时长统计：ms ,-1无效
@property (nonatomic, assign) NSInteger play_back_state;///< 当前的播放状态, -1:无效值0:播放停止 1 :播放中 2:播放暂停 3:播放错误
@property (nonatomic, assign) NSInteger load_state;///< 当前的缓存状态
@property (nonatomic, assign) NSInteger switch_resolution_c; ///<分辨率切换的次数
@property (nonatomic, assign) NSInteger reuse_socket;
@property (nonatomic, assign) NSInteger disable_accurate_start;
@property (nonatomic, assign) NSInteger sc;///< seek 次数，默认为 0
@property (nonatomic,   copy) NSString *proxy_url;///< 代理url
@property (nonatomic, assign) NSInteger drm_type;
@property (nonatomic, copy) NSString *api_string;//play接口请求url
@property (nonatomic, copy) NSString *net_client;//网络库类型，own/user
@property (nonatomic, assign) NSInteger engine_state;//上报日志时engine状态
@property (nonatomic, assign) NSInteger apiver;//play接口version
@property (nonatomic, copy) NSString *auth;//play接口auth
@property (nonatomic, assign) NSInteger start_time;//用户设置的起播时间
@property (nonatomic, assign) NSInteger audio_codec_nameId;//音频的解码器名称
@property (nonatomic, assign) NSInteger video_codec_nameId;//视频的解码器名称
@property (nonatomic, assign) NSInteger bitrate;///< 码率
@property (nonatomic, copy) NSString *source_type;//视频的播放类型
@property (nonatomic, assign) NSInteger bufferTimeOut;

//@property (nonatomic, assign) NSInteger render_error_msg;///< 渲染相关错误信息，直接CheckError之后返回,0表示正常
//@property (nonatomic, assign) NSInteger action_before_finish;///< 结束之前执行的操作 ,为了便于统计什么操作影响了结束，操作记录是互斥的，只保留最后一个操作。
//@property (nonatomic, assign) NSInteger action_before_buffer;///< 缓冲之前相关操作，为了便于统计什么造成缓冲，操作记录是互斥的，只保留最后一个操作。
//@property (nonatomic, strong) NSDictionary *player_parameters;///< 结束播放时上传播放器相关参数
//@property (nonatomic, assign) NSInteger video_out_fps;///< 当前渲染帧率


- (NSDictionary *)jsonDict;

@end
