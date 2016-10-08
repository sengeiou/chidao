//
//  NewsClient.m
//
//
//  Created by zy on 15/3/12.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "NewsClient.h"
#import "APPConfig.h"
#import "HisuntechAFNetworking.h"

@implementation NewsClient

+ (NewsClient *)sharedClient{
    static NewsClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:BASEURL];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
         //设置我们的缓存大小 其中内存缓存大小设置10M  磁盘缓存50M
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10*1024*1024 diskCapacity:50*1024*1024 diskPath:nil];
        [config setURLCache:cache];
        _sharedClient = [[NewsClient alloc] initWithBaseURL:baseURL sessionConfiguration:config];
        _sharedClient.responseSerializer = [HisuntechAFJSONResponseSerializer serializer];
        
    });
    return _sharedClient;
}
//--------------------------------------登录功能-------------------------------------
//--------------------------------------登录功能-------------------------------------
//--------------------------------------登录功能-------------------------------------
-(NSURLSessionDataTask *) userReg:(NSString *)path withPhoneID:(NSString *)phomacid withAccount:(NSString *)account withMobile:(NSString *)mobile withPwd:(NSString *)pwd withMsgCode:(NSString *)msgcode withArea:(NSString *)area withRegip:(NSString *)regip completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    
    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
    [mDic setObject:[NSString stringWithFormat:@"%@", phomacid] forKey:@"phomacid"];
    [mDic setObject:[NSString stringWithFormat:@"%@", account] forKey:@"account"];
    [mDic setObject:[NSString stringWithFormat:@"%@", mobile] forKey:@"mobile"];
    [mDic setObject:[NSString stringWithFormat:@"%@", pwd] forKey:@"passwd"];
    [mDic setObject:[NSString stringWithFormat:@"%@", msgcode] forKey:@"msgchkcode"];
    [mDic setObject:[NSString stringWithFormat:@"%@", area] forKey:@"area"];
    [mDic setObject:[NSString stringWithFormat:@"%@", regip] forKey:@"reg_ip"];
    
    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
}



-(NSURLSessionDataTask *) login:(NSString *)path withAccount:(NSString *)account withPwd:(NSString *)pwd withLoginTime:(NSString *)logintime withArea:(NSString *)area withLoginip:(NSString *)loginip withClientid:(NSString *)clientid completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    
    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];

    [mDic setObject:[NSString stringWithFormat:@"%@", account] forKey:@"account"];
    [mDic setObject:[NSString stringWithFormat:@"%@", pwd] forKey:@"passwd"];
    [mDic setObject:[NSString stringWithFormat:@"%@", logintime] forKey:@"login_time"];
    [mDic setObject:[NSString stringWithFormat:@"%@", area] forKey:@"area"];
    [mDic setObject:[NSString stringWithFormat:@"%@", loginip] forKey:@"login_ip"];
    [mDic setObject:[NSString stringWithFormat:@"%@", clientid] forKey:@"client_id"];
    
    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (httpResponse.statusCode == 200) {
            
            
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
}

-(NSURLSessionDataTask *) logout:(NSString *)path withToken:(NSString *)token completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    
    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
    
    [mDic setObject:[NSString stringWithFormat:@"%@",token] forKey:@"token"];

    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
}

-(NSURLSessionDataTask *) userUpdate:(NSString *)path withToken:(NSString *)token withOrgid:(NSString *)orgid withHeadpic:(NSString *)headpic withNickName:(NSString *)nickname completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    
    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
    
    [mDic setObject:[NSString stringWithFormat:@"%@",token] forKey:@"token"];
    [mDic setObject:[NSString stringWithFormat:@"%@",orgid] forKey:@"orgid"];
    [mDic setObject:[NSString stringWithFormat:@"%@",headpic] forKey:@"headpic"];
    [mDic setObject:[NSString stringWithFormat:@"%@",nickname] forKey:@"nick_name"];
    
    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
}

-(NSURLSessionDataTask *) tokenUpdate:(NSString *)path withToken:(NSString *)token completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    
    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
    
    [mDic setObject:[NSString stringWithFormat:@"%@",token] forKey:@"token"];
    
    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
}

-(NSURLSessionDataTask *) validatePwd:(NSString *)path withOldPwd:(NSString *)oldPwd withToken:(NSString *)token completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    
    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
    
    [mDic setObject:[NSString stringWithFormat:@"%@",token] forKey:@"token"];
    [mDic setObject:[NSString stringWithFormat:@"%@",oldPwd] forKey:@"passwd"];
    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
}


