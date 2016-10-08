//
//  AddressListViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/7/20.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddAddressViewController.h"
#import "MJRefresh.h"
#import "AddressListCell.h"
#import "UpdateAddressViewController.h"
@interface AddressListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSIndexPath *delIndex;
}
@property (nonatomic,strong) UITableView *tb;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation AddressListViewController
@synthesize dataArr = _dataArr,flag = _flag;

- (void)addNavButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 48, 46);
    [saveBtn setTitle:@"新增" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = saveItem;
    
}
- (void)addAddress{
    
    AddAddressViewController *addVC = [[AddAddressViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}
-(void)doBack
{
    if ([self.flag isEqualToString:@"0"]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSURLSessionDataTask *task = [[NewsClient sharedClient] getAddress:GetAddrsURL withToken:[APPConfig getInstance].tokenWord completion:^(NSMutableDictionary *dic, NSError *error) {
            
            if (!error) {
                
                if ([[dic objectForKey:@"code"] isEqualToString:@"000000"]) {
                    self.dataArr = [[dic objectForKey:@"data"] objectForKey:@"addrs_list"];
                    
                    if ([self.dataArr count]>0) {
                        self.tb.tableHeaderView = nil;
                        self.tb.userInteractionEnabled = YES;
                    }else{
                        UIView *emptyView = [[UIView alloc] initWithFrame:self.tb.frame];
                        UIImageView *pictureView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ad_em"]];
                        [pictureView setFrame:CGRectMake((self.tb.frame.size.width-145)/2, (self.tb.frame.size.height-145)/2-100, 145,145)];
                        
                        UILabel *lb = [UILabel new];
                        lb.text = @"没有发现地址，请先添加收货地址";
                        lb.font = [UIFont boldSystemFontOfSize:16];
                        lb.textColor = [UIColor lightGrayColor];
                        lb.textAlignment = NSTextAlignmentCenter;
                        [emptyView addSubview:lb];
                        
                        [emptyView addSubview:pictureView];
                        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo (pictureView.mas_bottom).offset (20);
                            make.left.mas_equalTo (emptyView.mas_left).offset (5);
                            make.right.mas_equalTo (emptyView.mas_right).offset (-5);
                            make.height.mas_equalTo (44);
                        }];
                        self.tb.tableHeaderView = emptyView;
                        self.tb.userInteractionEnabled = NO;
                    }
                    [self.tb reloadData];
                    [self.tb.mj_header endRefreshing];
                    
                }else{
                    
                    [Tool showMessage:[dic objectForKey:@"desc"]];
                    if ([self.tb.mj_header isRefreshing]) {
                        [self.tb.mj_header endRefreshing];
                    }
                }
                
            }
            
        }];
        [task resume];

    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址管理";
    self.view.backgroundColor = NavBarColor;
    [self addNavButton];
    
    self.dataArr = [[NSMutableArray alloc] initWithCapacity:10];
    
    
    self.tb = [[UITableView alloc] initWithFrame:CGRectMake(0,0, myScreenWidth,myScreenHeight)];
    self.tb.delegate = self;
    self.tb.dataSource = self;
    self.tb.backgroundColor = NavBarColor;
    self.tb.separatorColor = NavBarColor;
    
    
    self.tb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 集成刷新控件
    [self setupRefresh];
    // 添加返回通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"CD_BackAddress" object:nil];
    [self.view addSubview:self.tb];
}
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    self.tb.mj_header = header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataArr count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.dataArr count]>0) {
        static NSString *CellIdentifier = @"cell";
        
        AddressListCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[AddressListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.nameLabel.text = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.phoneLabel.text = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"mobile"];
        cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"addrArea"],[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"addrDetail"]];
        cell.postcodeLabel.text = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"postnub"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        static NSString *CellIdentifier2 = @"cell2";
        
        UITableViewCell *cell2 = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (!cell2) {
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        UIImageView *pictureView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ad_em"]];
        [pictureView setFrame:CGRectMake((self.tb.frame.size.width-145)/2, (self.tb.frame.size.height-145)/2-100, 145,145)];
        
        UILabel *lb = [UILabel new];
        lb.text = @"没有发现地址，请先添加收货地址";
        lb.font = [UIFont boldSystemFontOfSize:16];
        lb.textColor = [UIColor lightGrayColor];
        lb.textAlignment = NSTextAlignmentCenter;
        [cell2.contentView addSubview:lb];
        
        [cell2.contentView addSubview:pictureView];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo (pictureView.mas_bottom).offset (20);
            make.left.mas_equalTo (cell2.contentView.mas_left).offset (5);
            make.right.mas_equalTo (cell2.contentView.mas_right).offset (-5);
            make.height.mas_equalTo (44);
        }];
        
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell2;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataArr count]>0) {
        return 110;
    }else{
        return self.tb.frame.size.height;
    }
    
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.flag isEqualToString:@"0"]) {
        UpdateAddressViewController *updataVC = [[UpdateAddressViewController alloc] init];
        updataVC.textID =[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"addrid"];
        updataVC.text1 =[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"name"];
        updataVC.text2 = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"mobile"];
        updataVC.text3 =[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"addrArea"];
        updataVC.text4 =[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"addrDetail"];
        updataVC.text5 =[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"postnub"];
        [self.navigationController pushViewController:updataVC animated:YES];
    }else{
        
        //需要发票那边的返回
        if (self.chooseAddress) {
            self.chooseAddress([NSString stringWithFormat:@"%@%@",[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"addrArea"],[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"addrDetail"]]);
        }
        [self doBack];
    }
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//删除功能
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        delIndex = indexPath;
        //删除地址
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self requestDelAddressResults];
        });
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)requestDelAddressResults{
    
    NSURLSessionDataTask *task = [[NewsClient sharedClient] removeAddress:RemoveAddrURL withToken:[APPConfig getInstance].tokenWord withAddrid:[[self.dataArr objectAtIndex:delIndex.row] objectForKey:@"addrid"] withArea:[APPConfig getInstance].currentCity withRegip:[Tool getIpAddresses] completion:^(NSMutableDictionary *dic, NSError *error) {
        
        if (!error) {
            if ([[dic objectForKey:@"code"] isEqualToString:@"000000"]) {
                [Tool showMessage:@"删除成功"];
                [self.tb beginUpdates];
                
                //如果直接用dataArr删除 会出现mutating method sent to immutable object 原因是你的可变数组指针引用了单例对应的指针，而单例是存在于内存数据段的，不能进行增删改操作
                NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.dataArr];
                [tmpArray removeObjectAtIndex:delIndex.row];
                self.dataArr = tmpArray;
                
                [self.tb deleteRowsAtIndexPaths:[NSArray arrayWithObject:delIndex] withRowAnimation:UITableViewRowAnimationFade];
                
                [self.tb endUpdates];
            }
            
        }else{
            [Tool showMessage:[dic objectForKey:@"desc"]];
        }
    }];
    [task resume];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end