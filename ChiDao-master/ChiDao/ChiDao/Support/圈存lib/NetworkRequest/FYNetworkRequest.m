//
//  FYNetworkRequest.m
//  NetworkRequestDemo
//
//  Created by 李友富 on 16/1/7.
//  Copyright © 2016年 李友富. All rights reserved.
//

#import "FYNetworkRequest.h"
#import "YYCache.h"
#import "NSJSONSerialization+FYJson.h"
#import "NSString+YFContainsString.h"
#import "NSObject+MJKeyValue.h"
// 获取运营商类型
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "HisuntechAFNetworkReachabilityManager.h"
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#define kManYiXingUrl @"http://my56.com" // 满易行官网
#pragma mark - <<<<<<<<<<<<<<< 所有接口 >>>>>>>>>>>>>>>

//#define kXlpayUrl @"http://xlpay.wicp.net/sdhwmcfe"
//#define kXlpayUrl @"http://123.129.210.52:8080/sdhwmcfe"  //测试环境

#define kXlpayUrl @"http://123.129.210.53:8081/sdhwmcfe"  //本地测试环境

//#define kXlpayUrl @"http://xlpay.wicp.net/sdhwmcfe"  //本地测试环境
//xlpay.wicp.net/sdhwmcfe
//#define kXlpayUrl @"http://123.129.210.53:8081/sdhwmcfe" //正式环境

/**ETC**/

#define kETCUrl @"http://vpcserver.my56app.com"

/** 满易行 **/
// 测试环境  http://123.56.4.22:7070/baseWeb    （玉峰）http://10.186.116.233:8080/baseWeb
// 正式环境  https://app.my56app.com/baseWeb


//#define kBaseUrl @"http://123.56.4.22:7070" // Base url
//#define kBaseUrl @"http://vpcserver.my56app.com"
#define kBaseUrl @"http://app.my56app.com"
#define kBaseUrl1 @"/baseWeb" // AFN会截取“/”，所以分开写


/** 大、小车违章查询,路况,高速通行费及邮费估算 **/
// 测试环境(暂时不用)  http://123.56.4.22:7178
// 正式环境(暂时不用)  https://app.my56app.com:5443
// 测试环境2 http://123.56.4.22:7070
// 正式环境2  http://app.my56app.com

#define kViolationQueryUrl @"http://app.my56app.com" // 违章业务

#define kViolationQueryUrl1 @"/app/violation"// 大、小车违章查询
#define kRoadConditionUrl @"/app/roadcondition"// 路况
#define kTollsQueryUrl @"/app/highwaytoll" // 高速通行费及邮费估算


/** 满易运 **/
// 测试环境  http://101.200.145.221:7090/manyiyun
// 正是环境  暂无
#define kManyiyunBaseUrl @"http://101.200.145.221:7090" // Base url
#define kManyiyunBaseUrl1 @"/manyiyun" // AFN会截取“/”，所以分开写

typedef NS_ENUM(NSInteger, NetworkType) {
    NONE,
    NETWORKTYPE_WIFI,
    NETWORKTYPE_2G,
    NETWORKTYPE_3G,
    NETWORKTYPE_4G
};

typedef NS_ENUM(NSUInteger, FYNetworkRequestType) {
    FYNetworkRequestTypeGET = 0,
    FYNetworkRequestTypePOST,
};

static NSString * const FYNetworkRequestCache = @"FYNetworkRequestCache";

@interface FYNetworkRequest()
@property (nonatomic, copy) NSString *urlStr;
@end

@implementation FYNetworkRequest

#pragma mark - public
+ (void)getWithSubUrl:(NSString *)subUrlString
           parameters:(id)parameters
               sucess:(SucessBlock)sucess
              failure:(FailureBlock)failure {
    [self requestMethod:FYNetworkRequestTypeGET subUrlString:subUrlString parameters:parameters cachePolicy:FYNetworkRequestReloadIgnoringLocalCacheData success:sucess failure:failure];
}

+ (void)getWithSubUrl:(NSString *)subUrlString
           parameters:(id)parameters
          cachePolicy:(FYNetworkRequestCachePolicy)requestCachePolicy
               sucess:(SucessBlock)sucess
              failure:(FailureBlock)failure {
    [self requestMethod:FYNetworkRequestTypeGET subUrlString:subUrlString parameters:parameters cachePolicy:requestCachePolicy success:sucess failure:failure];
}

+ (void)postWithSubUrl:(NSString *)subUrlString
            parameters:(id)parameters
                sucess:(SucessBlock)sucess
               failure:(FailureBlock)failure {
    
    [self requestMethod:FYNetworkRequestTypePOST subUrlString:subUrlString parameters:parameters cachePolicy:FYNetworkRequestReloadIgnoringLocalCacheData success:sucess failure:failure];
}

