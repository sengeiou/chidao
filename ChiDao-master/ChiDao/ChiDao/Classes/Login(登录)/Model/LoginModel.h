//
//  LoginModel.h
//  ChiDao
//
//  Created by 赵洋 on 16/7/15.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import <Foundation/Foundation.h>
//"expires_in" = 1469170032384;
//"is_inblack" = 0;
//"is_real_name_auth" = 0;
//"last_login_ip" = "192.168.0.106";
//"last_login_time" = 20160715144712;
//"nick_name" = "";

//"pay_acct" = 100000088015;
//phone = 15066686213;
//"portrait_url" = "";
//"rank_id" = 0;
//"real_name" = "";
//token = 39be79c563bc490c81458db2d0befe49;
//"user_id" = 83;


//"user_id_card" = "";
//"user_id_cardtype" = 0;
//"user_role" = 0;
@interface LoginModel : NSObject
@property (nonatomic, strong) NSString* expires_in;
@property (nonatomic, strong) NSString* is_inblack;
@property (nonatomic, strong) NSString* is_real_name_auth;
@property (nonatomic, strong) NSString* last_login_ip;
@property (nonatomic, strong) NSString* last_login_time;
@property (nonatomic, strong) NSString* nick_name;

@property (nonatomic, strong) NSString* pay_acct;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSString* portrait_url;
@property (nonatomic, strong) NSString* rank_id;
@property (nonatomic, strong) NSString* real_name;
@property (nonatomic, strong) NSString* token;

@property (nonatomic, strong) NSString* user_id;
@property (nonatomic, strong) NSString* user_id_card;
@property (nonatomic, strong) NSString* user_id_cardtype;
@property (nonatomic, strong) NSString* user_role;
@end
