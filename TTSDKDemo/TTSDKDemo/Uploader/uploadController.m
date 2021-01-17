//
//  uploadController.m
//  TTSDKDemo
//
//  Created by bytedance on 2020/10/29.
//  Copyright © 2020 ByteDance. All rights reserved.
//

#import "uploadController.h"
#import "TTFileUploadDemoUtil.h"
#import "UIBlockSegmentedControl.h"
#import "MWPhotoBrowser.h"
#import <TTSDK/TTVideoUploadClientTop.h>
#import <TTSDK/TTImageUploadClientTop.h>
#import <TTSDK/TTFUConstDefination.h>
#import <TTSDK/TTVideoUploadEventManager.h>
#import <RangersAppLog/RangersAppLogCore.h>

//#import "MWPhotoBrowser.h"
typedef NS_ENUM(NSInteger,AlbumPickType){
    AlbumPickTypeVideo,
    AlbumPickTypePhoto,
};

#define BUTTONWIDTH 80
#define BUTTONHEIGHT 30
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface uploadController ()

@property (nonatomic, weak) IBOutlet UIButton *uploadButton;
@property (nonatomic, weak) IBOutlet UILabel *progressLabel;
@property (nonatomic, strong) TTVideoUploadClientTop *videoUploadClientTop;
@property (nonatomic, strong) TTImageUploadClientTop *imageUploadClientTop;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval finishTime;
@property (nonatomic, assign) BOOL isImageX;
@property (nonatomic, assign) BOOL VideoOnce;
@property (nonatomic, assign) BOOL ImageOnce;
@property (nonatomic, assign) BOOL isProcessImage;
@property (nonatomic, assign) BOOL isfilePath;
@property (nonatomic, assign) int i;
@property (nonatomic, assign) int v;
@property (nonatomic, assign) TTImageUploadActionType processType;
@property (nonatomic, assign) TTVideoUploadActionType processTypeVideo;
@property (nonatomic, copy) NSString* userName;
@property (nonatomic, copy) NSString* authorization;
//@property (nonatomic, copy) NSString* userNameEncryption;
//@property (nonatomic, copy) NSString* authorizationEncryption;
//@property (nonatomic, copy) NSString* userNameUri;
//@property (nonatomic, copy) NSString* authorizationUri;
@property (nonatomic, copy) NSString* hostName;
@property (nonatomic, strong) UIView* segmentContainView;
@property (nonatomic, strong) UIView* buttonsContainView;
@property (nonatomic, strong) UIView* fileButtonContainView;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *selections;
@property (nonatomic, assign) AlbumPickType pickType;
@property (nonatomic, strong) NSMutableArray* resultArray;
@property (nonatomic, strong) NSMutableArray* fileArray;
@property (nonatomic, copy) NSArray* filePathArray;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) UIActivityIndicatorView* loadingView;
@property (nonatomic, copy) NSString* applyAuth;
@property (nonatomic, copy) NSString* commitAuth;
@property (nonatomic, copy) NSString* authParameter;
@property (nonatomic, strong) NSTimer* timer;

@property (nonatomic, copy) NSString *sessionToken;
@property (nonatomic, copy) NSString *accessKey;
@property (nonatomic, copy) NSString *secretKey;
@property (nonatomic, strong) NSDate *expirationTime;
@property (nonatomic, copy) NSString *regionName;