+ (void)postWithSubUrl:(NSString *)subUrlString
            parameters:(id)parameters
           cachePolicy:(FYNetworkRequestCachePolicy)requestCachePolicy
                sucess:(SucessBlock)sucess
               failure:(FailureBlock)failure {
    [self requestMethod:FYNetworkRequestTypePOST subUrlString:subUrlString parameters:parameters cachePolicy:requestCachePolicy success:sucess failure:failure];
}

+ (void)postWithSubUrl:(NSString *)subUrl
            parameters:(id)parameters
            imageDatas:(NSArray *)imageDatas
            imageNames:(NSArray *)imageNames
             videoData:(NSData *)videoData
                sucess:(SucessBlock)sucess
                failed:(FailureBlock)failure {

    
    NSLog(@"上传图片的完整url = %@", [FYNetworkRequest sharedInstance].urlStr);
    
    [FYNetworkRequest sharedInstance].responseSerializer = [AFCompoundResponseSerializer serializer];
    [FYNetworkRequest sharedInstance].responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/plain", nil];
    
    [[FYNetworkRequest sharedInstance] POST:[FYNetworkRequest sharedInstance].urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i = 0; i < imageDatas.count; i++) {
            //            NSLog(@"--- %@", [imageDatas[i] class]);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            
            [formData appendPartWithFileData:[imageDatas objectAtIndex:i]
                                        name:[imageNames objectAtIndex:i]
                                    fileName:fileName
                                    mimeType:@"image/png"];
        }
        
        if (videoData) {
            [formData appendPartWithFileData:videoData
                                        name:@"video"
                                    fileName:[NSString stringWithFormat:@"%@.mp4",@"video"]
                                    mimeType:@"video/mp4"];
            
        }

    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (sucess) {
            sucess(task, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(task, error);
        }
        
    }];
    

}

#pragma mark - private
+ (void)requestMethod:(FYNetworkRequestType)type
         subUrlString:(NSString *)subUrlString parameters:(id)parameters
          cachePolicy:(FYNetworkRequestCachePolicy)cachePolicy
              success:(SucessBlock)success
              failure:(FailureBlock)failure {
    
   [FYNetworkRequest sharedInstance].urlStr = [kXlpayUrl stringByAppendingString:subUrlString];
    
    NSString *cacheKey = subUrlString;
    if (parameters) {
        if (! [NSJSONSerialization isValidJSONObject:parameters]) return;//参数不是json类型
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        NSString *paramStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        cacheKey = [subUrlString stringByAppendingString:paramStr];
    }
    
    YYCache *cache = [[YYCache alloc] initWithName:FYNetworkRequestCache];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    
    id object = [cache objectForKey:cacheKey];
    
    switch (cachePolicy) {
        case FYNetworkRequestReturnCacheDataThenLoad : { // 先返回缓存，同时请求
            if (object) {
                success(nil,object);
            }
            break;
        }
        case FYNetworkRequestReloadIgnoringLocalCacheData : { // 忽略本地缓存直接请求
            // 不做处理，直接请求
            break;
        }
        case FYNetworkRequestReturnCacheDataElseLoad : { // 有缓存就返回缓存，没有就请求
            if (object) { // 有缓存
                success(nil,object);
                return;
            }
            break;
        }
        case FYNetworkRequestReturnCacheDataDontLoad : { // 有缓存就返回缓存,从不请求（用于没有网络）
            if (object) { // 有缓存
                success(nil,object);
            }
            return; // 退出从不请求
        }
        default: {
            break;
        }
    }
    [self requestMethod:type subUrlString:[FYNetworkRequest sharedInstance].urlStr parameters:parameters cache:cache cacheKey:cacheKey success:success failure:failure];
}

