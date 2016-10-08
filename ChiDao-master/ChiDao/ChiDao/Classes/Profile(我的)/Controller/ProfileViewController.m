//
//  ProfileViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/5/13.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIScrollView+PullScale.h"
#import "CZAUIView+Gesture.h"
#import "LoginViewController.h"
#import "AccountDetailViewController.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "LoginModel.h"
#import "UIButton+UIButtonImageWithLable.h"
#import "SettingViewController.h"
#import "AddressListViewController.h"
@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //用户昵称
    UILabel *nickLabel;
    
    //手机号
    UILabel *phoneLabel;
    //是否实名
    UIImageView *realImg;
    UILabel *realLabel;
    //用户级别
    UIImageView *rankImg;
    UILabel *rankLabel;
    
    UIButton *loginBtn;
    
    NSString *roleName;
}
@property (nonatomic,strong) UITableView *tb;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tb = [[UITableView alloc] initWithFrame:CGRectMake(0,-44, myScreenWidth,myScreenHeight+44)];
    self.tb.delegate = self;
    self.tb.dataSource = self;
    self.tb.backgroundColor = NavBarColor;
    
    self.tb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tb.separatorColor = NavBarColor;
    
    [self.tb addPullScaleFuncInVC:self originalHeight:180 hasNavBar:(self.navigationController!=nil)];
    self.tb.imageV.image = [UIImage imageNamed:@"2.png"];
    self.tb.imageV.userInteractionEnabled = YES;
    __weak typeof(self) weakSelf = self;
    [self.tb.imageV addTapGesture:^{
        
        [weakSelf loginClick];
        
    }];
    
    UIImageView *personView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"author"]];
    [personView setFrame:CGRectMake((self.tb.imageV.frame.size.width -70)/2, (self.tb.imageV.frame.size.height-70)/2, 70, 70)];

    
    
    [self.tb.imageV addSubview:personView];
    
    
    [self createLoginUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createLoginUI) name:@"CD_updateAccount" object:nil];
    
    [self.view addSubview:self.tb];
    
    
    
    
    
}
// 登录后UI
- (void)createLoginUI{
    if ([APPConfig getInstance].tokenWord) {
        
        LoginModel *loginModel = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"CD_LoginModel"];
        
        if (loginModel.token) {
            
            [loginBtn removeFromSuperview];
            //用户昵称
            nickLabel = [UILabel new];
            nickLabel.text = loginModel.nick_name;
            nickLabel.backgroundColor = [UIColor clearColor];
            nickLabel.font = [UIFont boldSystemFontOfSize:16];
            nickLabel.textColor = [UIColor blackColor];
            nickLabel.textAlignment = NSTextAlignmentCenter;
            [self.tb.imageV addSubview:nickLabel];
            [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.tb.imageV).with.insets(UIEdgeInsetsMake((self.tb.imageV.frame.size.height-70)/2+70, 0, (self.tb.imageV.frame.size.height-110)/2, 0));
            }];
            
            //手机号
            phoneLabel = [UILabel new];
            phoneLabel.text = [Tool hidePhoneNum:loginModel.phone];
            phoneLabel.backgroundColor = [UIColor clearColor];
            phoneLabel.font = [UIFont boldSystemFontOfSize:14];
            phoneLabel.textColor = DetailColor;
            phoneLabel.textAlignment = NSTextAlignmentCenter;
            [self.tb.imageV addSubview:phoneLabel];
            [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo (nickLabel.mas_bottom).offset (5);
                make.left.mas_equalTo (self.tb.imageV.mas_left).offset (5);
                make.right.mas_equalTo (self.tb.imageV.mas_right).offset (-5);
                make.height.mas_equalTo (10);
            }];
            
            
            //是否实名和用户级别
            switch ([loginModel.rank_id intValue]) {
                case 0:
                {
                    roleName = @"普通会员";
                }
                    break;
                case 1:
                {
                    roleName = @"铜牌会员";
                }
                    break;
                case 2:
                {
                    roleName = @"银牌会员";
                }
                    break;
                case 3:
                {
                    roleName = @"金牌会员";
                }
                    break;
                case 4:
                {
                    roleName = @"钻石会员";
                }
                    break;
                case 5:
                {
                    roleName = @"铂金会员";
                }
                    break;
                default:
                    break;
            }
            
            if ([loginModel.is_real_name_auth intValue]==0) {
                //未实名认证
                realImg = [UIImageView new];
                [realImg setImage:[UIImage imageNamed:@"noreal.png"]];
                
                realLabel = [UILabel new];
                realLabel.text = @"未实名认证";
                realLabel.backgroundColor = [UIColor clearColor];
                realLabel.font = [UIFont boldSystemFontOfSize:14];
                realLabel.textColor = DetailColor;
                realLabel.textAlignment = NSTextAlignmentLeft;

                rankImg = [UIImageView new];
                [rankImg setImage:[UIImage imageNamed:@"v.png"]];
                
                rankLabel = [UILabel new];
                rankLabel.text = roleName;
                rankLabel.backgroundColor = [UIColor clearColor];
                rankLabel.font = [UIFont boldSystemFontOfSize:14];
                rankLabel.textColor = DetailColor;
                rankLabel.textAlignment = NSTextAlignmentLeft;
                
                
                [self.tb.imageV addSubview:realLabel];
                [self.tb.imageV addSubview:rankLabel];
                [self.tb.imageV addSubview:realImg];
                [self.tb.imageV addSubview:rankImg];
                
                [realImg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo (phoneLabel.mas_bottom).offset (0);
                    make.left.mas_equalTo (self.tb.imageV.mas_left).offset (70);
                    make.width.mas_equalTo (20);
                    make.height.mas_equalTo (20);
                }];
                
                [realLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo (phoneLabel.mas_bottom).offset (0);
                    make.left.mas_equalTo (realImg.mas_right).offset (0);
                    make.width.mas_equalTo (80);
                    make.height.mas_equalTo (20);
                }];
                
                [rankImg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo (phoneLabel.mas_bottom).offset (0);
                    make.left.mas_equalTo (realLabel.mas_right).offset (0);
                    make.width.mas_equalTo (20);
                    make.height.mas_equalTo (20);
                }];
                
                [rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo (phoneLabel.mas_bottom).offset (0);
                    make.left.mas_equalTo (rankImg.mas_right).offset (0);
                    make.width.mas_equalTo (100);
                    make.height.mas_equalTo (20);
                }];
            }else{
                //未实名认证
                realImg = [UIImageView new];
                [realImg setImage:[UIImage imageNamed:@"real.png"]];
                
                realLabel = [UILabel new];
                realLabel.text = @"实名认证";
                realLabel.backgroundColor = [UIColor clearColor];
                realLabel.font = [UIFont boldSystemFontOfSize:14];
                realLabel.textColor = DetailColor;
                realLabel.textAlignment = NSTextAlignmentLeft;
                
                rankImg = [UIImageView new];
                [rankImg setImage:[UIImage imageNamed:@"v.png"]];
                
                rankLabel = [UILabel new];
                rankLabel.text = roleName;
                rankLabel.backgroundColor = [UIColor clearColor];
                rankLabel.font = [UIFont boldSystemFontOfSize:14];
                rankLabel.textColor = DetailColor;
                rankLabel.textAlignment = NSTextAlignmentLeft;
                
                
                [self.tb.imageV addSubview:realLabel];
                [self.tb.imageV addSubview:rankLabel];
                [self.tb.imageV addSubview:realImg];
                [self.tb.imageV addSubview:rankImg];
                
                [realImg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo (phoneLabel.mas_bottom).offset (0);
                    make.left.mas_equalTo (self.tb.imageV.mas_left).offset (70);
                    make.width.mas_equalTo (20);
                    make.height.mas_equalTo (20);
                }];
                
                [realLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo (phoneLabel.mas_bottom).offset (0);
                    make.left.mas_equalTo (realImg.mas_right).offset (0);
                    make.width.mas_equalTo (80);
                    make.height.mas_equalTo (20);
                }];
                
                [rankImg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo (phoneLabel.mas_bottom).offset (0);
                    make.left.mas_equalTo (realLabel.mas_right).offset (0);
                    make.width.mas_equalTo (20);
                    make.height.mas_equalTo (20);
                }];
                
                [rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo (phoneLabel.mas_bottom).offset (0);
                    make.left.mas_equalTo (rankImg.mas_right).offset (0);
                    make.width.mas_equalTo (100);
                    make.height.mas_equalTo (20);
                }];
            }
            
        }
        
    }else{
        
        [nickLabel removeFromSuperview];
        [phoneLabel removeFromSuperview];
        [realLabel removeFromSuperview];
        [rankLabel removeFromSuperview];
        
        //登录注册
        loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setFrame:CGRectMake((self.tb.imageV.frame.size.width -100)/2, (self.tb.imageV.frame.size.height-70)/2+70, 100, 50)];
        loginBtn.backgroundColor = [UIColor clearColor];
        loginBtn.clipsToBounds = YES;
        [loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        [self.tb.imageV addSubview:loginBtn];
    }
}
- (void)loginClick{
    if ([APPConfig getInstance].tokenWord) {
        //个人信息
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        AccountDetailViewController *adVC = [[AccountDetailViewController alloc] init];
        [self.navigationController pushViewController:adVC animated:YES];
    }else{
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==1) {
        return 4;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
        return 0;
    }else{
        return 20;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = NavBarColor;
    return footerView;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
        {
            cell.imageView.image = [UIImage imageNamed:@"setting_account"];
            cell.textLabel.text = @"我的账户";
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.imageView.image = [UIImage imageNamed:@"setting_message"];
                    cell.textLabel.text = @"我的消息";
                }
                    break;
                case 1:
                {
                    cell.imageView.image = [UIImage imageNamed:@"setting_wallet"];
                    cell.textLabel.text = @"我的卡包";
                }
                    break;
                case 2:
                {
                    cell.imageView.image = [UIImage imageNamed:@"setting_order"];
                    cell.textLabel.text = @"我的订单";
                }
                    break;
                case 3:
                {
                    cell.imageView.image = [UIImage imageNamed:@"setting_address"];
                    cell.textLabel.text = @"地址管理";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            cell.imageView.image = [UIImage imageNamed:@"setting_set"];
            cell.textLabel.text = @"设置";
        }
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
    
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {

        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {

                }
                    break;
                case 1:
                {

                }
                    break;
                case 2:
                {

                }
                    break;
                case 3:
                {

                    [self.navigationController setNavigationBarHidden:NO animated:NO];
                    AddressListViewController *addressVC = [[AddressListViewController alloc] init];
                    addressVC.flag = @"0";
                    [self.navigationController pushViewController:addressVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            SettingViewController *settingVC = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
            
        }
            break;
        default:
            break;
    }
    
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
