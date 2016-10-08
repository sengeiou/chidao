//
//  FYNetworkRequest.h
//  NetworkRequestDemo
//

//


#import "HisuntechAFNetworking.h"
#import "HisuntechAFHTTPSessionManager.h"

#define BASEURLSTRING kBaseUrl

typedef NS_ENUM(NSUInteger, FYNetworkRequestCachePolicy) {
    FYNetworkRequestReturnCacheDataThenLoad = 0, // 有缓存就先返回缓存，同步请求数据
    FYNetworkRequestReloadIgnoringLocalCacheData, // 忽略缓存，重新请求
    FYNetworkRequestReturnCacheDataElseLoad, // 有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
    FYNetworkRequestReturnCacheDataDontLoad // 有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
};

typedef void(^SucessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void(^FailureBlock)(NSURLSessionDataTask *task, NSError *error);

typedef void(^ResultBlock)(NSString *result);

@interface FYNetworkRequest : HisuntechAFHTTPSessionManager

// 生成单例
+ (instancetype)sharedInstance;

// 检查网络
+ (void)checkNetworkStatusResult:(void (^)(id result))result;

// GET请求（无缓存）
+ (void)getWithSubUrl:(NSString *)subUrlString
           parameters:(id)parameters
               sucess:(SucessBlock)sucess
              failure:(FailureBlock)failure;

// GET请求（有缓存）
+ (void)getWithSubUrl:(NSString *)subUrlString
           parameters:(id)parameters
          cachePolicy:(FYNetworkRequestCachePolicy)requestCachePolicy
               sucess:(SucessBlock)sucess
              failure:(FailureBlock)failure;

// POST请求（无缓存）
+ (void)postWithSubUrl:(NSString *)subUrlString
            parameters:(id)parameters
                sucess:(SucessBlock)sucess
               failure:(FailureBlock)failure;

// POST请求（有缓存）
+ (void)postWithSubUrl:(NSString *)subUrlString
            parameters:(id)parameters
           cachePolicy:(FYNetworkRequestCachePolicy)requestCachePolicy
                sucess:(SucessBlock)sucess
               failure:(FailureBlock)failure;

// 上传图片/视频（暂时不用）
+ (void)postWithSubUrl:(NSString *)subUrl
            parameters:(id)parameters
            imageDatas:(NSArray *)imageDatas
            imageNames:(NSArray *)imageNames
             videoData:(NSData *)videoData
                sucess:(SucessBlock)sucess
                failed:(FailureBlock)failure;

/**
 *  @author Lee Yofu
 *
 *  新的上传图片（暂时用这个）
 *
 *  @param url                子 url
 *  @param params             参数字典
 *  @param imagesArray        盛放 UIImage 类的数组
 *  @param compressionQuality 压缩比例
 *  @param resultBlock        上传结果，1为成功，0为失败
 */
+ (void)uploadImagesWithSubUrl:(NSString *)url params:(NSDictionary *)params imagesArray:(NSArray *)imagesArray withCompressionQuality:(CGFloat)compressionQuality sucess:(SucessBlock)sucess failed:(FailureBlock)failure;;


@end
