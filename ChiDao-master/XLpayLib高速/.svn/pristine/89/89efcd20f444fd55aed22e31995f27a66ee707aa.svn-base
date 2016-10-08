//
//  MixPayViewController.m
//  Demo_1
//
//  Created by mac on 14-10-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechMixPayViewController.h"
#import "HisuntechPaySucceedController.h"
#import "HisuntechAddDebitCardController.h"
#import "HisuntechAddCreditCardController.h"
#import "HisuntechAccountPayCell.h"
#import "HisuntechOrderMoneyCell.h"
#import "HisuntechQuickPayMoneyCell.h"
#import "HisuntechQuickCreditPayViewCell.h"
#import "HisuntechQuickDebitPayViewCell.h"
#import "HisuntechSurePayCell.h"
#import "HisuntechCustomAlertView.h"
#import "HisuntechBankCellView.h"
#import "HisuntechAddView.h"
#import "HisuntechConvert.h"
#import "UIImageView+AFNetworking.h"
#import "HisuntechUserEntity.h"
#import "HisuntechPaySucceedController.h"
#import "HisuntechPayFailedViewController.h"
#import "HisuntechBankPayViewCell.h"
#import "Reachability.h"
#define URL @"https://www.xlpayment.com/images/appsdk/"

@interface HisuntechMixPayViewController ()<HisuntechBNDelegate>
{
    int flag;//flag的值分别代表的是借记卡和信用卡
    float heightOfCell;//行高
    int cellNum;//cell个数
    float balance;//账户余额
    NSString *crdNum;
    int rowNum;//行数
    int AccountPay;//余额需要支付的金额
    int redPockCount;
    int voucherCount;
    float voucherMoney;//代金券金额
    float redPockMoney;//红包金额
    BOOL isCreditOpen;//
    BOOL isDebitOpen;//
    BOOL isClick;//账户付款是否勾选
    BOOL redClick;//红包支付是否勾选
    BOOL voucherClick;//代金券支付是否勾选
    BOOL debitClick;//借记卡支付是否勾选
    BOOL creditClick;//信用卡支付是否勾选
    BOOL isBankClick;//银联支付是否勾选
    HisuntechOrderMoneyCell *order;
    HisuntechAccountPayCell *account;
    HisuntechQuickCreditPayViewCell *credit;
    HisuntechQuickDebitPayViewCell *debit;
    HisuntechSurePayCell *surePay;
    HisuntechQuickPayMoneyCell *quickPay;
    HisuntechBankPayViewCell *bankPay;//银联支付
    UITextField *payPassWord;
    NSMutableArray *creditArr;//信用卡信息
    NSMutableArray *debitArr;//借记卡信息
    NSDictionary *quickBankChoosed;
    NSDictionary *creditChoosed;//选择的信用卡
    NSDictionary *debitChoosed;//选择的借记卡
    NSMutableArray *redChoosedArr;//选择的红包
    NSDictionary *voucherChoosed;//选择的代金券
    float accountMoney;//账户支付金额
    float quickPayMoney;//快捷支付金额
    HisuntechCustomAlertView *_alertView;//警示框
    NSString *_password;
}
@end

@implementation HisuntechMixPayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isClick = NO;
        isBankClick = NO;
        creditArr = [[NSMutableArray alloc]init];
        debitArr = [[NSMutableArray alloc]init];
        cellNum = 100;
        /**
         *  自定义标题
         */
        self.mixPayTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
        self.mixPayTitle.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        self.mixPayTitle.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
        self.mixPayTitle.textColor = [UIColor whiteColor];  //设置文本颜色
        //self.mixPayTitle.textAlignment = UITextAlignmentCenter;
        self.mixPayTitle.textAlignment = NSTextAlignmentCenter;
        self.mixPayTitle.text = @"支付平台";  //设置标题
        //self.navigationItem.hidesBackButton = YES;//隐藏返回键
        self.navigationItem.titleView = self.mixPayTitle;

        //_payAction
        /*
         _payAction = @"PAY_AGAIN";
         _creDt =@"20141122";
         _ordNo = @"201411140000533383";
         _merOrdNo = @"20141122172340";
         _money = @"0.1";
         _signType = @"MD5";
         _charSet =@"00";
         _signData = @"d69320567ced45930680618b9c8dbb12";
         _reqData = @"{'version_no':'1.0','biz_type':'LogDirectPayment','sign_type':'MD5','char_set':'00','page_return_url':'http://10.180.223.152:8680/mercdemom/callback.jsp','offline_notify_url':'http://192.168.0.241:8080/rsademo/notify.jsp','client_ip':'10.0.2.15','order_date':'20140724','bank_abbr':'ICBC','card_type':'1','partner_id':'800053100010001','log_partner_id':'222','partner_name':'test','partner_ac_date':'20140724','request_id':'8000531000100011416483575892','order_id':'1416483575922','total_amount':'0.01','show_url':'http://192.168.0.241:8080/rsademo/test.html','purchaser_id':'12345678901','product_name':'SDHS_Test','product_desc':'Test_one','attach_param':'I_come_back','valid_unit':'02','valid_num':'1'}";
         */
        HisuntechUserEntity *user = [HisuntechUserEntity Instance];
        _payAction = user.ACTION;
        //_payAction = @"MER_PAY";
        _creDt =user.CREDT;
        _ordNo = user.ORDNO;
        _merOrdNo = user.MERORDNO;
        _reqData =user.REQ_DATA;
        if ([_payAction isEqualToString:@"PAY_AGAIN"]) {
            NSLog(@"pay");
            _money = user.TOTAL_AMOUNT;
        }
        else if([_payAction isEqualToString:@"MER_PAY"])
        {
            NSLog(@"mer");
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:[_reqData dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            NSLog(@"temp:%@",tempDic);
            _money = [tempDic objectForKey:@"total_amount"];
        }
        _signType = user.SIGN_TYPE;
        _charSet = user.CHARSET;
        _signData = user.REQ_SIGN;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUserInfo];
}
- (void)viewDidLoad
{
    NSLog(@"DIC :%@",self.dic);
    //balance = [[_dic objectForKey:@"DRW_BAL"] floatValue];
    isCreditOpen = NO;
    
    [super viewDidLoad];
    rowNum = 7;
    [self createUI];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)createUI
{
    self.mixPaytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    self.mixPaytableView.bounces = NO;
    self.mixPaytableView.showsVerticalScrollIndicator = NO;
    self.mixPaytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mixPaytableView.delegate = self;
    self.mixPaytableView.dataSource = self;
    [self.view addSubview:self.mixPaytableView];
}

