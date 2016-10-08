//
//  AccountDetailViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/7/15.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "AccountDetailViewController.h"
#import "LoginModel.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "UpdateNickNameViewController.h"
#import "UIImageView+WebCache.h"
#import "XWImagePicker.h"
#import "CZAUIView+Gesture.h"

@interface AccountDetailViewController ()<UITableViewDataSource,UITableViewDelegate,updateNickNameDelegate>
{
    LoginModel *loginModel;
    NSIndexPath *nickPath;
}
@property (nonatomic,strong) UITableView *tb;
@property (nonatomic,strong) UIImageView *userView;
@end

@implementation AccountDetailViewController

- (void)addNavButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
}
-(void)doBack
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    loginModel = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"CD_LoginModel"];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的信息";
    self.view.backgroundColor = NavBarColor;
    
    [self addNavButton];
    
    self.tb = [[UITableView alloc] initWithFrame:CGRectMake(0,0, myScreenWidth,myScreenHeight)];
    self.tb.delegate = self;
    self.tb.dataSource = self;
    self.tb.backgroundColor = NavBarColor;

    //头像view
    
    self.tb.tableHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2"]];
    self.tb.tableHeaderView.userInteractionEnabled = YES;
    self.userView = [UIImageView new];
    CGFloat w = 100.0f; CGFloat h = w;
    self.userView.frame =CGRectMake((self.tb.tableHeaderView.frame.size.width-w)/2, (self.tb.tableHeaderView.frame.size.height-w)/2, w, h);
    [self.userView.layer setCornerRadius:(self.userView.frame.size.height/2)];
    [self.userView.layer setMasksToBounds:YES];
    [self.userView setContentMode:UIViewContentModeScaleAspectFill];
    [self.userView setClipsToBounds:YES];
    self.userView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.userView.layer.shadowOffset = CGSizeMake(4, 4);
    self.userView.layer.shadowOpacity = 0.5;
    self.userView.layer.shadowRadius = 2.0;
    self.userView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] CGColor];
    self.userView.layer.borderWidth = 2.0f;
    self.userView.userInteractionEnabled = YES;
    self.userView.backgroundColor = [UIColor colorWithRed:0/255.0 green:186/255.0 blue:182/255.0 alpha:1];
    
    if ([loginModel.portrait_url isEqualToString:@""]) {
        self.userView.image = [UIImage imageNamed:@"author"];
    }else{
        [self.userView sd_setImageWithURL:[NSURL URLWithString:loginModel.portrait_url] placeholderImage:[UIImage imageNamed:@"author"]];
    }
    __weak typeof(self) weakSelf = self;
    [self.userView addTapGesture:^{
       //头像选择
        [[XWImagePicker shareInstance] showWithController:weakSelf finished:^(UIImage *image) {
            weakSelf.userView.image = image;
        } animated:YES];
        
    }];
    [self.tb.tableHeaderView addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tb.tableHeaderView).with.insets(UIEdgeInsetsMake((self.tb.tableHeaderView.frame.size.height-100)/2, (self.tb.tableHeaderView.frame.size.width-100)/2, (self.tb.tableHeaderView.frame.size.height-100)/2, (self.tb.tableHeaderView.frame.size.width-100)/2));
    }];
    
    
    self.tb.separatorColor = NavBarColor;
    
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setFrame:CGRectMake(0, 0, 100, 50)];
    logoutBtn.backgroundColor = btnColor;
    logoutBtn.layer.cornerRadius = myCornerRadius;
    logoutBtn.clipsToBounds = YES;
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];

    self.tb.tableFooterView = logoutBtn;
    
    
    
    [self.view addSubview:self.tb];
}

- (void)logoutClick{
    
    NSURLSessionDataTask *task = [[NewsClient sharedClient] logout:LogoutURL withToken:[APPConfig getInstance].tokenWord completion:^(NSMutableDictionary *dic, NSError *error) {
        
        if (!error) {
            
            if ([[dic objectForKey:@"code"] isEqualToString:@"000000"]) {
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tokenword"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CD_updateAccount" object:nil];
                [self doBack];
                [Tool showMessage:@"退出登录成功"];
                
            }else if([[dic objectForKey:@"code"] isEqualToString:@"011038"]){
                
                [Tool showMessage:@"token值无效"];
                
            }else if([[dic objectForKey:@"code"] isEqualToString:@"010000"]){
                
                [Tool showMessage:@"系统错误"];
            }else{
                [Tool showMessage:[dic objectForKey:@"desc"]];
            }
            
        }
        
    }];
    [task resume];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        return 3;
    }else{
        return 2;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 20;
    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"账号";
                    cell.detailTextLabel.text = [Tool hidePhoneNum:loginModel.phone];
                }
                    break;
                case 1:
                {
                    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text = @"昵称";
                    cell.detailTextLabel.text = loginModel.nick_name;
                    nickPath = indexPath;
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = @"身份信息";
                    if ([loginModel.is_real_name_auth intValue]==0) {
                        cell.detailTextLabel.text = @"未实名";
                    }else{
                        cell.detailTextLabel.text = @"已实名";
                    }
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                
                    cell.textLabel.text = @"会员特权";
                    switch ([loginModel.rank_id intValue]) {
                        case 0:
                        {
                            cell.detailTextLabel.text = @"普通会员";
                        }
                            break;
                        case 1:
                        {
                            cell.detailTextLabel.text = @"铜牌会员";
                        }
                            break;
                        case 2:
                        {
                            cell.detailTextLabel.text = @"银牌会员";
                        }
                            break;
                        case 3:
                        {
                            cell.detailTextLabel.text = @"金牌会员";
                        }
                            break;
                        case 4:
                        {
                            cell.detailTextLabel.text = @"钻石会员";
                        }
                            break;
                        case 5:
                        {
                            cell.detailTextLabel.text = @"铂金会员";
                        }
                            break;
                        default:
                            break;
                }
                    break;
                case 1:
                {
                    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text = @"我的客服";
                }
                    break;
                default:
                    break;
            }
        }
            break;

        default:
            break;
    }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
    
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        if (indexPath.row==1) {
            UpdateNickNameViewController *updateVC = [[UpdateNickNameViewController alloc] init];
            updateVC.delegate = self;
            [self.navigationController pushViewController:updateVC animated:YES];
        }
    }
    
}
#pragma mark -updateNickNameDelegate
- (void)getSceneName:(NSString *)str{

    UITableViewCell *cell = [self.tb cellForRowAtIndexPath:nickPath];
    cell.detailTextLabel.text = str;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
