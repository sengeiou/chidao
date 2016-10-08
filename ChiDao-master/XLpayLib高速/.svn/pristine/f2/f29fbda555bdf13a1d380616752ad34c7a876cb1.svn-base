//
//  MyViewController.m
//  Demo_1
//
//  Created by allen on 14-9-18.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechLoginController.h"
#import "HisuntechValidateCheck.h"
#import "HisuntechMixPayViewController.h"
#import "HisuntechUserEntity.h"
#import "iSecurity.h"
#import "HisuntechRegisterViewController.h"
#import "HisuntechForgetPasswordViewController.h"
#import "UPPayPlugin.h"
#import "HisunTechTools.h"

@interface HisuntechLoginController ()<UPPayPluginDelegate>
{
    float cellHeight;
    NSMutableArray *userList;
}
@property (nonatomic,retain) PasswordTextField *password;
@end
@implementation HisuntechLoginController
@synthesize orderName,customerName,orderSum,phoneNum,password;
@synthesize loginBt,registerBt,saveAccountBt,doneButton;
@synthesize clientOrder,navigationView;
@synthesize publicKey,randomKey;
@synthesize loginTitle;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
        //userList = [users objectForKey:@"users"];
        userList = [NSMutableArray arrayWithArray:[users objectForKey:@"users"]];
        [users synchronize];
        cellHeight = 50;
        // Custom initialization
        loginTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
        loginTitle.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        loginTitle.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
        loginTitle.textColor = [UIColor whiteColor];  //设置文本颜色
        loginTitle.textAlignment = UITextAlignmentCenter;
        loginTitle.text = @"登 录";  //设置标题
        self.navigationItem.titleView = self.loginTitle;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.password.text.length > 0) {
        self.password.text = nil;
    }
}