/**
 *  捡起订单账户支付
 */
-(void)pickOrderAccountPay
{
    NSString *payAmt = [[NSString alloc]init];
    payAmt = [account.AccountPay.text substringFromIndex:1];
    payAmt = [[NSString alloc]initWithFormat:@"%.f",[payAmt floatValue]*100];
    //上行参数
    NSDictionary *requestDict = [HisuntechBuildJsonString getPickOrderAccountPayJsonString:[HisuntechUserEntity Instance].userId userNo:[HisuntechUserEntity Instance].userNo regEmail:@"" credt:_creDt ordNo:_ordNo merOrdNo:_merOrdNo bonStr:@"" bonTotAmt:@"0" vchStr:@"" vchTotAmt:@"0" payAmtStr:payAmt];
    //请求服务器
    [self requestServer:requestDict requestType:APP_CODE_PickOrderAccountPay codeType:8];
}
/**
 *  捡起订单快捷支付
 */
-(void)PickOrderQuickCardPay
{
    NSString *accountAmt = [[NSString alloc]init];
    if (!isClick) {
        accountAmt = @"";
    }
    else
    {
        accountAmt = [account.AccountPay.text substringFromIndex:1];
        accountAmt = [[NSString alloc]initWithFormat:@"%.f",[accountAmt floatValue]*100];
    }
    //上行参数
    NSString* payAmtTemp = [quickPay.QuickMoney.text substringFromIndex:1];
    NSString* payAmt = [[NSString alloc]initWithFormat:@"%.f",[payAmtTemp floatValue]*100];
    NSString* payTotal = [[NSString alloc]initWithFormat:@"%.f",[_money floatValue]*100];
    NSLog(@"payAmt:%@",payAmt);
    NSDictionary *requestDict = [HisuntechBuildJsonString getPickOrderQuickCardPayJsonString:[HisuntechUserEntity Instance].userId userNo:[HisuntechUserEntity Instance].userNo regEmail:@"" bonStr:@"" bonTotAmt:@"0" vchStr:@"" vchTotAmt:@"0" orderAmt:payTotal credt:_creDt orderNo:_ordNo merOrderNo:_merOrdNo payAmt:payAmt payTotal:payTotal accountAmt:accountAmt pwd:_password bankNo:[quickBankChoosed objectForKey:@"QUICK_BNK_NO"] cvn2:@"" bankNum:[quickBankChoosed objectForKey:@"CAP_CRD_NO"] date:@"" phoneNum:@"" crdTyp:[quickBankChoosed objectForKey:@"CAP_CRD_TYP"] name:@"" IDnum:@"" AgrNo:[quickBankChoosed objectForKey:@"AGR_NO"]];
    //请求服务器
    [self requestServer:requestDict requestType:APP_CODE_PickOrderQuickCardPay codeType:14];
}

/**
 *  银联支付
 */
-(void)UnionpayCardPay
{
    NSLog(@"银联支付");
}


/**
 *  查询绑定银行卡
 */
-(void)selectBindBankCard{
    //上行参数
    NSDictionary *requestDict = [HisuntechBuildJsonString getBindBankMsgJsonString:[HisuntechUserEntity Instance].userId userNo:[HisuntechUserEntity Instance].userNo regEmail:@""];
    //请求服务器
    [self requestServer:requestDict requestType:APP_CODE_QueryBindBankMsg codeType:10];
}
/**
 *  账户支付 codeType
 */
-(void)AccountPay{

    NSString* payAmt = [[NSString alloc]initWithFormat:@"%.f",[_money floatValue]*100];
    //上行参数
    NSDictionary *requestDict = [HisuntechBuildJsonString getAccountPayJsonString:[HisuntechUserEntity Instance].userId userNo:[HisuntechUserEntity Instance].userNo regEmail:@"" payType:@"3" sdkCert:@"" signStr:@"" charSet:@"00" reqData:_reqData reqCert:[HisuntechUserEntity Instance].REQ_CERT signData:_signData signType:_signType bonStr:@"" bonTotAmt:@"0" vchStr:@"" vchTotAmt:@"0" payAmtStr:payAmt prdProperty:@""];
    NSLog(@"REQ_SIGN: %@",requestDict);
    //请求服务器
    [self requestServer:requestDict requestType:APP_CODE_AccountPay codeType:7];
}
/**
 *  快捷支付（包含混合支付）
 */
