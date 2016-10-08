//
//  Tool.m
//  ChiDao
//
//  Created by 赵洋 on 16/5/24.
//  Copyright (c) 2016年 赵洋. All rights reserved.
//

#import "Tool.h"
#import "AppDelegate.h"
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>
@implementation Tool


+(NSMutableDictionary *)getBaseDicWithAppID:(NSString *)appID withAPIVersion:(NSString *)version
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [myDelegate.baseDic setObject:appID forKey:@"appid"];
        [myDelegate.baseDic setObject:[NSNumber numberWithInt:[@"1" intValue]] forKey:@"version_code"];
        [myDelegate.baseDic setObject:[self getVersion] forKey:@"version_name"];
        if (IS_IPHONE) {
            
            [myDelegate.baseDic setObject:[NSNumber numberWithInt:0x10] forKey:@"os_type"];
        }else{
            [myDelegate.baseDic setObject:[NSNumber numberWithInt:0x11] forKey:@"os_type"];
        }
        
        [myDelegate.baseDic setObject:version forKey:@"api_version"];
        [myDelegate.baseDic setObject:@"Appstore" forKey:@"channel"];
    });
    
    return myDelegate.baseDic;
    
}

+(void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    
    CGSize size = CGSizeMake(290,9000); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    CGSize LabelSize = [message boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake((myScreenWidth - LabelSize.width - 20)/2, myScreenHeight - 100, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:2 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}
+ (NSString *)getVersion{
    
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];;
}
/**
 *  手机号码验证
 *
 *  @param mobileNumbel 传入的手机号码
 *
 *  @return 格式正确返回true  错误 返回fals
 */
+ (BOOL) isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    
    return NO;
}
#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
+(BOOL) isExistFile:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *ducumentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *FilePath = [NSString stringWithFormat:@"%@/%@/%@.mp4",ducumentsDirectory,[APPConfig getInstance].currentKey,fileName];
    
    if ([fm fileExistsAtPath:FilePath]) {
        
        return YES;
    }else{
        return NO;
    }
}

+(void) removeMovFile:(NSString *)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *ducumentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *FilePath = [NSString stringWithFormat:@"%@/%@/%@.mov",ducumentsDirectory,[APPConfig getInstance].currentKey,fileName];
    
    if ([fm fileExistsAtPath:FilePath]) {
        
        NSError *err;
        [fm removeItemAtPath:FilePath error:&err];
    }
}
+(void) removeFile:(NSString *)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *ducumentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *FilePath = [NSString stringWithFormat:@"%@/%@/%@.mp4",ducumentsDirectory,[APPConfig getInstance].currentKey,fileName];
    
    if ([fm fileExistsAtPath:FilePath]) {
        
        NSError *err;
        [fm removeItemAtPath:FilePath error:&err];
    }
}
+(int) getVideoFileSecond:(NSString *)fileName{
    
    NSString *appDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *folderPath = [appDocumentPath stringByAppendingPathComponent:[APPConfig getInstance].currentKey];
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:[[folderPath stringByAppendingPathComponent:fileName] stringByAppendingString:@".mp4"]]];
    CMTime time = [avUrl duration];
    int seconds = ceil(time.value/time.timescale);
    return seconds;
}
+(NSString *)getCurrentTime{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    return currentTime;
}
+ (float) fileSizeAtInCar{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *ducumentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@.mp4",ducumentsDirectory,[APPConfig getInstance].currentKey,@"ios_in"];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/(1024.0*1024);
    }
    return 0;
    
}
+ (float) fileSizeAtOutCar{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *ducumentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@.mp4",ducumentsDirectory,[APPConfig getInstance].currentKey,@"ios_out"];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/(1024.0*1024);
    }
    return 0;
}
//获取视频封面，本地视频，网络视频都可以用

+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(2.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumbImg = [[UIImage alloc] initWithCGImage:image];
    
    return thumbImg;
    
}
+ (NSString *)getIpAddresses {
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) return nil;
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    struct ifconf ifc;
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifreq *ifr, ifrcopy;
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    close(sockfd);
    return [ips lastObject];
}
+ (NSString *)hidePhoneNum:(NSString *)phoneNum{
    
    return [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
}
/*车牌号验证*/
+(BOOL)validateCarNo:(NSString*)carNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carNo];
}

@end