@end
@implementation uploadController
//- (NSArray*)buttonDescription;
- (void)viewDidLoad{
    [super viewDidLoad];
    //_progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, 100, 40)];
    //[self.view addSubview:_progressLabel];
        self.progressLabel.text = @"";
        _userName = @"3413ace7e2a9a235a9d5807ad78d9bac";
        _authorization = @"HMAC-SHA1:1.0:2468203903:3413ace7e2a9a235a9d5807ad78d9bac:5ImkEneliRE+ItD3zzrehsaOnak=";
    
        _hostName = @"imagex.volcengineapi.com";
        _isImageX = YES;
        _isProcessImage = NO;
        _isfilePath = YES;
        _ImageOnce = YES;
        _VideoOnce = YES;
        self.view.backgroundColor = [UIColor whiteColor];
        _pickType = AlbumPickTypePhoto;
        _resultArray = [NSMutableArray arrayWithCapacity:10];
        _fileArray = [NSMutableArray arrayWithCapacity:10];
        _assets = [NSMutableArray arrayWithCapacity:1000];
        [TTVideoUploadEventManager sharedManager].delegate = self;
        
        __weak typeof(self) weakSelf = self;

        NSLog(@"authparam is %@",_authParameter);
        [self initUploader];
        [self initUI];
}
- (NSArray *)imageButtonDescription
{
    __weak typeof(self) weakSelf = self;
    return @[
             @{@"title": @"ImageStart",
               @"handleBlock": ^{
                   __strong typeof(weakSelf) self = weakSelf;
                   if (self.imageUploadClientTop == nil) {
                       [self alertViewController:@"请重新选择图片！！！" title:@"错误"];
                   }
                   self.startTime = [[NSDate date] timeIntervalSince1970];
                   [self.imageUploadClientTop start];
               }
               },
             @{@"title": @"ImageStop",
               @"handleBlock": ^{
                   __strong typeof(weakSelf) self = weakSelf;
                   [self.imageUploadClientTop stop];
               }
               },
             @{@"title": @"ImageClose",
               @"handleBlock": ^{
                   __strong typeof(weakSelf) self = weakSelf;
                   [self.imageUploadClientTop close];
                   self.imageUploadClientTop = nil;
               }
               },
             ];
}
- (NSArray *)videoButtonDescription
{
    __weak typeof(self) weakSelf = self;
    return @[
             @{@"title": @"VideoStart",
               @"handleBlock": ^{
                   __strong typeof(weakSelf) self = weakSelf;
                    if (self.videoUploadClientTop == nil) {
                        [self alertViewController:@"请重新选择视频！！！" title:@"错误"];
                    }
                   self.startTime = [[NSDate date] timeIntervalSince1970];
                   [self.videoUploadClientTop start];
                  }
               },
             @{@"title": @"VideoStop",
               @"handleBlock": ^{
                   __strong typeof(weakSelf) self = weakSelf;
                   [self.videoUploadClientTop stop];
               }
               },
             @{@"title": @"VideoClose",
               @"handleBlock": ^{
                [self.videoUploadClientTop stop];
                 self.videoUploadClientTop = nil;
               }
               },
             ];

}

- (void)alertViewController:(NSString*)message title:(NSString*)title{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:NO completion:nil];
}

- (void)setupfilePaths{
    NSString* filePath2 = [[NSBundle mainBundle] pathForResource:@"test1" ofType:@"png"];
    if(filePath2 != nil){
        _filePathArray = @[filePath2];
    }
}

- (void)initUI{
    [self initSegmaent];
    [self initButtons];
    [self initsetImages];
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _loadingView.backgroundColor = [UIColor grayColor];
    _loadingView.frame = CGRectMake(0, 0, 50, 50);
    _loadingView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    _loadingView.hidesWhenStopped = YES;
    [self.view addSubview:_loadingView];
}

- (void) getAuth{
    NSString* url;
    if (_isImageX) {
        url = @"http://vod-sdk-playground.snssdk.com/api/v1/get_image_upload_token?ak=AKLTNzg3MGY3YzdkYWY5NGMzMDkwNTEyMTI1NzYyOGE0MDE&sk=zqwmw2zQT/cQNTWrCEUf3DY5WVaYmbfwX/nutLW7Reauf0WX/35FsY18oORMEZt9&service_id=19tz3ytenx";
    }else {
        url = @"http://vod-app-server.bytedance.net/api/sts2/v2/upload?LTAK=AKLTZWE1ZDM4YTY1MDk4NDE3NzgyMDU4ZWExN2YzZTUzMjI&LTSK=TURBMU9XRTRNVGRtTURjd05EWTRPV0V4TURjM09EUXhaamxpWlRneVpqWQ==&expiredTime=10";
    }
    
    [TTFileUploadDemoUtil configTaskWithURL:url params:nil headers:nil completion:^(id  _Nullable jsonObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error:%@",error);
            [self getAuth];
            return ;
        }
        if (jsonObject) {
            NSLog(@"json Objct:%@",jsonObject);
            NSString* result = jsonObject[@"token"];
            if (_authParameter == nil) {
                _authParameter = result;
                [self initUploader];
            }
            _authParameter = result;
        } else {
            [self getAuth];
        }
    }];
    
    
    
}

