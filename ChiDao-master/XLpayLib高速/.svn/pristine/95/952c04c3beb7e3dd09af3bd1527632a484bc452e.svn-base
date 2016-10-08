//
//  Tools.m
//  ZPay
//
//  Created by liao on 14-5-6.
//  Copyright (c) 2014年 thtf. All rights reserved.
//
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>

#import "HisunTechTools.h"

@implementation HisunTechTools

/**
 *  设备唯一编号
 *
 *  @return <#return value description#>
 */
- (NSString*)uuid
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
//    NSLog(@"result = %@",result);
    //将字符串中"-" 全部替换成 ""
    NSString *str = [result stringByReplacingOccurrencesOfString :@"-" withString:@""];
//    NSLog(@"str = %@",str);
    return str;
}

/**
 *  获取设备MAC地址
 *
 *  @return <#return value description#>
 */
- (NSString *) macaddress
{
	int                    mib[6];
	size_t                len;
	char                *buf;
	unsigned char        *ptr;
	struct if_msghdr    *ifm;
	struct sockaddr_dl    *sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		printf("Error: if_nametoindex error/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 1/n");
		return NULL;
	}
	
	if ((buf = malloc(len)) == NULL) {
		printf("Could not allocate memory. error!/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 2");
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	// NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
	return [outstring uppercaseString];
	
}

/**
 *  时间戳
 */
- (NSString*) simulateAndRenderScene
{
    CFTimeInterval thisFrameStartTime = CFAbsoluteTimeGetCurrent();
//    float deltaTimeInSeconds = thisFrameStartTime - lastFrameStartTime;
    lastFrameStartTime = thisFrameStartTime;
    NSString *time = [NSString stringWithFormat:@"%f",lastFrameStartTime];
    NSString *tempA = [time substringToIndex:9];
//    NSLog(@"tempA = %@",tempA);
    NSString *tempB = [time substringFromIndex:10];
//    NSLog(@"tempB = %@",tempB);
    NSString *stringTime = [NSString stringWithFormat:@"%@%@",tempA,tempB];
//    NSLog(@"stringTime = %@",stringTime);
    return stringTime;
}

#pragma mark 获取ip地址

/**
 *  动态获取IP地址
 */
+ (NSString *) localWiFiIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}


@end