-(NSURLSessionDataTask *) forgetPwd:(NSString *)path withToken:(NSString *)token withPwd:(NSString *)pwd withRePwd:(NSString *)repwd withMsgCode:(NSString *)msgcode withArea:(NSString *)area withRegip:(NSString *)regip completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    
    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
    [mDic setObject:[NSString stringWithFormat:@"%@", token] forKey:@"token"];
    [mDic setObject:[NSString stringWithFormat:@"%@", pwd] forKey:@"passwd"];
    [mDic setObject:[NSString stringWithFormat:@"%@", repwd] forKey:@"repasswd"];
    [mDic setObject:[NSString stringWithFormat:@"%@", msgcode] forKey:@"msgchkcode"];
    [mDic setObject:[NSString stringWithFormat:@"%@", area] forKey:@"area"];
    [mDic setObject:[NSString stringWithFormat:@"%@", regip] forKey:@"reg_ip"];
    
    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
}

-(NSURLSessionDataTask *) revisePwd:(NSString *)path withToken:(NSString *)token withPwd:(NSString *)pwd withRePwd:(NSString *)repwd withArea:(NSString *)area withRegip:(NSString *)regip completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    
    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
    [mDic setObject:[NSString stringWithFormat:@"%@", token] forKey:@"token"];
    [mDic setObject:[NSString stringWithFormat:@"%@", pwd] forKey:@"passwd"];
    [mDic setObject:[NSString stringWithFormat:@"%@", repwd] forKey:@"repasswd"];
    [mDic setObject:[NSString stringWithFormat:@"%@", area] forKey:@"area"];
    [mDic setObject:[NSString stringWithFormat:@"%@", regip] forKey:@"reg_ip"];
    
    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
}
//-----------鲁通卡功能---------------
-(NSURLSessionDataTask *) addCard:(NSString *)path withToken:(NSString *)token withCardId:(NSString *)cardid withCarval:(NSString *)carval withArea:(NSString *)area withRegip:(NSString *)regip completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
    [mDic setObject:[NSString stringWithFormat:@"%@", token] forKey:@"token"];
    [mDic setObject:[NSString stringWithFormat:@"%@", cardid] forKey:@"cardid"];
    [mDic setObject:[NSString stringWithFormat:@"%@", carval] forKey:@"carval"];
    [mDic setObject:[NSString stringWithFormat:@"%@", area] forKey:@"area"];
    [mDic setObject:[NSString stringWithFormat:@"%@", regip] forKey:@"reg_ip"];
    
    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
    
}

-(NSURLSessionDataTask *) removeCard:(NSString *)path withToken:(NSString *)token withCardId:(NSString *)cardid withCarval:(NSString *)carval withArea:(NSString *)area withRegip:(NSString *)regip completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
    [mDic setObject:[NSString stringWithFormat:@"%@", token] forKey:@"token"];
    [mDic setObject:[NSString stringWithFormat:@"%@", cardid] forKey:@"cardid"];
    [mDic setObject:[NSString stringWithFormat:@"%@", carval] forKey:@"carval"];
    [mDic setObject:[NSString stringWithFormat:@"%@", area] forKey:@"area"];
    [mDic setObject:[NSString stringWithFormat:@"%@", regip] forKey:@"reg_ip"];
    
    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
}

-(NSURLSessionDataTask *) getCard:(NSString *)path withToken:(NSString *)token completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
    [mDic setObject:[NSString stringWithFormat:@"%@", token] forKey:@"token"];
    
    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
}


-(NSURLSessionDataTask *) getOrders:(NSString *)path withToken:(NSString *)token withPagenum:(int)pagenum withPagesize:(int)pagesize withArea:(NSString *)area withRegip:(NSString *)regip completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
    [mDic setObject:[NSString stringWithFormat:@"%@", token] forKey:@"token"];
    [mDic setObject:[NSString stringWithFormat:@"%d", pagenum] forKey:@"pagenum"];
    [mDic setObject:[NSString stringWithFormat:@"%d", pagesize] forKey:@"pagesize"];
    [mDic setObject:[NSString stringWithFormat:@"%@", area] forKey:@"area"];
    [mDic setObject:[NSString stringWithFormat:@"%@", regip] forKey:@"reg_ip"];
    
    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
    
}

