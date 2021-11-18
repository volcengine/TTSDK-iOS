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

@interface uploadController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIButton *uploadButton;
@property (nonatomic, weak) IBOutlet UILabel *progressLabel;
@property (nonatomic, strong) TTVideoUploadClientTop *videoUploadClientTop;
@property (nonatomic, strong) TTImageUploadClientTop *imageUploadClientTop;
@property (nonatomic, strong) TTMateUploadClientTop *mateUploadClientTop;
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
@property (nonatomic, strong) UIView* segmentContainViewMate;
@property (nonatomic, strong) UIView* buttonsContainView;
@property (nonatomic, strong) UIView* fileButtonContainView;
@property (nonatomic, strong) UITextField* textfiled;
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
@property (nonatomic, strong) NSTimer* timer;

@property (nonatomic, copy) NSString *sessionToken;
@property (nonatomic, copy) NSString *accessKey;
@property (nonatomic, copy) NSString *secretKey;
@property (nonatomic, strong) NSDate *expirationTime;
@property (nonatomic, copy) NSString *regionName;
@property (nonatomic, copy) NSString* mateFilePath;
@property (nonatomic, copy) NSString* mateFileType;
@property (nonatomic, copy) NSString* mateCategory;
@property (nonatomic, copy) NSString* mAKSKJsonStr;
@property (nonatomic, copy) NSString* spaceName;

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
        _mateFilePath = [[NSBundle mainBundle] pathForResource:@"test33" ofType:@"JPG"];
        _mateFileType = @"image";
        _mateCategory = @"image";
        self.view.backgroundColor = [UIColor whiteColor];
        _pickType = AlbumPickTypePhoto;
        _resultArray = [NSMutableArray arrayWithCapacity:10];
        _fileArray = [NSMutableArray arrayWithCapacity:10];
        _assets = [NSMutableArray arrayWithCapacity:1000];
        _processType = 0;
        [TTVideoUploadEventManager sharedManager].delegate = self;
        

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