- (void)buttonAction{
    [_resultArray removeAllObjects];
    [_fileArray removeAllObjects];
    [self dealAssets];
}

- (void)dealAssets{
}

- (void)configTaskWithURL:(NSString *)urlString params:(NSDictionary *)params headers:(NSDictionary *)headers completion:(void (^)(id _Nullable jsonObject, NSError * _Nullable error))completionHandler
{
    NSString *originURL = urlString;
    NSMutableString *requestURL = [NSMutableString stringWithString:originURL];
    if (params != nil) {
        NSRange range = [originURL rangeOfString:@"?"];
        if (range.location == NSNotFound) {
            [requestURL appendString:@"?"];
        }
        else if (range.location != originURL.length - 1) {
            [requestURL appendString:@"&"];
        }
        NSUInteger keysNum = [params allKeys].count;
        for (int i = 0; i < keysNum; i++) {
            NSString *key = [[params allKeys] objectAtIndex:i];
            NSString *value = [params objectForKey:key];
            NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *encodedValue = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [requestURL appendString:[NSString stringWithFormat:@"%@=%@",encodedKey,encodedValue]];
            if (i != keysNum - 1) {
                [requestURL appendString:@"&"];
            }
        }
    }
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    //    [urlRequest setValue:@"TTVideoEngine(iOS)" forHTTPHeaderField:@"User-Agent"];
    for (NSString *key in [headers allKeys]) {
        [urlRequest setValue:[headers valueForKey:key] forHTTPHeaderField:key];
    }
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:[urlRequest copy]
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                if (error) {
                                                    completionHandler(nil,error);
                                                }
                                                else {
                                                    NSLog(@"**********************************%@",((NSHTTPURLResponse*)response).allHeaderFields);
                                                    NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
                                                    if ([response isKindOfClass:[NSHTTPURLResponse class]] && (statusCode == 200 || statusCode == 403)) {
                                                        NSError *jsonError = nil;
                                                        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:nil error:&jsonError];
                                                        if (jsonError) {
                                                            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:jsonError.userInfo];
                                                            if (data) {
                                                                const char *cStr = (const char *)[data bytes];
                                                                NSString *body = nil;
                                                                if (cStr != NULL) {
                                                                    body = [NSString stringWithUTF8String:cStr];
                                                                }
                                                                if (body) {
                                                                    [userInfo setValue:body forKey:@"body"];
                                                                } else {
                                                                    [userInfo setValue:@"" forKey:@"body"];
                                                                }
                                                            }
                                                            NSError *parseError = [NSError errorWithDomain:jsonError.domain code:jsonError.code userInfo:userInfo];
                                                            completionHandler(nil,jsonError);
                                                        }
                                                        else {
                                                            NSError *retError = nil;
                                                            if (statusCode != 200) {
                                                                
                                                            }
                                                            completionHandler(jsonObject,retError);
                                                        }
                                                    }
                                                    else {
                                                        completionHandler(nil,[NSError errorWithDomain:@"not 200" code:-1000 userInfo:@{@"description": response.description ?:@""}]);
                                                    }
                                                }
                                            }];
    [task resume];
    
}

- (void)alertView:(TTUploadImageInfoTop*)imageInfo message:(NSString*)messageStr title:(NSString*)title{
    NSString *message;
    [self descriptionOther:imageInfo];
    if (messageStr) {
        message = [NSString stringWithFormat:@"%@\n%@",messageStr,message?:@""];
    }
    [self alertViewController:message title:title];
}