-(NSURLSessionDataTask *) getCardInfo:(NSString *)path withToken:(NSString *)token withCardId:(NSString *)cardid withArea:(NSString *)area withRegip:(NSString *)regip completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    
    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
    [mDic setObject:[NSString stringWithFormat:@"%@", token] forKey:@"token"];
    [mDic setObject:[NSString stringWithFormat:@"%@", cardid] forKey:@"cardid"];
    [mDic setObject:[NSString stringWithFormat:@"%@", area] forKey:@"area"];
    [mDic setObject:[NSString stringWithFormat:@"%@", regip] forKey:@"reg_ip"];
    
    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
    
}
//-----------我的功能-----------------
-(NSURLSessionDataTask *) addAddress:(NSString *)path withToken:(NSString *)token withName:(NSString *)name withAddressArea:(NSString *)addressArea withAddrDetail:(NSString *)addrDetail withPostid:(NSString *)postid withMobile:(NSString *)mobile completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
    [mDic setObject:[NSString stringWithFormat:@"%@", token] forKey:@"token"];
    [mDic setObject:[NSString stringWithFormat:@"%@", name] forKey:@"name"];
    [mDic setObject:[NSString stringWithFormat:@"%@", addressArea] forKey:@"addrArea"];
    [mDic setObject:[NSString stringWithFormat:@"%@", addrDetail] forKey:@"addrDetail"];
    [mDic setObject:[NSString stringWithFormat:@"%@", postid] forKey:@"postnub"];
    [mDic setObject:[NSString stringWithFormat:@"%@", mobile] forKey:@"mobile"];
    
    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
    
}

-(NSURLSessionDataTask *) updateAddress:(NSString *)path withToken:(NSString *)token withID:(NSString *)addrid withName:(NSString *)name withAddressArea:(NSString *)addressArea withAddrDetail:(NSString *)addrDetail withPostid:(NSString *)postid withMobile:(NSString *)mobile completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
    
    [mDic setObject:[NSString stringWithFormat:@"%@", token] forKey:@"token"];
    [mDic setObject:[NSString stringWithFormat:@"%@", addrid] forKey:@"addrid"];
    [mDic setObject:[NSString stringWithFormat:@"%@", name] forKey:@"name"];
    [mDic setObject:[NSString stringWithFormat:@"%@", addressArea] forKey:@"addrArea"];
    [mDic setObject:[NSString stringWithFormat:@"%@", addrDetail] forKey:@"addrDetail"];
    [mDic setObject:[NSString stringWithFormat:@"%@", postid] forKey:@"postnub"];
    [mDic setObject:[NSString stringWithFormat:@"%@", mobile] forKey:@"mobile"];
    
    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
    
}

-(NSURLSessionDataTask *) removeAddress:(NSString *)path withToken:(NSString *)token withAddrid:(NSString *)addrid withArea:(NSString *)area withRegip:(NSString *)regip completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
    [mDic setObject:[NSString stringWithFormat:@"%@", token] forKey:@"token"];
    [mDic setObject:[NSString stringWithFormat:@"%@", addrid] forKey:@"addrid"];
    [mDic setObject:[NSString stringWithFormat:@"%@", area] forKey:@"area"];
    [mDic setObject:[NSString stringWithFormat:@"%@", regip] forKey:@"reg_ip"];
    
    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
    
}

-(NSURLSessionDataTask *) getAddress:(NSString *)path withToken:(NSString *)token completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
    [mDic setObject:[NSString stringWithFormat:@"%@", token] forKey:@"token"];
    
    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
    
}
/**
 *  obu亮灯次数获取
 *
 *  @param path
 *  @param completion
 *
 *  @return
 */
-(NSURLSessionDataTask *) getLightNums:(NSString *)path withToken:(NSString *)token withObuID:(NSString *)obuID completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    

    NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
    [mDic setObject:[NSString stringWithFormat:@"%@", token] forKey:@"token"];
    [mDic setObject:[NSString stringWithFormat:@"%@", obuID] forKey:@"obu_id"];
    
    NSURLSessionDataTask * task = [self POST:[NSString stringWithFormat:@"%@%@",BASEURL,path] parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;

        if (httpResponse.statusCode == 200) {
            completion(responseObject,nil);
        }else{
            
             completion(nil, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    return task;
}


@end
