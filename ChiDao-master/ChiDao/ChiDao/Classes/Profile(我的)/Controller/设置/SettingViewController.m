//
//  SettingViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/7/20.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic,strong) UITableView *tb;
@end

@implementation SettingViewController

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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = NavBarColor;
    [self addNavButton];
    
    self.tb = [[UITableView alloc] initWithFrame:CGRectMake(0,0, myScreenWidth,myScreenHeight)];
    self.tb.delegate = self;
    self.tb.dataSource = self;
    self.tb.backgroundColor = NavBarColor;
    self.tb.separatorColor = NavBarColor;
    
    self.tb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tb];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"消息通知";
        }
            break;
        case 1:
        {
            
            cell.textLabel.text = @"修改密码";

        }
            break;
        case 2:
        {
            cell.textLabel.text = @"清除缓存";

            
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"关于";
            
            
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

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
