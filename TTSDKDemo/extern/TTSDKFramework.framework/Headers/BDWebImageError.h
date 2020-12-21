//
//  BDWebImageError.h
//  BDWebImage
//
//

#import <Foundation/Foundation.h>
extern NSString *const BDWebImageErrorDomain;

typedef NS_ENUM(NSInteger, BDWebImageError)
{
    BDWebImageCancelled     = NSURLErrorCancelled,  //用户主动取消 -999
    BDWebImageBadImageURL   = NSURLErrorBadURL,     //URL错误导致初始化请求失败 -1000
    BDWebImageBadImageData  = 900001,               //返回数据不能解析
    BDWebImageEmptyImage    = 900002,               //解析完成图片为空像素
    BDWebImageInternalError = 900003,               //内部逻辑错误
    BDWebImageOverFlowExpectedSize = 900004,   //当开启渐进式下载，而且接收到的数据大于kHTTPResponseContentLength时报错
    BDWebImageAwebpInvalid  = 900005,               //awebp格式校验错误
    BDWebImageAwebpConvertToGIfDataError = 900006,  //webp动图转gif二进制错误
    BDWebImageCheckTypeError = 900007,               //图片下载检查类型错误
    BDWebImageCheckDataLength = 900008,               //图片下载检查 data 长度
};


