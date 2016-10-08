//
//  BankController.m
//  HisunPay
//
//  Created by allen on 14/11/19.
//  Copyright (c) 2014年 com.hisuntech. All rights reserved.
//

#import "HisuntechBankController.h"
#import "HisuntechBankCell.h"
#import "HisuntechUIImageView+AFNetworking.h"
#import "HisuntechUserEntity.h"
#define U_R_L @"https://www.xlpayment.com/images/appsdk/"
@interface HisuntechBankController ()<UITableViewDelegate,UITableViewDataSource>
{
	BOOL _reloading;
    UITableView *_tableView;
}
@end

@implementation HisuntechBankController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"银行列表";
    }
    return self;
}
#pragma mark - 自定义back键
- (void)createBackButton
{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"hisuntech.bundle/back_btn_n (2)"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self     action:@selector(finish)];
    self.navigationItem.leftBarButtonItem = back;
}
#pragma mark - back键的点击事件
- (void)finish{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -创建UI
- (void)createUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark -加载数据源
- (void)loadData
{
    
    NSString *path = ResourcePath(@"bank.plist");
    _bankNmArr = [NSMutableArray arrayWithContentsOfFile:path];
    path = ResourcePath(@"bankNo.plist");
    _bankNoArr = [NSMutableArray arrayWithContentsOfFile:path];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    [self createUI];
    [self createBackButton];
}
#pragma mark - 定制cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HisuntechBankCell *cell = (HisuntechBankCell *)[tableView dequeueReusableCellWithIdentifier:@"ID"];
    //判断单元格是否为空
    if (cell == nil) {
        cell = [[HisuntechBankCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.bankName.text = [[_bankNmArr objectAtIndex:indexPath.row] objectForKey:[_bankNoArr objectAtIndex:indexPath.row]];
    NSString *logoStr = [NSString stringWithFormat:@"%@%@.png",U_R_L,[[_bankNoArr objectAtIndex:indexPath.row] lowercaseString]];
    [cell.bankLogo setImageWithURL:[NSURL URLWithString:logoStr]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark -设置行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_bankNmArr count];
}
#pragma mark -设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma mark - 获取单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_delegate respondsToSelector:@selector(passValue1:)]) {
        [HisuntechUserEntity Instance].bankNo = [_bankNoArr objectAtIndex:indexPath.row];
        [_delegate passValue1:[_bankNmArr objectAtIndex:indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