+ (void)requestMethod:(FYNetworkRequestType)type
            subUrlString:(NSString *)subUrlString
           parameters:(id)parameters
                cache:(YYCache *)cache
             cacheKey:(NSString *)cacheKey
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    // 检查联网
    /**
     *  AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     *  AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     *  AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G
     *  AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络Wifi
     */
    // 如果要检测网络状态的变化, 必须要用检测管理器的单例startMoitoring
    [[HisuntechAFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[HisuntechAFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable) { // 没有网
            [self returnNetworkStatus:@"0"];
            failure(nil, nil);
            return ;
        }
        else { // 有网
            [self returnNetworkStatus:@"1"];

            // 给请求头新增网络类型
            [self addNetworkTypeToHttpHeaderFile:status];
            // 开始网络请求
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            switch (type) {
                case FYNetworkRequestTypeGET : {
                    
                    [[FYNetworkRequest sharedInstance] GET:subUrlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                        
                        if ([responseObject isKindOfClass:[NSData class]]) {
                            responseObject = [NSJSONSerialization objectWithJSONData:responseObject];
                        }
                        // 网络请求成功
                        [cache setObject:responseObject forKey:cacheKey]; // YYCache 已经做了responseObject为空处理
                        success(task, responseObject);
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {

                        NSLog(@"network error = %@", error);
                        
                        //                        return;
                        failure(task, error);
                        
                    }];
                    
//                    [[FYNetworkRequest sharedInstance] GET:subUrlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                        if ([responseObject isKindOfClass:[NSData class]]) {
//                            responseObject = [NSJSONSerialization objectWithJSONData:responseObject];
//                        }
//                        // 网络请求成功
//                        [cache setObject:responseObject forKey:cacheKey]; // YYCache 已经做了responseObject为空处理
//                        success(task, responseObject);
//                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                        [[MYBaseViewController new] hideStatusView];
//                        [[MYBaseViewController new] showTipWithContent:kNetworkError];
//                        NSLog(@"network error = %@", error);
//
////                        return;
//                        failure(task, error);
//                    }];
                    break;
                }
                case FYNetworkRequestTypePOST : {
                    
                    [[FYNetworkRequest sharedInstance] POST:subUrlString parameters:parameters  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                            NSError *error;
                            if ([responseObject isKindOfClass:[NSData class]]) {
                                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                            }
                        
                        // 网络请求成功
                        [cache setObject:responseObject forKey:cacheKey]; // YYCache 已经做了responseObject为空处理
                        success(task,responseObject);
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                        NSLog(@"network error = %@", error);
//                        NSString *dataStr = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
//                        NSLog(@"dataStr = %@", dataStr);
                        
//                        return;
                        failure(task, error);
                    }];
                    break;
                }
                default:
                    break;
            }
        }
    }];
}

+ (instancetype)sharedInstance {
    static FYNetworkRequest *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [FYNetworkRequest client];
        
        // 满易
        manager.requestSerializer = [HisuntechAFJSONRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = 30.0f;
        [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];

        manager.responseSerializer = [AFCompoundResponseSerializer serializer]; // 01181713
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/plain", @"application/x-json", nil];
        
        [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Proxy-Connection"];
        
//        // 证书验证问题处理
//        [manager setSecurityPolicy:[self customSecurityPolicy]];

    });
    return manager;
}

+ (HisuntechAFSecurityPolicy*)customSecurityPolicy {
    // 先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"cer" ofType:@"cer"];// 证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        
    // AFSSLPinningModeCertificate 使用证书验证模式
    HisuntechAFSecurityPolicy *securityPolicy = [HisuntechAFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    // validatesDomainName 是否需要验证域名，默认为YES；
    // 假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    // 置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    // 如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData, nil];

    return securityPolicy;
}

+ (instancetype)client {
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    return [[FYNetworkRequest alloc] initWithBaseURL:[NSURL URLWithString:BASEURLSTRING] sessionConfiguration:configuration];
    return [[FYNetworkRequest alloc] init];
}

+ (void)checkNetworkStatusResult:(void (^)(id result))result {
    /**
     *  AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     *  AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     *  AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G
     *  AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络Wifi
     */
    // 如果要检测网络状态的变化, 必须要用检测管理器的单例startMoitoring
    
    [[HisuntechAFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[HisuntechAFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable){
            NSLog(@"网络连接已断开，请检查您的网络！");
            result(@"-1");
            return ;
        }
    }];
}

+ (void)returnNetworkStatus:(NSString *)result {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"networkerror" object:nil userInfo:@{@"result" : result }];
}