-(NSString *)descriptionOther:(id)model{
    unsigned int count;
    const char *clasName = object_getClassName(model);
    NSMutableString *string = [NSMutableString stringWithFormat:@"<%s: %p>:[ \n",clasName, self];
    Class clas = NSClassFromString([NSString stringWithCString:clasName encoding:NSUTF8StringEncoding]);
    Ivar *ivars = class_copyIvarList(clas, &count);
    for (int i = 0; i < count; i++) {
        @autoreleasepool {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            //得到类型
            NSString *type = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
            NSString *key = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            id value = [model valueForKey:key];
            //确保BOOL 值输出的是YES 或 NO，这里的B是我打印属性类型得到的……
            if ([type isEqualToString:@"B"]) {
                value = (value == 0 ? @"NO" : @"YES");
            }
            [string appendFormat:@"\t%@: %@\n",[self delLine:key], value];
        }
    }
    free(ivars);
    [string appendFormat:@"]"];
    NSLog(@"=========>resulet:%@",string);
    return string;
}

-(NSString *)delLine:(NSString *)string{
    if ([string hasPrefix:@"_"]) {
        return [string substringFromIndex:1];
    }
    return string;
}


- (void)requestSign{
    __weak typeof(self) weakSelf = self;
        /*vod账号信息*/
        NSString * url = nil;
        if(_isImageX){
            url = @"http://vod-sdk-playground.snssdk.com/api/v1/sign_sts2?ak=AKLTNzg3MGY3YzdkYWY5NGMzMDkwNTEyMTI1NzYyOGE0MDE&sk=zqwmw2zQT/cQNTWrCEUf3DY5WVaYmbfwX/nutLW7Reauf0WX/35FsY18oORMEZt9&expire=50000";
        }
        else{
            url = @"http://vod-app-server.bytedance.net/api/sts2/v2/upload?LTAK=AKLTZWE1ZDM4YTY1MDk4NDE3NzgyMDU4ZWExN2YzZTUzMjI&LTSK=TURBMU9XRTRNVGRtTURjd05EWTRPV0V4TURjM09EUXhaamxpWlRneVpqWQ==&expiredTime=10";
            }
                /* imageX账号信息*/
                [TTFileUploadDemoUtil configTaskWithURL:url params:nil headers:nil completion:^(NSMutableDictionary*  _Nullable jsonObject, NSError * _Nullable error){
            //[TTFileUploadDemoUtil configTaskWithURL:@"http://vod-sdk-playground.snssdk.com/api/v1/sign_sts2?ak=AKLTZjRkNWRhOTExNzVhNDgzMmExMGM4OTdjNDM1YzMxMzM&sk=vluAyFdJFItpD/fvXchJouMLRHMYO0LjUzCvWMM7XnxYi9SPxk3CQC6mlrJOLhxy&expire=10000" params:nil headers:nil completion:^(NSMutableDictionary*  _Nullable jsonObject, NSError * _Nullable error){
                        __strong typeof(self) strongSelf = weakSelf;
                        if (error) {
                            NSLog(@"error = %@",error);
                            dispatch_async(dispatch_get_main_queue(), ^{
            //                    [strongSelf alertTitle:NULL Message:error.domain];
                            });
                        }
                        if (jsonObject) {
                            NSLog(@"json Objct:%@",jsonObject);
                            NSDictionary* result;
                            if(_isImageX){
                                result = jsonObject[@"token"];
                            }else{
                                result = jsonObject[@"result"];
                            }
                            if (result) {
                                strongSelf.accessKey = nil;
                                strongSelf.secretKey = nil;
                                strongSelf.sessionToken = nil;
                                strongSelf.expirationTime = nil;
                                
                                if(_isImageX){
                                    strongSelf.accessKey = result[@"AccessKeyId"];
                                }else{
                                    strongSelf.accessKey = result[@"AccessKeyID"];
                                }
                                strongSelf.secretKey = result[@"SecretAccessKey"];
                                strongSelf.sessionToken = result[@"SessionToken"];
                                strongSelf.expirationTime = result[@"ExpiredTime"];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.videoUploadClientTop setAuthorizationParameter:[self authorizationParameter]];
                                        [self.imageUploadClientTop setAuthorizationParameter:[self authorizationParameter]];
                                    });

                            }
                        }
                    }];
        }

    - (NSDictionary*)authorizationParameter{
                                NSDictionary* dictionary = @{@"TTFileUploadAccessKey":self.accessKey?:@"",
                                     @"TTFileUploadSecretKey":self.secretKey?:@"",
                                     @"TTFileUploadSessionToken":self.sessionToken?:@"",
                                     @"TTFileUploadExpiredTime":self.expirationTime?:@"",
                                     @"TTFileUploadRegionName":@"cn-north-1"
                                     };
        return dictionary;
}

