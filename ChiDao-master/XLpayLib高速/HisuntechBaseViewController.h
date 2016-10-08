//
//  BaseViewController.h
//  Demo_1
//
//  Created by allen on 14-9-18.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HisuntechBaseViewControllerDelegate<NSObject>
// 请求成功
-(void)resquestSuccess:(id)response;
// 请求失败
-(void)resquestFail:(id)response;

@end

@interface HisuntechBaseViewController : UIViewController{
    int codeType;
    UIImageView *contentView;
}
@property (nonatomic) int codeType;
@property (nonatomic,retain) UIImageView *contentView;
@property (nonatomic,retain) UIImageView *backView;
@property (nonatomic,retain) NSDictionary *resultStr;
@property (weak, nonatomic) id<HisuntechBaseViewControllerDelegate> HBdelegate;

+(HisuntechBaseViewController *)Instance;
// 请求服务器接口 codeType 标示位判定
-(void)requestServer:(NSDictionary*)parameters requestType:(NSString*)reqType codeType:(int) codeType;

/**
 *  请求接口
 *
 *  @param parameters1 上行参数
 *  @param reqType     /服务/接口
 */
- (void)requestServer:(NSDictionary *)parameters requestType:(NSString *)reqType successSel:(SEL)success failureSel:(SEL)failure;

// 请求成功
-(void)resquestSuccess:(id)response;
// 请求失败
-(void)resquestFail:(id)response;
// Json数据循环遍历（暂时未使用）
-(NSString *)stringFormDict:(NSDictionary*)dict;
// 设置返回按钮
- (void)setLeftItemToBack;
/**
 *  把自己pop 出去
 */
- (void)backPop;
-(void)toastResult:(NSString *) toastMsg;


@end
