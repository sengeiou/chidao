//
//  MixPayViewController.h
//  Demo_1
//
//  Created by mac on 14-10-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HisuntechBaseViewController.h"
@interface HisuntechMixPayViewController : HisuntechBaseViewController<UITextFieldDelegate,UIAlertViewDelegate,UIApplicationDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    
    NSString *payPwd;
    
    //创建其他账户 返回的 block  用来清空用户名输入框
    void(^backFromCashierDesk)(BOOL backBool);
    
}


//其他账户 切换回来的 block回调
-(void)judeOtherAccountBack:(void(^)(BOOL backBool))otherAccountBlock;

//商城传过来订单的金额
@property (strong,nonatomic) NSMutableArray *dataList;
@property (strong,nonatomic) NSString *money;
@property (strong, nonatomic) UILabel *mixPayTitle;//title bar
@property (assign)BOOL isOpen;
@property (nonatomic,retain) NSIndexPath *selectIndex;
@property (nonatomic,retain) UITableView *mixPaytableView;
@property (nonatomic,strong) NSString *vchNum;//代金券总数目
@property (nonatomic,strong) NSString *vchLim;//代金券限额
@property (nonatomic,strong) NSDictionary *vchRecJson;//代金券详细信息
@property (nonatomic,strong) NSString *bonNum;//红包总数目
@property (nonatomic,strong) NSString *bonLim;//红包限额
@property (nonatomic,strong) NSString *bonCntLim;//红包张数限制
@property (nonatomic,strong) NSDictionary *bonRecJson;//红包详细信息
@property (nonatomic,strong) NSDictionary *dic;//跳转传递值
@property (assign,nonatomic) BOOL isChecked;
@property (retain,nonatomic) NSMutableArray *tableFaceValue;
@property (retain,nonatomic) NSMutableArray *tableEndDate;
@property (retain,nonatomic) NSMutableArray *tableDic;
@property (retain,nonatomic) NSDictionary *addDic;
@property (nonatomic,retain)NSArray *bankArry;

@property (nonatomic,copy) NSString *charSet;
@property (nonatomic,copy) NSString *reqData;
@property (nonatomic,copy) NSString *signData;
@property (nonatomic,copy) NSString *signType;
@property (nonatomic,copy) NSString *payAction;
//credt:@"" ordNo:@"" merOrdNo:@""
@property (nonatomic,copy) NSString *creDt;
@property (nonatomic,copy) NSString *ordNo;
@property (nonatomic,copy) NSString *merOrdNo;
- (void)goToPaySucceedView;//跳转到支付成功页面

- (void)goToRedPacketView;//跳转到选择红包页面

- (void)goToVoucherView;//跳转到选择代金券页面
@end