#pragma -mark UI
- (void)initSegmaent{
    UIView* containView = [[UIView alloc] initWithFrame:CGRectMake(0, 48, WIDTH, 150)];
//    containView.backgroundColor = [UIColor yellowColor];
    _segmentContainView = containView;
    [self.view addSubview:containView];
    NSInteger tag = 101;
    NSArray *netArray = @[@"imageX",@"imageXIM",@"VideoAPI2.0"];
    CGRect netFrame = CGRectMake(10,  40, 100, 40);
    UIBlockSegmentedControl* netWorkControll = [UIBlockSegmentedControl initSegMentFrame:netFrame item:netArray tag:++tag];
    [netWorkControll addActionBlock:^{
        if (netWorkControll.selectedSegmentIndex == 0) {
            _isImageX = YES;
            _processType = TTImageUploadActionTypeNoProcess;
        }
        else if(netWorkControll.selectedSegmentIndex == 1){
            _isImageX = YES;
            _processType = TTImageUploadActionTypeEncrypt;
        }else if(netWorkControll.selectedSegmentIndex == 2){
            _isImageX = NO;
            _processTypeVideo = TTVideoUploadActionTypeEncrypt;
        }
        _authParameter = nil;
        [self initUploader];
        [self requestSign];
        
    }];
    [containView addSubview:netWorkControll];
    
}

- (void)initButtons{
    
    UIView* containView = [[UIView alloc] initWithFrame:CGRectMake(0, _segmentContainView.bottom + 20, WIDTH, 120)];
//    containView.backgroundColor = [UIColor grayColor];
    _buttonsContainView = containView;
    [self.view addSubview:containView];
    NSArray * imageButtons = [self imageButtonDescription];
    [imageButtons enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = CGRectMake(20+(BUTTONWIDTH+40)*idx, 20, BUTTONWIDTH, BUTTONHEIGHT);
        NSString* title = obj[@"title"];
        UIBlockButton* button = [UIBlockButton buttonFrame:frame titile:title action:obj[@"handleBlock"]];
        [containView addSubview:button];
    }];
    NSArray * videoButtons = [self videoButtonDescription];
    [videoButtons enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = CGRectMake(20+(BUTTONWIDTH+40)*idx, BUTTONHEIGHT + 40, BUTTONWIDTH, BUTTONHEIGHT);
        NSString* title = obj[@"title"];
        UIBlockButton* button = [UIBlockButton buttonFrame:frame titile:title action:obj[@"handleBlock"]];
        [containView addSubview:button];
    }];
}
- (void)initsetImages{
    UIView* containView = [[UIView alloc] initWithFrame:CGRectMake(0, _buttonsContainView.bottom + 20, WIDTH, HEIGHT-_buttonsContainView.bottom - 20)];
//    containView.backgroundColor = [UIColor grayColor];
    _fileButtonContainView = containView;
    [self.view addSubview:containView];
    UIBlockButton* selectImage = [UIBlockButton buttonFrame:CGRectMake(10, 10, BUTTONWIDTH, BUTTONHEIGHT) titile:@"选择图片" action:^{
        _pickType = AlbumPickTypePhoto;
        [self buttonAction];
    }];
    [containView addSubview:selectImage];
    UIBlockButton* selectVideos = [UIBlockButton buttonFrame:CGRectMake(selectImage.right +10, 10, BUTTONWIDTH, BUTTONHEIGHT) titile:@"选择视频" action:^{
        _pickType = AlbumPickTypeVideo;
        [self buttonAction];
    }];
//    [self setupCollectionView:selectVideos];
    [containView addSubview:selectVideos];
    
    self.progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, 100, 40)];
    [self.view addSubview:self.progressLabel];
    
}