- (NSArray *)mateButtonDescription
{
    __weak typeof(self) weakSelf = self;
    return @[
             @{@"title": @"MateStart",
               @"handleBlock": ^{
                   __strong typeof(weakSelf) self = weakSelf;
                    if (self.mateUploadClientTop == nil) {
                        [self alertViewController:@"请重新选择素材！！！" title:@"错误"];
                    }
                    self.startTime = [[NSDate date] timeIntervalSince1970];
                    [self.mateUploadClientTop start];
                   }
               },
             @{@"title": @"MateStop",
               @"handleBlock": ^{
                   __strong typeof(weakSelf) self = weakSelf;
                   [self.mateUploadClientTop stop];
               }
               },
             @{@"title": @"MateClose",
               @"handleBlock": ^{
                [self.mateUploadClientTop stop];
                 self.mateUploadClientTop = nil;
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
    NSString* filePath1 = [[NSBundle mainBundle] pathForResource:@"test1" ofType:@"png"];
    if(filePath1 != nil){
        _filePathArray = @[filePath1,filePath1,filePath1];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _mAKSKJsonStr = textField.text;
    [self requestSign];
    NSLog(@"AKSKJsonStr:%@",_mAKSKJsonStr);
}

- (void)initUI{
    [self initSegmaent];
    [self initMateSegment];
    [self initAKSKText];
    [self initButtons];
    [self initsetImages];
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _loadingView.backgroundColor = [UIColor grayColor];
    _loadingView.frame = CGRectMake(0, 0, 50, 50);
    _loadingView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    _loadingView.hidesWhenStopped = YES;
    [self.view addSubview:_loadingView];
}

- (void)buttonAction{
    [_resultArray removeAllObjects];
    [_fileArray removeAllObjects];
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
    if (self.mAKSKJsonStr) {
        NSDictionary* result;
        NSData* jsonData = [self.mAKSKJsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;

        result = [NSJSONSerialization JSONObjectWithData:jsonData
                                                 options:NSJSONReadingMutableContainers
                                                   error:&err];


        if (result) {
            self.accessKey = result[@"AccessKeyID"];
            self.secretKey = result[@"SecretAccessKey"];
            self.sessionToken = result[@"SessionToken"];
            self.expirationTime = result[@"ExpiredTime"];
            self.spaceName = result[@"SpaceName"];
            [self.videoUploadClientTop setAuthorizationParameter:[self authorizationParameter]];
            [self.imageUploadClientTop setAuthorizationParameter:[self authorizationParameter]];
            [self.mateUploadClientTop setAuthorizationParameter:[self authorizationParameter]];
            [self.videoUploadClientTop setRequestParameter:[self requestParameter]];
            [self.imageUploadClientTop setRequestParameter:[self requestParameter]];
            [self.mateUploadClientTop setRequestParameter:[self requestParameter]];
        }
    }
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
- (NSDictionary *)requestParameter {
    return @{TTFileUploadSpace:self.spaceName?:@""};
}

#pragma -mark UI
- (void)initSegmaent{
    UIView* containView = [[UIView alloc] initWithFrame:CGRectMake(0, 48, WIDTH, 60)];
//    containView.backgroundColor = [UIColor yellowColor];
    _segmentContainView = containView;
    [self.view addSubview:containView];
    NSInteger tag = 101;
    NSArray *netArray = @[@"imageX",@"imageXIM",@"VideoAPI2.0",@"Material"];
    CGRect netFrame = CGRectMake(10,  40, WIDTH, 40);
    UIBlockSegmentedControl* netWorkControll = [UIBlockSegmentedControl initSegMentFrame:netFrame item:netArray tag:++tag];
    [netWorkControll addActionBlock:^{
        if (netWorkControll.selectedSegmentIndex == 0) {
            self.isImageX = YES;
            self.processType = TTImageUploadActionTypeNoProcess;
        }
        else if(netWorkControll.selectedSegmentIndex == 1){
            self.isImageX = YES;
            self.processType = TTImageUploadActionTypeEncrypt;
        }else if(netWorkControll.selectedSegmentIndex == 2){
            self.isImageX = NO;
            self.processTypeVideo = TTVideoUploadActionTypeEncrypt;
        }else if(netWorkControll.selectedSegmentIndex == 3){
            self.isImageX = NO;
        }
        [self initUploader];
        [self requestSign];
        
    }];
    [containView addSubview:netWorkControll];
    
}

- (void)initMateSegment{
    UIView* containViewMate = [[UIView alloc] initWithFrame:CGRectMake(0, _segmentContainView.bottom + 20, WIDTH, 60)];
    //UIView* containViewMate = [[UIView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, 60)];
    _segmentContainViewMate = containViewMate;
    [self.view addSubview:containViewMate];
    NSInteger tagMate = 202;
    NSArray *netArrayMate = @[@"image",@"video",@"object"];
    CGRect netFrameMate = CGRectMake(10,  40, WIDTH, 40);
    
    UIBlockSegmentedControl* netWorkControllMate = [UIBlockSegmentedControl initSegMentFrame:netFrameMate item:netArrayMate tag:++tagMate];
    [netWorkControllMate addActionBlock:^{
        if (netWorkControllMate.selectedSegmentIndex == 0) {
            self.mateFilePath = [[NSBundle mainBundle] pathForResource:@"test33" ofType:@"JPG"];
            self.mateFileType = @"image";
            self.mateCategory = @"image";
        }
        else if(netWorkControllMate.selectedSegmentIndex == 1){
            self.mateFilePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
            self.mateFileType = @"media";
            self.mateCategory = @"video";
        }else if(netWorkControllMate.selectedSegmentIndex == 2){
            self.mateFilePath = [[NSBundle mainBundle] pathForResource:@"test44" ofType:@"ttf"];
            self.mateFileType = @"object";
            self.mateCategory = @"font";
        }
    }];
    [containViewMate addSubview:netWorkControllMate];
}

- (void)initAKSKText{
    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(0, _segmentContainViewMate.bottom + 30, WIDTH, 100)];
    text.borderStyle = UITextBorderStyleRoundedRect;
    text.placeholder = @"AccessKey SecretKey .. JsonStr";
    text.font = [UIFont fontWithName:@"Arial" size:15.0f];
    text.textColor = [UIColor redColor];
    text.clearsOnBeginEditing = YES;

    _textfiled = text;
    _textfiled.delegate = self;
    [self.view addSubview:text];
}

- (void)initButtons{
    
    UIView* containView = [[UIView alloc] initWithFrame:CGRectMake(0, _textfiled.bottom + 30, WIDTH, 170)];
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
    NSArray * mateButtons = [self mateButtonDescription];
    [mateButtons enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = CGRectMake(20+(BUTTONWIDTH+40)*idx, BUTTONHEIGHT + 90, BUTTONWIDTH, BUTTONHEIGHT);
        NSString* title = obj[@"title"];
        UIBlockButton* button = [UIBlockButton buttonFrame:frame titile:title action:obj[@"handleBlock"]];
        [containView addSubview:button];
    }];
}
- (void)initsetImages{
    UIView* containView = [[UIView alloc] initWithFrame:CGRectMake(0, _buttonsContainView.bottom + 80, WIDTH, HEIGHT-_buttonsContainView.bottom - 20)];
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
    [TTVideoUploadClientTop enableDebug:1];
    [self initImageUploader];
    [self initVideoUploader];
    [self initMateUploader];
    //[self requestSign];
}
- (void)initImageUploader{
    if (_pickType != AlbumPickTypePhoto) {
        return;
    }
    if (!_filePathArray || _filePathArray.count == 0) {
        [self setupfilePaths];
        [self.collectionView reloadData];
    }
    self.imageUploadClientTop = [TTFileUploadDemoUtil imageUploadClientTop:_filePathArray delegate:self authParameter:nil processAction:_processType];
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

- (void)initMateUploader{
    if (_mateFilePath == nil || _mateFileType == nil || _mateCategory == nil) {
        [self alertViewController:@"请先选择素材类型！！！！" title:@"提示"];
    }
    self.mateUploadClientTop = [TTFileUploadDemoUtil mateUploadClientTop:_mateFilePath delegate:self authParameter:[self authorizationParameter] fileType:_mateFileType category:_mateCategory];
    [self.mateUploadClientTop setAuthorizationParameter:[self authorizationParameter]];
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
    [self requestSign];
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