- (void)createUI
{
    HisuntechUserEntity *user = [HisuntechUserEntity Instance];
    if ([user.ACTION isEqualToString:@"PAY_AGAIN"]) {
        NSLog(@"pay");
        self.money = user.TOTAL_AMOUNT;
    }
    else if([user.ACTION isEqualToString:@"MER_PAY"])
    {
        NSLog(@"mer");
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:[user.REQ_DATA dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        NSLog(@"temp:%@",tempDic);
        self.money = [tempDic objectForKey:@"total_amount"];
    }
    
    [self setLeftItemToBack];
    self.loginTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, 320, self.view.frame.size.height-64) style:UITableViewStylePlain];
    self.loginTab.delegate = self;
    self.loginTab.dataSource = self;
    [self.view addSubview:self.loginTab];
    self.loginTab.backgroundColor = [UIColor whiteColor];
}
- (void)backPop{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)loginBtClick:(UIButton *)button
{
    //校验手机号
	BOOL checkPhoneNumMsg = [[[HisuntechValidateCheck alloc]init] checkMdn:self.phoneNum.text];
    if (self.phoneNum.text == nil||[@"" isEqual:self.phoneNum.text]) {
        [self toastResult:@"请输入手机号"];
        return;
    }
    if (checkPhoneNumMsg == NO){
        [self toastResult:@"手机号输入有误"];
        return;
    }
    if (self.password.text == nil ||[@"" isEqual:self.password.text]) {
        [self toastResult:@"请输入登录密码"];
        return;
    }
    if([self.password.text length] < 8 || [self.password.text length] > 16){
        [self toastResult:@"密码长度必须8~16位"];
        return;
    }
    [self getPublicKey];//获取公钥
    [phoneNum resignFirstResponder];
	[password resignFirstResponder];
}
- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:241/255.0 blue:245/255.0 alpha:1];
    UIBarButtonItem *navRightBtn = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(signIn)];
    self.navigationItem.rightBarButtonItem = navRightBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [super viewDidLoad];
    [self createUI];
}
-(void)signIn
{
    NSLog(@"注册");
    HisuntechRegisterViewController *rvc = [[HisuntechRegisterViewController alloc]init];
    [self.navigationController pushViewController:rvc animated:YES];
}
#pragma mark -获取公钥
-(void)getPublicKey{
    //上行参数
    NSDictionary *requestDict = [HisuntechBuildJsonString getPublicKeyJsonString];
    //请求服务器 获取公钥
    [self requestServer:requestDict requestType:APP_CODE_PublicKey codeType:1];
}
#pragma mark -获取随机因子
-(void) getRandomKey{
    //上行参数
    NSDictionary *requestDict = [HisuntechBuildJsonString getRandomKeyJsonString];
    //请求服务器 获取公钥
    [self requestServer:requestDict requestType:APP_CODE_RandomKey codeType:4];
}
#pragma mark -登陆
-(void)login{
    //上行参数
    NSDictionary *requestDict = [HisuntechBuildJsonString getLoginJsonString:self.phoneNum.text email:@"" psw:loginPwd];
    //请求服务器 获取公钥
    [self requestServer:requestDict requestType:APP_CODE_UserLogin codeType:9];
}
#pragma mark -请求服务器成功
-(void)resquestSuccess:(id)response{
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    //获取公钥
    if (codeType==1) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
            NSString *newPub = [dictJson objectForKey:@"PUBKEY"];
            [[NSUserDefaults standardUserDefaults]setObject:[dictJson objectForKey:@"PUBKEY"] forKey:@"PUBKEY"];
            NSString *oldPub = [[NSUserDefaults standardUserDefaults]objectForKey:@"PUBKEY"];
            if ([newPub isEqualToString:oldPub]) {
            }else{
                [[NSUserDefaults standardUserDefaults]setObject:[dictJson objectForKey:@"PUBKEY"] forKey:@"PUBKEY"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            [HisuntechUserEntity Instance].pubKey = [dictJson objectForKey:@"PUBKEY"];
            self.password.encryptionPlatformPublicKey = [HisuntechUserEntity Instance].pubKey;
            self.password.kbdRandom = YES;
            self.password.encryptType = E_SDHS_DUAL_PLATFORM;
#pragma mark -获取公钥成功之后获取随机因子
            [self getRandomKey];
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
        return;
    }
    //获取随机因子
    if (codeType == 4) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
            //得到服务器时间之后，进行登录
            loginPwd = [self.password getValue:[NSString stringWithFormat:@"%@000",[dictJson objectForKey:@"SYSTM"]]];
#pragma mark -获取随机因子成功之后进行登陆
            [self login];
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
        return;
    }
    //登录
    if (codeType==9) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
            NSString *serverTime = [dictJson objectForKey:@"SERTM"];//服务器时间
            NSString *balance = [dictJson objectForKey:@"DRW_BAL"];//账户余额
            NSString *userName = [dictJson objectForKey:@"USRCNM"];//用户真实姓名
            NSString *phoneNum = [dictJson objectForKey:@"MBLNO"];//用户手机号
            NSString *realName = [dictJson objectForKey:@"RELFLG"];//实名认证状态
            [HisuntechUserEntity Instance].userId = self.phoneNum.text;
            [HisuntechUserEntity Instance].userNo = [dictJson objectForKey:@"USRNO"];
            [HisuntechUserEntity Instance].drwBal = [dictJson objectForKey:@"DRW_BAL"];
            [HisuntechUserEntity Instance].userNm = [dictJson objectForKey:@"USRCNM"];//用户真实姓名
            [HisuntechUserEntity Instance].userId = [dictJson objectForKey:@"MBLNO"];//用户手机号
            [HisuntechUserEntity Instance].relFlg = [dictJson objectForKey:@"RELFLG"];//实名认证状态
            NSString *userNo = [dictJson objectForKey:@"USRNO"];//内部用户号
            NSString *changeDate = [dictJson objectForKey:@"MAX_CHARGE_DT"];//资金变动时间
            HisuntechMixPayViewController *mixPayViewController = [[HisuntechMixPayViewController alloc] init];
            mixPayViewController.dic = @{@"SERTM": serverTime,@"DRW_BAL":balance,@"USRCNM":userName,@"MBLNO":phoneNum,@"RELFLG":realName,@"USRNO":userNo,@"MAX_CHARGE_DT":changeDate,@"USRID":self.phoneNum.text};
            [self.navigationController pushViewController:mixPayViewController animated:NO];
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            //[[NSUserDefaults standardUserDefaults] setObject:[UserEntity Instance].userId forKey:currentLoginPhoneNumber];
            [def setObject:[HisuntechUserEntity Instance].userNo forKey:@"USRNO"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSDictionary *user = @{@"user":self.phoneNum.text};
            [userList removeAllObjects];
            [userList addObject:user];
            NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
            [users setObject:userList forKey:@"users"];
            [users synchronize];
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
        return;
    }
    if (codeType == 68) {
        
        NSLog(@"下单放回的字典 %@",dictJson);
        
        if ([[dictJson objectForKey:@"RSP_CD"] isEqualToString:@"MCA00000"]) {
            _bankTN = [dictJson objectForKey:@"BANK_TN_NO"];
            
            //调用银联支付
            [UPPayPlugin startPay:_bankTN mode:@"01" viewController:self delegate:self];
            
            
            return;
        } else {
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
        return;
    }
}


#pragma mark 银联支付回调
-(void)UPPayPluginResult:(NSString *)result
{
    [self toastResult:result];
}

/**
 *  请求服务器失败
 */
-(void)resquestFail:(id)response{
    if (codeType==1||codeType==4||codeType==9) {
        [self toastResult:@"请检查您当前网络"];
        return;
    }
}
/**
 *  触摸隐藏输入法
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [phoneNum resignFirstResponder];
    phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    [password resignFirstResponder];
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
#pragma mark 忘记密码
-(void)findPassword
{
    NSLog(@"忘记密码");
    HisuntechForgetPasswordViewController *fpvc = [[HisuntechForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:fpvc animated:YES];
}

#pragma mark 信联支付界面

- (void)payButton{
    NSLog(@"银联支付");
    //签名的网络请求
    NSString *param = [self requestReqData];
    NSString *requestStr = [NSString stringWithFormat:@"%@?srcData=%@",signURL,param];//获取签名
    NSLog(@"requestStr = %@",requestStr);
    NSString *string = [requestStr stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSURL *url = [NSURL URLWithString:string];
    NSLog(@"url = %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSData *requestData =[dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableLeaves error:nil];
    
    
    if (dict && error == nil) {
        //进行下单验签
        _merchantCert = [dict objectForKeyedSubscript:@"merchant_cert"];
        _signData = [dict objectForKeyedSubscript:@"sign_data"];
        NSLog(@"签名返回字典%@",dict);
        [self postDownloadFromUrl];//下单验签
        
    }else if (dict == nil && error == nil)
    {
        [self alertViewWithStr:@"签名请求成功没有返回值!!!!!!!" andContentStr:nil];
    }else if (error)
    {
        [self alertViewWithStr:@"请求失败" andContentStr:[NSString stringWithFormat:@"%@",error]];
    }
}

//测试方便观看 可删
-(void)alertViewWithStr:(NSString *)str andContentStr:(NSString *)strSecond
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:strSecond delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
    [alert show];
}




//MARK:下单验签
- (void)postDownloadFromUrl {
    
    NSLog(@"req_data = %@",[self requestReqData]);
    NSLog(@"req_cert = %@",_merchantCert);
    NSLog(@"req_sign = %@",_signData);
    //上行参数
    NSDictionary *requestDict = [HisuntechBuildJsonString getBankPayWithCharset:@"00" req_data:[self requestReqData] req_cert:_merchantCert req_sign:_signData sign_type:@"RSA"];
    NSLog(@"下单上传参数 requestDict = %@",requestDict);
    [self requestServer:requestDict requestType:APP_CODE_MakeOrder codeType:68];
}

//MARK:拼接字典
- (NSDictionary *)buildMessage:(NSArray *)Key value:(NSArray *)Value
{
    if (Key == nil||([Key count] == 0)) {
        return nil;
    }
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
    
    if(Key != nil){
        for (int i=0;i<[Key count];i++ ) {
            [tmp setValue:[Value objectAtIndex:i] forKey:[Key objectAtIndex:i]];
            
        }
    }
    
    return tmp;
}

#pragma mark 账户选择响应事件
-(void)chooseUser:(UIButton*)btn
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    cellHeight= 50;
    [self.loginTab reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    self.openBtn.selected = NO;
    
    self.phoneNum.text = [userList[btn.tag] objectForKey:@"user"];
    self.password.text = [userList[btn.tag] objectForKey:@"password"];
}
#pragma mark 打开抽屉
-(void)openUserLists
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    self.openBtn.selected = !self.openBtn.selected;
    NSLog(@"%d",self.openBtn.selected);
    if (self.openBtn.selected) {
        cellHeight = 50 + userList.count *50;
        [self.loginTab reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.openBtn.selected = YES;
    }
    else
    {
        cellHeight= 50;
        [self.loginTab reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.openBtn.selected = NO;
    }
    
}
#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return cellHeight;
    }
    if (indexPath.row == 2) {
        return self.view.frame.size.height - 100;
    }
    else
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loginCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loginCell"];
    }
    for (id temp in cell.contentView.subviews) {
        [temp removeFromSuperview];
    }
    if (indexPath.row == 0) {
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 15, 20)];
        NSString * imagePath = ResourcePath(@"username_ic.png") ;
        icon.image = [UIImage imageWithContentsOfFile:imagePath];
        [cell.contentView addSubview:icon];
        
        self.phoneNum = [[UITextField alloc]initWithFrame:CGRectMake(55, 0, 220, 50)];
        self.phoneNum.placeholder = @"请输入登陆账号";
        if (userList.count) {
            self.phoneNum.text = [userList[userList.count -1] objectForKey:@"user"];
        }
        self.phoneNum.clearButtonMode = YES;
        self.phoneNum.keyboardType = UIKeyboardTypeNumberPad;
        [cell.contentView addSubview:self.phoneNum];
        
        self.openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.openBtn.frame = CGRectMake(289, 20, 14, 8);
        imagePath = ResourcePath(@"pull_down_btn@2x.png");
        [self.openBtn setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
        imagePath = ResourcePath(@"pull_up_btn@2x.png");
        [self.openBtn setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateSelected];
        [self.openBtn addTarget:self action:@selector(openUserLists) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:self.openBtn];
        for (int i = 0; i< userList.count; i++) {
            UILabel *userLab = [[UILabel alloc]initWithFrame: CGRectMake(55, 50+i, 220, 50)];
            userLab.textColor =[UIColor colorWithRed:0.741 green:0.738 blue:0.785 alpha:1.000];
            userLab.text =[userList[i] objectForKey:@"user"];
            
            UIButton *btn = [UIButton
                              buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(55, 50+i, 220, 50);
            [btn addTarget:self action:@selector(chooseUser:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [cell.contentView addSubview:userLab];
            [cell.contentView addSubview:btn];
        }
    }
    if (indexPath.row == 1) {
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 15, 20)];
        NSString * imagePath = ResourcePath(@"password_ic@2x.png") ;
        icon.image = [UIImage imageWithContentsOfFile:imagePath];
        [cell.contentView addSubview:icon];
        
        self.password = [[PasswordTextField alloc]initWithFrame:CGRectMake(55, 0, 167, 50)usingPasswordKeyboard:YES];
        self.password.placeholder = @"请输入密码";
        [cell.contentView addSubview:self.password];
    }
    if (indexPath.row == 2) {
        cell.backgroundColor =[UIColor colorWithRed:235/255.0 green:241/255.0 blue:245/255.0 alpha:1];
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        loginBtn.frame = CGRectMake(10, 40, 300, 40);
        NSString * imagePath = ResourcePath(@"login_btn_n.9@2x.png") ;
        [loginBtn setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
        [loginBtn setTitle:@"用户登录" forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(loginBtClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:loginBtn];
        
        //64 165 231
        UILabel *find = [[UILabel alloc]initWithFrame:CGRectMake(200, 80, 110, 40)];
        find.textColor = [UIColor colorWithRed:64/255.0 green:165/255.0 blue:231/255.0 alpha:1];
        find.text = @"忘记密码?";
        find.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:find];
        
        UILabel *payLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 110, 40)];
        payLabel.textColor = [UIColor colorWithRed:64/255.0 green:165/255.0 blue:231/255.0 alpha:1];
        payLabel.text = @"银联支付";
        payLabel.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:payLabel];
        
        UIButton *findPassword = [UIButton buttonWithType:UIButtonTypeSystem];
        findPassword.frame = CGRectMake(200, 80, 120, 40);
        
        [findPassword addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:findPassword];
        
        UIButton *payButton = [UIButton buttonWithType:UIButtonTypeSystem];
        payButton.frame = CGRectMake(10, 80, 120, 40);
        
        [payButton addTarget:self action:@selector(payButton) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:payButton];
        
    }
    cell.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark MARK:签名上传数据
- (NSString *)requestReqData
{
    float floatString = [self.money floatValue];
    int intString = floatString*100;
    NSString *priceString = [NSString stringWithFormat:@"%d",intString];
    
    //获得签名值需要的参数
    NSString *version_no = @"1.0";
    NSString *service = @"OrderPayment";
    NSString *notify_url = @"http://192.168.0.241:8080/rsademo/notify.jsp";
    NSString *exter_invoke_ip = [HisunTechTools localWiFiIPAddress];
    NSString *req_id = @"8000755000100071425287033426";
    NSString *user_id = @"";
    NSString *mer_id = @"800010000010003";  //800010000010003
    NSString *mer_name = @"1234";
    NSString *order_id = [self generateTradeNO];
    NSString *order_time = @"20150302050353";
    NSString *total_amount = priceString;//分
    NSString *currency = @"CNY";
    NSString *valid_unit = @"02";
    NSString *valid_num = @"1";
    NSString *show_url = @"http://192.168.0.241:8080/rsademo/test.html";
    NSString *product_desc = @"test";
    NSString *voucher_use_flag = @"00";
    NSString *back_param = @"I_come_back";
    NSArray *signArr = @[version_no,
                         service,
                         notify_url,
                         exter_invoke_ip,
                         req_id,
                         user_id,
                         mer_id,
                         mer_name,
                         order_id,
                         order_time,
                         total_amount,
                         currency,
                         valid_unit,
                         valid_num,
                         show_url,
                         product_desc,
                         voucher_use_flag,
                         back_param];
    
    NSString *jsonStr = [[NSString alloc]initWithFormat:@"{\"version\":\"1.0\",\"service\":\"ADDirectPayment\",\"notify_url\":\"http://192.168.0.241:8080/rsademo/notify.jsp\",\"exter_invoke_ip\":\"%@\",\"req_id\":\"1433752568448\",\"user_id\":\"\",\"mer_id\":\"800075500050002\",\"mer_name\":\"%@\",\"order_id\":\"%@\",\"order_time\":\"20150302050353\",\"total_amount\":\"%@\",\"currency\":\"CNY\",\"valid_unit\":\"02\",\"valid_num\":\"1\",\"show_url\":\"http://192.168.0.241:8080/rsademo/test.html\",\"product_desc\":\"test\",\"voucher_use_flag\":\"00\",\"back_param\":\"I_come_back\"}",exter_invoke_ip,mer_name,order_id,total_amount];
    
    return jsonStr;
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