#pragma -mark initUploader
- (void)initUploader{
    [self initImageUploader];
    [self initVideoUploader];
    [self requestSign];
}
- (void)initImageUploader{
    if (_pickType != AlbumPickTypePhoto) {
        return;
    }
    if (!_filePathArray || _filePathArray.count == 0) {
        [self setupfilePaths];
        [self.collectionView reloadData];
    }
    self.imageUploadClientTop = [TTFileUploadDemoUtil imageUploadClientTop:_filePathArray delegate:self authParameter:self.authParameter isImageX:_isImageX];
    //[[TTVideoUploadEventManager sharedManager] popAllEvents];
    
}
- (void)initVideoUploader{
//    if (_pickType != AlbumPickTypeVideo || _filePathArray.count <= 0) {
//        NSLog(@"所选不为视频，或者没有选取视频数量为0！！！");
//        return;
//    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
    self.videoUploadClientTop = [TTFileUploadDemoUtil videoUploadClientTop:path delegate:self authParameter:[self authorizationParameter]];
    
    [self.videoUploadClientTop setAuthorizationParameter:[self authorizationParameter]];
    //[[TTVideoUploadEventManager sharedManager] popAllEvents];
    
}

#pragma mark -
#pragma mark TTVideoUploadClientProtocol
- (void)uploadDidFinish:(TTUploadImageInfoTop *)imageInfo error:(NSError *)error {
    if ([imageInfo isKindOfClass:[TTUploadImageInfoTop class]]) {
        if (imageInfo.fileIndex == -1) {
            NSLog(@"++++++++++++++++++++++++++++");
            NSLog(@"fileIndex = %ld",(long)imageInfo.fileIndex);
            NSLog(@"++++++++++++++++++++++++++++");
        }
        NSLog(@"fileIndex = %ld",(long)imageInfo.fileIndex);
    }
    if (!error) {
        self.finishTime = [[NSDate date] timeIntervalSince1970];
        NSString *message = [NSString stringWithFormat:@"总耗时%.2fs, 平均速率%.2fMB per second",(self.finishTime - self.startTime), 20.9/(self.finishTime - self.startTime)];
        [self alertView:imageInfo message:message title:@"上传成功"];
       
    }
    else {
        [self alertViewController:@"上传失败" title:@"上传失败"];
        NSLog(@"error = %@",error);
    }
    //NSLog(@"埋点日志:%@",)
    //NSLog(@"event log is :%@",[[TTVideoUploadEventManager sharedManager] popAllEvents]);
    NSString *did;
    if(_videoUploadClientTop != nil){
        did = [_videoUploadClientTop getDeviceID];
    }
    if(did.length <= 0){
        NSLog(@"deviceID:%d",0);
    }
    else{
        NSLog(@"deviceID:%@",did);
    }
}

- (void)uploadProgressDidUpdate:(NSInteger)progress fileIndex:(NSInteger) fileIndex; {
    self.progressLabel.text = [NSString stringWithFormat:@"文件:%d 上传进度:%d%@",(int) fileIndex,(int)progress,@"%"];
    NSLog(@"图片进度:%ld",(long)progress);
}

- (void)uploadProgressDidUpdate:(NSInteger)progress{
    _i += 15;
    UILabel* progressLabel_imp = [[UILabel alloc]initWithFrame:CGRectMake(20, 110+_i, 100, 40)];
    [self.view addSubview:progressLabel_imp];
//    self.progressLabel.text = @"asssss";
    //_progressLabel.text = @"";
    //progressLabel_imp.text = [NSString stringWithFormat:@"进度:%d",(int)progress];
    NSLog(@"视频进度:%ld",(long)progress);
}

#pragma -mark collectionDelegate
- (void)eventManagerDidUpdate:(TTVideoUploadEventManager *)eventManager{
    NSLog(@"++++++++++++++++++++++++++++");
//    NSLog(@"event log is :%@",[[TTVideoUploadEventManager sharedManager] popAllEvents]);
    NSArray* logArrary = [[TTVideoUploadEventManager sharedManager] popAllEvents];
    for (NSDictionary* log in logArrary) {
        
        NSString* string = [TTFileUploadDemoUtil dictionaryToJson:log];
        for (NSString *line in [string componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]])
        {
            NSLog(@"++++++++++++:%@", line);
        }
    }
    NSLog(@"++++++++++++++++++++++++++++");
}

@end