-(void)quickPay
{
    NSString *accountAmt = [[NSString alloc]init];
    if (!isClick) {
        accountAmt = @"";
    }
    else
    {
        accountAmt = [account.AccountPay.text substringFromIndex:1];
        accountAmt = [[NSString alloc]initWithFormat:@"%.f",[accountAmt floatValue]*100];
    }
    //上行参数
    NSString* payAmtTemp = [quickPay.QuickMoney.text substringFromIndex:1];
    NSString* payAmt = [[NSString alloc]initWithFormat:@"%.f",[payAmtTemp floatValue]*100];
    NSString* payTotal = [[NSString alloc]initWithFormat:@"%.f",[_money floatValue]*100];
    NSDictionary *requestDict = [HisuntechBuildJsonString getQuickCardPayJsonString:[HisuntechUserEntity Instance].userId userNo:[HisuntechUserEntity Instance].userNo regEmail:@"" bonStr:@"" bonTotAmt:@"0" vchStr:@"" vchTotAmt:@"0" charSet:_charSet reqData:_reqData reqCert:[HisuntechUserEntity Instance].REQ_CERT signData:_signData signType:_signType payAmt:payAmt payTotal:payTotal accountAmt:accountAmt pwd:_password bankNo:[quickBankChoosed objectForKey:@"QUICK_BNK_NO"] cvn2:@"" bankNum:[quickBankChoosed objectForKey:@"CAP_CRD_NO"] date:@"" phoneNum:@"" crdTyp:[quickBankChoosed objectForKey:@"CAP_CRD_TYP"] name:@"" IDnum:@"" AgrNo:[quickBankChoosed objectForKey:@"AGR_NO"]];
    //请求服务器
    [self requestServer:requestDict requestType:APP_CODE_QuickCardPay codeType:11];
}
/**
 *  更新用户信息
 */
-(void)updateUserInfo
{
    //上行参数
    NSDictionary *requestDict = [HisuntechBuildJsonString getUpdateAccountMsgJsonString:[HisuntechUserEntity Instance].userId userNo:[HisuntechUserEntity Instance].userNo regEmail:@""];
    //请求服务器
    [self requestServer:requestDict requestType:APP_CODE_UpdateAccountMsg codeType:15];
}

/**
 *  请求服务器成功
 */
-(void)resquestSuccess:(id)response{
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    //获取随机因子
     if (codeType == 4) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] )
        {
            _password = [_alertView.text getValue:[NSString stringWithFormat:@"%@000",[dictJson objectForKey:@"SYSTM"]]];
            [self checkPayWord];
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
        return;
    }
    //账户支付
     else if (codeType == 7) {
         NSLog(@"账户支付%@",dictJson);
         if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] )
         {
             [_alertView removeFromSuperview];
             if ([[[dictJson objectForKey:@"GWA"] objectForKey:@"MSG_INF"]isEqualToString:@"交易成功"]) {
                 HisuntechPaySucceedController *succeed = [[HisuntechPaySucceedController alloc]init];
                 succeed.payNumStr = _money;
                 [self.navigationController pushViewController:succeed animated:YES];
             }
             else
             {
                 HisuntechPayFailedViewController *failed = [[HisuntechPayFailedViewController alloc]init];
                 [self.navigationController pushViewController:failed animated:YES];
             }
         }else{
             [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
         }
         return;
         
     }
    //捡起订单 -- 账户支付
    else if (codeType == 8) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] )
        {
            [_alertView removeFromSuperview];
            if ([[[dictJson objectForKey:@"GWA"] objectForKey:@"MSG_INF"]isEqualToString:@"交易成功"]) {
                HisuntechPaySucceedController *succeed = [[HisuntechPaySucceedController alloc]init];
                succeed.payNumStr = _money;
                [self.navigationController pushViewController:succeed animated:YES];
            }
            else
            {
                HisuntechPayFailedViewController *failed = [[HisuntechPayFailedViewController alloc]init];
                [self.navigationController pushViewController:failed animated:YES];
            }
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
    }
    //查询绑定银行卡
    else if (codeType == 10) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
            self.bankArry = [dictJson objectForKey:@"CRD"];
            [debitArr removeAllObjects];
            [creditArr removeAllObjects];
            for (NSDictionary *temp in self.bankArry) {
                if ([[temp objectForKey:@"CAP_CRD_TYP"]isEqualToString:@"1"]) {
                    [debitArr addObject:temp];
                }
                else
                    [creditArr addObject:temp];
            }
            if (cellNum == 3) {
                heightOfCell = 100 + 50*debitArr.count;
                NSIndexPath *path = [NSIndexPath indexPathForRow:3 inSection:0];
                [self.mixPaytableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else
            {
                heightOfCell = 100 + 50*creditArr.count;
                NSIndexPath *path = [NSIndexPath indexPathForRow:4 inSection:0];
                [self.mixPaytableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
        return;
    }
    //快捷支付
    else if (codeType == 11) {
        NSLog(@"快捷支付%@",dictJson);
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] )
        {
            [_alertView removeFromSuperview];
            if ([[[dictJson objectForKey:@"GWA"] objectForKey:@"MSG_INF"]isEqualToString:@"交易成功"]) {
                HisuntechPaySucceedController *succeed = [[HisuntechPaySucceedController alloc]init];
                succeed.payNumStr = _money;
                [self.navigationController pushViewController:succeed animated:YES];
            }
            else
            {
                HisuntechPayFailedViewController *failed = [[HisuntechPayFailedViewController alloc]init];
                [self.navigationController pushViewController:failed animated:YES];
            }
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
        return;
    }
    //捡起订单 -- 快捷支付
    else if (codeType == 14)
    {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] )
        {
            [_alertView removeFromSuperview];
            if ([[[dictJson objectForKey:@"GWA"] objectForKey:@"MSG_INF"]isEqualToString:@"交易成功"]) {
                HisuntechPaySucceedController *succeed = [[HisuntechPaySucceedController alloc]init];
                succeed.payNumStr = _money;
                [self.navigationController pushViewController:succeed animated:YES];
            }
            else
            {
                HisuntechPayFailedViewController *failed = [[HisuntechPayFailedViewController alloc]init];
                [self.navigationController pushViewController:failed animated:YES];
            }
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
    }
    else if (codeType == 15) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] )
        {
            [self selectBindBankCard];
            [HisuntechUserEntity Instance].drwBal = [dictJson objectForKey:@"CURACBAL"];//账户余额
            balance = [[HisuntechUserEntity Instance].drwBal floatValue];
            if ([[HisuntechUserEntity Instance].ACTION isEqualToString:@"PAY_AGAIN"]) {
                NSString *serverTime = [dictJson objectForKey:@"SERTM"];//服务器时间
                NSString *balance1 = [dictJson objectForKey:@"DRW_BAL"];//账户余额
                NSString *userName = [dictJson objectForKey:@"USRCNM"];//用户真实姓名
                NSString *phoneNum = [dictJson objectForKey:@"MBLNO"];//用户手机号
                NSString *realName = [dictJson objectForKey:@"RELFLG"];//实名认证状态
                [HisuntechUserEntity Instance].userNo = [dictJson objectForKey:@"USRNO"];
                [HisuntechUserEntity Instance].drwBal = [dictJson objectForKey:@"DRW_BAL"];
                [HisuntechUserEntity Instance].userNm = [dictJson objectForKey:@"USRCNM"];//用户真实姓名
                [HisuntechUserEntity Instance].userId = [dictJson objectForKey:@"MBLNO"];//用户手机号
                [HisuntechUserEntity Instance].relFlg = [dictJson objectForKey:@"RELFLG"];//实名认证状态
                NSString *userNo = [dictJson objectForKey:@"USRNO"];//内部用户号
                NSString *changeDate = [dictJson objectForKey:@"MAX_CHARGE_DT"];//资金变动时间
                self.dic = @{@"SERTM": serverTime,@"DRW_BAL":balance1,@"USRCNM":userName,@"MBLNO":phoneNum,@"RELFLG":realName,@"USRNO":userNo,@"MAX_CHARGE_DT":changeDate,@"USRID":[HisuntechUserEntity Instance].userId};
            }
        }
    }
    //校验支付密码
   else if (codeType == 57) {
       if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] )
       {
           if ([_payAction isEqualToString:@"PAY_AGAIN"])
           {
               if (isClick&&!debitClick&&!creditClick) {
                   [self pickOrderAccountPay];
               }
               else
               {
                   [self PickOrderQuickCardPay];
               }
  
           }
           else if([_payAction isEqualToString:@"MER_PAY"])
           {
               if (isClick&&!debitClick&&!creditClick) {
                   [self AccountPay];
               }
               else
               {
                   [self quickPay];
               }
           }
       }else{
           [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
       }
       return;
    }
}
/**
 *  请求服务器失败
 */