/// URLString 应该是全url 上传单个文件
+ (NSURLSessionUploadTask *)upload:(NSString *)URLString filePath:(NSString *)filePath parameters:(id)parameters{
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSURLSessionUploadTask *uploadTask = [[FYNetworkRequest client] uploadTaskWithRequest:request fromFile:fileUrl progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
    return uploadTask;
}

#pragma mark - <<<<<<<<<<<<<<< 新的上传图片（暂时用这个） >>>>>>>>>>>>>>>
+ (void)uploadImagesWithSubUrl:(NSString *)url params:(NSDictionary *)params imagesArray:(NSArray *)imagesArray withCompressionQuality:(CGFloat)compressionQuality sucess:(SucessBlock)sucess failed:(FailureBlock)failure {
    //检查参数是否正确
    if (! url|| ! imagesArray) {
        NSLog(@"参数不完整");
        return;
    }
    
    url = [[kBaseUrl stringByAppendingString:kBaseUrl1] stringByAppendingString:url];
    
    NSLog(@"%@", url);
    
    //初始化
    NSString *hyphens = @"--";
    NSString *boundary = @"liyoufu";
    NSString *end = @"\r\n";
    //初始化数据
    NSMutableData *myRequestData1 = [NSMutableData data];
    //参数的集合的所有key的集合
    NSArray *keys = [params allKeys];
    
    //添加其他参数
    for(int i = 0;i < [keys count]; i ++) {
        NSMutableString *body = [[NSMutableString alloc]init];
        [body appendString:hyphens];
        [body appendString:boundary];
        [body appendString:end];
        //得到当前key
        NSString *key = [keys objectAtIndex:i];
        //添加字段名称
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"%@%@",key,end,end];
        
        //添加字段的值
        [body appendFormat:@"%@",[params objectForKey:key]];
        [body appendString:end];
        [myRequestData1 appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
//        NSLog(@"添加字段的值 = %@",[params objectForKey:key]);
    }
    
    //添加图片资源
    for (int i = 0; i < imagesArray.count; i++) {
        if (! [imagesArray[i] isKindOfClass:[UIImage class]]) {
            return;
        }
        //获取资源
        UIImage *image = imagesArray[i];
        //得到图片的data
        NSData* data = UIImageJPEGRepresentation(image,compressionQuality);
        //所有字段的拼接都不能缺少，要保证格式正确
        [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableString *fileTitle=[[NSMutableString alloc]init];
        //要上传的文件名和key，服务器端接收
        [fileTitle appendFormat:@"Content-Disposition:form-data;name=\"file\";filename=\"file%u.png\"",i];
        [fileTitle appendString:end];
        [fileTitle appendString:[NSString stringWithFormat:@"Content-Type:application/octet-stream%@",end]];
        [fileTitle appendString:end];
        [myRequestData1 appendData:[fileTitle dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:data];
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSLog(@"i = %d", i);
    }
    
    //拼接结束~~~
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",boundary];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData1 length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData1];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"token"] forHTTPHeaderField:@"token"];
    [request setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"loginName"] forHTTPHeaderField:@"loginName"];
    [request setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"mac"] forHTTPHeaderField:@"mac"];
    [request setValue:@"iPhone" forHTTPHeaderField:@"deviceType"];

#warning 替换了这里
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    
    //回调返回值
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError) {
            failure(nil, connectionError);
        }
        else {
            NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            sucess(nil, [dataStr mj_JSONObject]);
        }
    }];
    
}

#pragma mark - 跟请求头新增网络类型（2、3、4G，WiFi）
+ (void)addNetworkTypeToHttpHeaderFile:(NSInteger)status {
    
    switch (status) {
        case AFNetworkReachabilityStatusUnknown: // -1
        {
            [self getNetworkTypeUseSystemMethod];
        }
            break;
        case AFNetworkReachabilityStatusNotReachable: // 0
        {
            [self getNetworkTypeUseSystemMethod];
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN: // 1
        {
            [self getNetworkTypeUseSystemMethod];
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi: // 2
        {
            [[FYNetworkRequest sharedInstance].requestSerializer setValue:[NSString stringWithFormat:@"%ld", NETWORKTYPE_WIFI] forHTTPHeaderField:@"networkType"];
        }
            break;
        default:
            break;
    }
    
//    NSLog(@"networkType = %@", [[FYNetworkRequest sharedInstance].requestSerializer valueForHTTPHeaderField:@"networkType"]);
    
}

+ (void)getNetworkTypeUseSystemMethod {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *mConnectType = [[NSString alloc] initWithFormat:@"%@",info.currentRadioAccessTechnology];
    NSInteger netWorkType = -1;
    if ([mConnectType isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
        netWorkType = NETWORKTYPE_2G;
    }
    else if ([mConnectType isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
        netWorkType = NETWORKTYPE_2G;
    }
    else if ([mConnectType isEqualToString:@"CTRadioAccessTechnologyeHRPD"]) {
        netWorkType = NETWORKTYPE_3G;
    }
    else if ([mConnectType isEqualToString:@"CTRadioAccessTechnologyHSDPA"]) {
        netWorkType = NETWORKTYPE_3G;
    }
    else if ([mConnectType isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]) {
        netWorkType = NETWORKTYPE_2G;
    }
    else if ([mConnectType isEqualToString:@"CTRadioAccessTechnologyLTE"]) {
        netWorkType = NETWORKTYPE_4G;
    }
    else if ([mConnectType isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]) {
        netWorkType = NETWORKTYPE_3G;
    }
    else if ([mConnectType isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]) {
        netWorkType = NETWORKTYPE_3G;
    }
    else if ([mConnectType isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]) {
        netWorkType = NETWORKTYPE_3G;
    }
    else if ([mConnectType isEqualToString:@"CTRadioAccessTechnologyHSUPA"]) {
        netWorkType = NETWORKTYPE_3G;
    }
    else {
        
    }
    
    [[FYNetworkRequest sharedInstance].requestSerializer setValue:[NSString stringWithFormat:@"%ld", netWorkType] forHTTPHeaderField:@"networkType"];
}


@end