-(void)resquestFail:(id)response{
    if (codeType==10) {
        [self toastResult:@"请检查您当前网络"];
        return;
    }
    if (codeType == 4||codeType == 57||codeType == 7||codeType == 11) {
        [self PayAlertView:nil message:@"网络不给力,请检查当前网络" cancelBtn:@"取消" otherBtn:@"重新连接"];
    }
}
/**
 *  dialog提示框
 *
 *  @param toastMsg 提示内容
 */
-(void)toastResult:(NSString *) toastMsg{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:toastMsg
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}
#pragma mark 确认支付响应
-(void)makeSureToPayWith:(NSDictionary*)quickBank and:(NSArray*)redPocketArr and:(NSDictionary*)voucherDic
{
    NSLog(@"现在选择的代金券，红包，银行卡信息：\n");
    NSLog(@"代金券：%@\n",voucherDic);
    NSLog(@"红包：%@\n",redPocketArr);
    NSLog(@"银行卡：%@\n",quickBank);
}
#pragma mark 添加银行卡
-(void)goToAddCard:(UIButton*)btn
{
    int bankType = (int)btn.tag/1000;
    if (bankType == 6) {
        HisuntechAddCreditCardController *addCre = [[HisuntechAddCreditCardController alloc]init];
        addCre.delegate = self;
        [self.navigationController pushViewController:addCre animated:YES];
    }
    else
    {
        HisuntechAddDebitCardController *addDebit = [[HisuntechAddDebitCardController alloc]init];
        addDebit.delegate = self;
        [self.navigationController pushViewController:addDebit animated:YES];
    }
}
-(void)passValue:(NSDictionary *)value
{
    NSLog(@"%@",value);
    UIButton *temp = [UIButton buttonWithType:UIButtonTypeCustom];
    temp.tag = 5000;
    //[self chooseBank:temp];
}
#pragma mark 银行卡选择响应事件
-(void)chooseBank:(UIButton*)btn
{
    int indexOfBankArr = btn.tag%10;
    int bankType = (int)btn.tag/1000;
    
    switch (rowNum) {
        case 7:
        {
            if (bankType == 5) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:3 inSection:0];
                heightOfCell = 50;
                isDebitOpen = NO;
                [self.mixPaytableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else
            {
                NSIndexPath *path = [NSIndexPath indexPathForRow:4 inSection:0];
                heightOfCell = 50;
                isCreditOpen = NO;
                [self.mixPaytableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;
        }
        default:
            break;
    }
    if (bankType == 5) {
        quickBankChoosed =debitArr[indexOfBankArr];
    }
    else
    {
        quickBankChoosed = creditArr[indexOfBankArr];
    }
    NSLog(@"%d,%d",bankType,indexOfBankArr);
    NSLog(@"balance:%f",balance);
    if (balance>=[_money floatValue] - voucherMoney - redPockMoney) {
        if (isClick) {
            [self onAccountClick:nil];
        }
        quickPay.QuickMoney.text = [NSString stringWithFormat:@"￥%.2f",[_money floatValue] - redPockMoney - voucherMoney];
            switch (bankType) {
            case 5:
            {
                if (!debitClick) {
                    debitClick = YES;
                    debit.btnSelect.selected = YES;
                }
                if (creditClick) {
                    creditClick = NO;
                    credit.btnSelect.selected = NO;
                    credit.creditNum.text = nil;
                }
                
                NSString *tempCrdNum =[debitArr[indexOfBankArr]objectForKey:@"CAP_CRD_NO"];
                int index = tempCrdNum.length -4;
                crdNum = [[debitArr[indexOfBankArr]objectForKey:@"CAP_CRD_NO"] substringFromIndex:index];
                
                debit.debitNum.text = [NSString stringWithFormat:@"(%@)",crdNum];
                break;
            }
            case 6:
            {
                if (!creditClick) {
                    creditClick = YES;
                    credit.btnSelect.selected = YES;
                }
                if (debitClick) {
                    debitClick = NO;
                    debit.btnSelect.selected = NO;
                    debit.debitNum.text = nil;
                }
                NSString *tempCrdNum =[creditArr[indexOfBankArr]objectForKey:@"CAP_CRD_NO"];
                int index = tempCrdNum.length -4;
                crdNum = [[creditArr[indexOfBankArr]objectForKey:@"CAP_CRD_NO"] substringFromIndex:index];
                credit.creditNum.text = [NSString stringWithFormat:@"(%@)",crdNum];
                break;
            }
            default:
                break;
        }
    }
    
    else
    {
        NSLog(@"asd");
        if (isClick) {
            quickPay.QuickMoney.text = [NSString stringWithFormat:@"￥%.2f",[_money floatValue]-balance - redPockMoney - voucherMoney];
        }
        else
        {
            quickPay.QuickMoney.text = [NSString stringWithFormat:@"￥%.2f",[_money floatValue]- redPockMoney - voucherMoney];
        }
        switch (bankType) {
            case 5:
            {
                if (!debitClick) {
                    debitClick = YES;
                    debit.btnSelect.selected = YES;
                }
                if (creditClick) {
                    creditClick = NO;
                    credit.btnSelect.selected = NO;
                    credit.creditNum.text = nil;
                }
                NSString *tempCrdNum =[debitArr[indexOfBankArr]objectForKey:@"CAP_CRD_NO"];
                int index = tempCrdNum.length -4;
                crdNum = [[debitArr[indexOfBankArr]objectForKey:@"CAP_CRD_NO"] substringFromIndex:index];
                debit.debitNum.text = [NSString stringWithFormat:@"(%@)",crdNum];
                break;
            }
            case 6:
            {
                if (!creditClick) {
                    creditClick = YES;
                    credit.btnSelect.selected = YES;
                }
                if (debitClick) {
                    debitClick = NO;
                    debit.btnSelect.selected = NO;
                    debit.debitNum.text = nil;
                }
                NSString *tempCrdNum =[creditArr[indexOfBankArr]objectForKey:@"CAP_CRD_NO"];
                int index = tempCrdNum.length -4;
                crdNum = [[creditArr[indexOfBankArr]objectForKey:@"CAP_CRD_NO"] substringFromIndex:index];
                credit.creditNum.text = [NSString stringWithFormat:@"(%@)",crdNum];
                break;
            }
            default:
                break;
        }
    }
    NSLog(@"%d,%@",bankType,quickBankChoosed);
}

#pragma mark 勾选银联支付
- (void)onBankClick:(UIButton *)sender{
    if (!isBankClick) {
        bankPay.btnSelect.selected = YES;
        isBankClick = !isBankClick;
    }
    else
    {
        bankPay.btnSelect.selected = NO;
        isBankClick = !isBankClick;
    }
    
    if (creditClick||debitClick||isClick) {
        
        debit.btnSelect.selected = NO;
        debit.debitNum.text = nil;
        debitClick = NO;
            
        credit.btnSelect.selected = NO;
        credit.creditNum.text = nil;
        creditClick = NO;
        
        account.btnSelect.selected = NO;
        account.AccountMoney.text = @"账户余额:";
        account.AccountPay.text = [NSString stringWithFormat:@"￥%.2f",[[HisuntechUserEntity Instance].drwBal floatValue]];
        
        quickPay.QuickMoney.text = nil;
        quickBankChoosed = @{};
        
    }
}
#pragma mark 勾选框点击事件
/**
 *  账户勾选框点击事件
 */
-(void)onAccountClick:(id)sender {
    if (!isClick) {
        account.btnSelect.selected = YES;
        account.AccountMoney.text = @"账户支付:";
        if (balance >= [_money floatValue] - redPockMoney - voucherMoney)
        {
           account.AccountPay.text = [NSString stringWithFormat:@"￥%.2f",[_money floatValue] - redPockMoney - voucherMoney];
        }
        else
        {
            account.AccountPay.text = [NSString stringWithFormat:@"￥%.2f",balance];
        }
        isClick = !isClick;
    }
    else
    {
        account.btnSelect.selected = NO;
        account.AccountMoney.text = @"账户余额:";
        account.AccountPay.text = [NSString stringWithFormat:@"￥%.2f",[[HisuntechUserEntity Instance].drwBal floatValue]];
        isClick = !isClick;
        NSLog(@"%d,%d",creditClick,debitClick);
        if (creditClick||debitClick) {
            NSLog(@"执行");
            quickPay.QuickMoney.text = [NSString stringWithFormat:@"￥%.2f",[_money floatValue] - redPockMoney -voucherMoney];
        }
    }
    
    if (creditClick||debitClick||isBankClick) {
        if (balance >= [_money floatValue] - redPockMoney - voucherMoney) {
            debit.btnSelect.selected = NO;
            debit.debitNum.text = nil;
            debitClick = NO;
            
            credit.btnSelect.selected = NO;
            credit.creditNum.text = nil;
            creditClick = NO;
            
            bankPay.btnSelect.selected = NO;
            isBankClick = NO;
            
            quickPay.QuickMoney.text = nil;
            
            quickBankChoosed = @{};
        }
        else
        {
            if (isClick) {
                quickPay.QuickMoney.text = [NSString stringWithFormat:@"￥%.2f",[_money floatValue] - balance - redPockMoney -voucherMoney];
            }
            
        }
        
    }

}
/**
 * 借记卡和信用卡同时只能有一个选择方案
 */
/**
 *  借记卡勾选框点击事件
 */
-(void)onDebitClick:(id)sender {
    if (debitClick) {
        debit.btnSelect.selected = NO;
        debit.debitNum.text = nil;
        debitClick = NO;
        quickPay.QuickMoney.text = nil;
    }
    quickBankChoosed = @{};
    
}
/**
 *  信用卡勾选框点击事件
 */
-(void)onCreditClick:(id)sender {
    if (creditClick) {
        credit.btnSelect.selected = NO;
        credit.creditNum.text = nil;
        creditClick = NO;
        quickPay.QuickMoney.text = nil;
    }
    quickBankChoosed = @{};
}

#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rowNum;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 85.0;
    else if (indexPath.row == cellNum)
        return heightOfCell;
    else
        return 50;
}
#pragma mark 实例化cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        HisuntechOrderMoneyCell *cell = (HisuntechOrderMoneyCell *)[tableView dequeueReusableCellWithIdentifier:@"OrderMoneyCell"];
        if (cell == nil)
        {
            cell = [[HisuntechOrderMoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderMoneyCell"];
        }
        order = cell;
        cell.tag = 500;
        //cell.orderMoney.text = [NSString stringWithFormat:@"￥%@.00",_money];
        cell.orderMoney.text = [NSString stringWithFormat:@"￥%.2f",[_money floatValue]];
        //设置cell点击没有选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //设置cell不可以点击
        cell.userInteractionEnabled = NO;
        return cell;
    }
    if (indexPath.row == 1)
    {
        HisuntechAccountPayCell *cell = (HisuntechAccountPayCell *)[tableView dequeueReusableCellWithIdentifier:@"AccountPayCell"];
        //判断单元格是否为空
        if (cell == nil)
        {
            cell = [[HisuntechAccountPayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountPayCell"];
        }
        account = cell;
        cell.tag = 1000;
        cell.AccountPay.text = [NSString stringWithFormat:@"￥%.2f",[[HisuntechUserEntity Instance].drwBal floatValue]];
        
        //账户勾选框按钮
        [cell.btnSelect addTarget:self action:@selector(onAccountClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 2)
    {
                HisuntechQuickPayMoneyCell *cell = (HisuntechQuickPayMoneyCell *)[tableView dequeueReusableCellWithIdentifier:@"QuickPayMoneyCell"];
                //判断单元格是否为空
                if (cell == nil)
                {
                    cell = [[HisuntechQuickPayMoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuickPayMoneyCell"];
                }
                quickPay = cell;
                cell.tag = 4000;
                //设置cell点击没有选中效果
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //设置cell不可以点击
                cell.userInteractionEnabled = NO;
                return cell;
            }
            if (indexPath.row == 6)
            {
                HisuntechSurePayCell *cell = (HisuntechSurePayCell *)[tableView dequeueReusableCellWithIdentifier:@"SurePayCell"];
                if (cell == nil)
                {
                    cell = [[HisuntechSurePayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SurePayCell"];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.surePay.userInteractionEnabled = NO;
                return cell;
            }
            if (indexPath.row == 3)
            {
                HisuntechQuickDebitPayViewCell *cell = (HisuntechQuickDebitPayViewCell*)[tableView dequeueReusableCellWithIdentifier:@"QuickDebitCell"];
                if (!cell)
                {
                    cell = [[HisuntechQuickDebitPayViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuickDebitCell"];
                }
                debit = cell;
                cell.bankView.frame = CGRectMake(0, 50, 320, 50+50*debitArr.count);
                cell.debitPay.text = @"借记卡支付";
                for (int i = 0; i <=debitArr.count; i++)
                {
                    if (i == debitArr.count)
                    {
                        HisuntechAddView * add = [[HisuntechAddView alloc]initWithFrame:CGRectMake(0, 50*i, 320, 50)];
                        [add.text setTitle:@"添加借记卡" forState:UIControlStateNormal];
                        add.text.tag = 5000+i;
                        [add.text addTarget:self action:@selector(goToAddCard:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.bankView addSubview:add];
                        break;
                    }
                    HisuntechBankCellView *bank = [[HisuntechBankCellView alloc]initWithFrame:CGRectMake(0, 50*i, 320, 50)];
                    NSString *BNKNO = [debitArr[i]objectForKey:@"QUICK_BNK_NO"];
                    NSString *tempStr =[debitArr[i]objectForKey:@"CAP_CRD_NO"];
                    int index = tempStr.length -4;
                    NSString *crdNo = [[debitArr[i]objectForKey:@"CAP_CRD_NO"] substringFromIndex:index];
                    [bank.bankLogo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",URL,[BNKNO lowercaseString]]]];
                    bank.bankName.text = [HisuntechConvert convertBankAbbreviationToBankChinese:[BNKNO substringFromIndex:3]];
                    bank.cardNo.text = [NSString stringWithFormat:@"(%@)",crdNo];
                    bank.clickBtn.tag = 5000+i;
                    [bank.clickBtn addTarget:self action:@selector(chooseBank:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.bankView addSubview:bank];
                }
                cell.tag = 5000;
                [cell.btnSelect addTarget:self action:@selector(onDebitClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            if (indexPath.row == 4)
            {
                HisuntechQuickCreditPayViewCell *cell = (HisuntechQuickCreditPayViewCell*)[tableView dequeueReusableCellWithIdentifier:@"QuickCreditPayCell"];
                if (!cell)
                {
                    cell = [[HisuntechQuickCreditPayViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuickCreditPayCell"];
                }
                credit = cell;
                cell.bankView.frame = CGRectMake(0, 50, 320, 50+50*creditArr.count);
                cell.creditPay.text = @"信用卡支付";
                for (int i = 0; i <=creditArr.count; i++)
                {
                    if (i == creditArr.count)
                    {
                        HisuntechAddView * add = [[HisuntechAddView alloc]initWithFrame:CGRectMake(0, 50*i, 320, 50)];
                        [add.text setTitle:@"添加信用卡" forState:UIControlStateNormal];
                        add.text.tag = 6000+i;
                        
                        [add.text addTarget:self action:@selector(goToAddCard:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.bankView addSubview:add];
                        break;
                    }
                    HisuntechBankCellView *bank = [[HisuntechBankCellView alloc]initWithFrame:CGRectMake(0, 50*i, 320, 50)];
                    NSString *BNKNO = [creditArr[i]objectForKey:@"BNKNO"];
                    NSString *crdNo = [[creditArr[i]objectForKey:@"CRDNOLAST"] substringFromIndex:12];
                    [bank.bankLogo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",URL,[BNKNO lowercaseString]]]];
                    bank.bankName.text = [HisuntechConvert convertBankAbbreviationToBankChinese:BNKNO];
                    bank.cardNo.text = [NSString stringWithFormat:@"(%@)",crdNo];
                    bank.clickBtn.tag = 6000+i;
                    [bank.clickBtn addTarget:self action:@selector(chooseBank:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.bankView addSubview:bank];
                }
                cell.tag = 6000;
                [cell.btnSelect addTarget:self action:@selector(onCreditClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else{
                HisuntechBankPayViewCell *cell = (HisuntechBankPayViewCell*)[tableView dequeueReusableCellWithIdentifier:@"QuickBankPayCell"];
                if (!cell)
                {
                    cell = [[HisuntechBankPayViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuickBankPayCell"];
                }
                cell.AccountPay.text = @"银联支付";
                bankPay = cell;
                cell.cellIcon.image = [UIImage imageNamed:@"bg_checkbox_yinlian"];
                cell.tag = 7000;
                //银联支付勾选框按钮
                [cell.btnSelect addTarget:self action:@selector(onBankClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
            }
}
#pragma mark cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *Path = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
            if (indexPath.row == 3)
            {
                if (!isDebitOpen)
                {
                    isDebitOpen = YES;
                    if (isCreditOpen)
                    {
                        isCreditOpen = NO;
                    }
                    heightOfCell = 100 + 50*debitArr.count;
                }
                else
                {
                    heightOfCell = 50;
                    isDebitOpen = NO;
                }
                cellNum = indexPath.row;
                [NSIndexPath indexPathForItem:5 inSection:0];
                [self.mixPaytableView reloadRowsAtIndexPaths:@[Path] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                if (debitClick)
                {
                    debit.btnSelect.selected = YES;
                    debit.debitNum.text = [NSString stringWithFormat:@"(%@)",crdNum];
                }
                else
                {
                    debit.btnSelect.selected = NO;
                    debit.debitNum.text = nil;
                }
                NSString * imagePath = ResourcePath(@"pull_up_btn@2x.png") ;
                if (isDebitOpen)
                {
                    debit.arrowImageView.image = [UIImage imageWithContentsOfFile:imagePath];
                }
                else
                {
                    imagePath = ResourcePath(@"pull_down_btn@2x.png");
                    debit.arrowImageView.image = [UIImage imageWithContentsOfFile:imagePath];
                }
                if (isCreditOpen)
                {
                    imagePath = ResourcePath(@"pull_up_btn@2x.png");
                    credit.arrowImageView.image = [UIImage imageWithContentsOfFile:imagePath];
                }
                else
                {
                    imagePath = ResourcePath(@"pull_down_btn@2x.png");
                    credit.arrowImageView.image = [UIImage imageWithContentsOfFile:imagePath];
                }
            }
            if (indexPath.row == 4)
            {
                if (!isCreditOpen)
                {
                    isCreditOpen = YES;
                    if (isDebitOpen)
                    {
                        isDebitOpen = NO;
                    }
                    heightOfCell = 100 + 50*creditArr.count;
                }
                else
                {
                    heightOfCell = 50;
                    isCreditOpen = NO;
                }
                cellNum = indexPath.row;
                [self.mixPaytableView reloadRowsAtIndexPaths:@[Path] withRowAnimation:UITableViewRowAnimationAutomatic];
                if (creditClick)
                {
                    credit.btnSelect.selected = YES;
                    credit.creditNum.text = [NSString stringWithFormat:@"(%@)",crdNum];
                }
                else
                {
                    credit.btnSelect.selected = NO;
                    credit.creditNum.text = nil;
                }
                
                NSString * imagePath = ResourcePath(@"pull_up_btn@2x.png") ;
                if (isDebitOpen)
                {
                    debit.arrowImageView.image = [UIImage imageWithContentsOfFile:imagePath];
                }
                else
                {
                    imagePath = ResourcePath(@"pull_down_btn@2x.png");
                    debit.arrowImageView.image = [UIImage imageWithContentsOfFile:imagePath];
                }
                if (isCreditOpen)
                {
                    imagePath = ResourcePath(@"pull_up_btn@2x.png");
                    credit.arrowImageView.image = [UIImage imageWithContentsOfFile:imagePath];
                }
                else
                {
                    imagePath = ResourcePath(@"pull_down_btn@2x.png");
                    credit.arrowImageView.image = [UIImage imageWithContentsOfFile:imagePath];
                }
            }
    if (indexPath.row == 6)
        {
                if (!isClick&&!creditClick&&!debitClick&&!isBankClick)
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请先选择支付方式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        alert.tag = 1111;
                        [alert show];
                }
                else if(isClick&&[_money floatValue]>balance)
                {
                    [self toastResult:@"账户余额不足，请先充值"];
                }
            else
                _alertView = [[HisuntechCustomAlertView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].applicationFrame.size.width - 280)/2, ([UIScreen mainScreen].applicationFrame.size.height-270-64)/2, 280, 270) target:self action:@selector(buttonClick:)];
            [self.view addSubview:_alertView];
        }
    
}

#pragma mark -验证支护密码警示框
- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            _alertView.hidden = YES;
        }];
        [self createCustomerAlert];
    }
    if (button.tag == 1) {
        PasswordTextField *text = (PasswordTextField *)_alertView.text;
        if ([text.text isEqualToString:@""]||text.text == nil) {
            [self toastResult:@"支付密码不能为空"];
            return;
        }
        text.kbdRandom = YES;
        text.encryptionPlatformPublicKey = [HisuntechUserEntity Instance].pubKey;
        
        if ([self isConnectionAvailable]) {
            [self getRandomKey];
        }else
        {
            [self PayAlertView:nil message:@"网络不给力,请检查当前网络" cancelBtn:@"取消" otherBtn:@"重新连接"];
        }
        
        


    }
    if (button.tag == 2) {
        [_alertView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)PayAlertView:(NSString *)titleStr message:(NSString *)messageStr cancelBtn:(NSString *)cancelStr otherBtn:(NSString *)otherStr
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:cancelStr otherButtonTitles:otherStr, nil];
    alert.tag = 300;
    [alert show];
}




#pragma mark 检查网络是否畅通

-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }

    
    return isExistenceNetwork;
}




#pragma mark 点击取消时弹出的警示框
-(void)createCustomerAlert
{
    UIAlertView *cancelAlert = [[UIAlertView alloc] initWithTitle:nil message:@"是否放弃付款?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    cancelAlert.tag = 100;
    [cancelAlert show];
}



#pragma mark -1.获取随机因子
-(void) getRandomKey{
    NSLog(@"执行");
    //上行参数
    NSDictionary *requestDict = [HisuntechBuildJsonString getRandomKeyJsonString];
    //请求服务器 获取公钥
    [self requestServer:requestDict requestType:APP_CODE_RandomKey codeType:4];
}
#pragma mark -2.校验支付密码
- (void)checkPayWord
{
    //NSLog(@"密码 = %@",_password);
    NSDictionary *requestDict = [HisuntechBuildJsonString checkPayPasswordWithUserid:[HisuntechUserEntity Instance].userId userno:[HisuntechUserEntity Instance].userNo payPwd:_password regEmail:@""];
    [self requestServer:requestDict requestType:CheckPayPasswordCode codeType:57];
}



#pragma mark 监听响应方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //记录当前已经改变的数值的中间变量（红包和代金券）
    NSString *str = [NSString stringWithFormat:@"%@",[change objectForKey:@"new"]];
    
    //判断具体是哪个值发生变化
    //红包值发生变化
    if ([keyPath isEqualToString:@"redPocketMoney.text"]) {
           redPockMoney = [[str substringFromIndex:1] floatValue];
    }
    //代金券值发生变化
    else
    {
        voucherMoney =[[str substringFromIndex:1] floatValue];
    }
    
    order.orderMoney.text = [NSString stringWithFormat:@"￥%.2f",[_money floatValue]-voucherMoney - redPockMoney];
    //账户支付勾选时执行 -----改变账户支付金额数
    if (isClick) {
        //余额足够时执行
        if (balance >= [_money floatValue]-redPockMoney -voucherMoney) {
           account.AccountPay.text = [NSString stringWithFormat:@"￥%.2f",[_money floatValue]-voucherMoney - redPockMoney];
        }
        //余额不足时执行
        else
        {
            if ([_money floatValue]-redPockMoney - voucherMoney >balance) {
              account.AccountPay.text = [NSString stringWithFormat:@"￥%.2f",balance];
            }
            else
            {
            account.AccountPay.text = [NSString stringWithFormat:@"￥%.2f",[_money floatValue] - redPockMoney - voucherMoney];
            }
        }
    }
    //改变快捷支付金额 ---余额足够时执行
    if (balance >= [_money floatValue]-redPockMoney -voucherMoney)
    {
        if (creditClick||debitClick)
        {
            quickPay.QuickMoney.text =[NSString stringWithFormat:@"￥%.2f",[_money floatValue]-voucherMoney - redPockMoney];
        }
    }
    //余额不足时执行
    else
    {
        if (creditClick||debitClick)
        {
            //账户支付勾选时执行
            if (isClick) {
                quickPay.QuickMoney.text =[NSString stringWithFormat:@"￥%.2f",[_money floatValue] -balance-voucherMoney - redPockMoney];
            }
            else
            {
                quickPay.QuickMoney.text =[NSString stringWithFormat:@"￥%.2f",[_money floatValue]-voucherMoney - redPockMoney];
            }
        }
    }
    if (isClick&&(creditClick || debitClick)) {
        if (balance+voucherMoney+redPockMoney > [_money floatValue]) {
            debit.btnSelect.selected = NO;
            debit.debitNum.text = nil;
            debitClick = NO;
            
            credit.btnSelect.selected = NO;
            credit.creditNum.text = nil;
            creditClick = NO;
            
            quickPay.QuickMoney.text = nil;
        }
    }
}
#pragma mark 警报框代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1111) {
        return;
    }
    
    if (alertView.tag == 100) {
        switch (buttonIndex) {
            case 0:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    _alertView.hidden = NO;
                }];
            }
                break;
            case 1:
            {
                [_alertView removeFromSuperview];
            }
                break;
            default:
                break;
        }
    }
    
    if (alertView.tag == 300) {
        if ([alertView.message isEqualToString:@"网络不给力,请检查当前网络"]) {
            if (buttonIndex == 1) {
                [self getRandomKey];
            }
        }
    }
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [quickPay removeObserver:quickPay forKeyPath:@"self.QuickMoney"];
}


@end
