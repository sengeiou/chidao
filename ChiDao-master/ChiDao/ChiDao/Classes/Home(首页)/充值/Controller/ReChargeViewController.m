//
//  ReChargeViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/8/16.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "ReChargeViewController.h"
#import "addCardCell.h"
#import "CZAUIView+Gesture.h"
#import "CardManageViewController.h"
#import "ETCSelectMoneyCell.h"
#import "ETCBottomView.h"
#import "ETCReceiptCell.h"
#import "AddressListViewController.h"
#import "ReceiptHeaderViewController.h"
@interface ReChargeViewController ()<UITableViewDelegate,UITableViewDataSource,updateReceiptHeaderDelegate>
{
    NSString *headerStr;//发票抬头
    NSString *addressStr;//地址信息
}
@property (nonatomic,strong) UITableView *tb;
@property (nonatomic,strong) ETCBottomView *bottomView;

@property (nonatomic,assign)Boolean isOpen;
@end

@implementation ReChargeViewController
@synthesize isOpen=_isOpen;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    self.view.backgroundColor = NavBarColor;
    
    self.tb = [UITableView new];
    self.tb.delegate = self;
    self.tb.dataSource = self;
    self.tb.backgroundColor = [UIColor clearColor];
    self.tb.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tb];
    [self.tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.view.mas_top);
        make.left.mas_equalTo (self.view.mas_left);
        make.right.mas_equalTo (self.view.mas_right);
        make.bottom.mas_equalTo (self.view.mas_bottom).offset(-44);
    
    }];
    
    self.bottomView = [[ETCBottomView alloc] initWithFrame:CGRectMake(0, myScreenHeight-44-64, myScreenWidth, 44)];
    [self.view addSubview:self.bottomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goAddressNav) name:@"CD_goAddress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goHeaderNav) name:@"CD_goHeader" object:nil];
}
- (void)goHeaderNav{
    ReceiptHeaderViewController *headerVC = [[ReceiptHeaderViewController alloc] init];
    headerVC.delegate=self;
    headerVC.sstr = headerStr;
    [self.navigationController pushViewController:headerVC animated:YES];
}
- (void)getReceiptHeader:(NSString *)str{
    headerStr = str;
    [self.tb reloadData];
}
- (void)goAddressNav{
    AddressListViewController *addressVC = [[AddressListViewController alloc] init];
    addressVC.flag=@"1";
    addressVC.chooseAddress = ^(NSString *address){
        addressStr = address;
        [self.tb reloadData];
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
        return 0;
    }else{
        return 10;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = NavBarColor;
    return footerView;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            addCardCell *cell = [addCardCell cellWithTableView:tableView];
            [cell.dashView.imageV_IDCard addTapGesture:^{
                [self addCardManage];
            }];
            [cell.dashView.addCard addTapGesture:^{
                [self addCardManage];
            }];
            return cell;
            
        }
            break;
        case 1:
        {
            ETCSelectMoneyCell *cell =[ETCSelectMoneyCell cellWithTableView:tableView];
            
            return cell;
        }
            break;
        case 2:
        {
            //关闭的cell
            ETCReceiptCell *cell =[ETCReceiptCell cellWithTableView:tableView];
            cell.openReceipt = ^(Boolean isopen){
                _isOpen = isopen;
            };
            
            if (headerStr==nil) {
                cell.receiptHeader.text = @"请输入发票抬头";
            }else{
                cell.receiptHeader.text = headerStr;
                cell.receiptHeader.textColor = kColor_0x666666;
            }
            
            if (addressStr==nil) {
               cell.receiptAddress.text = @"请选择收货地址";
            }else{
                cell.receiptAddress.text = addressStr;
                cell.receiptAddress.textColor = kColor_0x666666;
            }

            
            return cell;
            
        }
            break;
        default:
            return nil;
            break;
    }
   return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return 180;
        }
            break;
        case 1:
        {
            return 180;
        }
            break;
        case 2:
        {
            if (_isOpen) {
                return 155;
            }
            return 55;
        }
            break;
        default:
            
            break;
    }
    return 0;
    
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
            
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
    
    
}
- (void)addCardManage{
    CardManageViewController *cardManage = [[CardManageViewController alloc] init];
    cardManage.addCardView = ^(UIView *view){
        
        addCardCell *cell = [self.tb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.dashView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo (cell.mas_top).offset (19);
            make.left.mas_equalTo (cell.mas_left).offset (19);
            make.right.mas_equalTo (cell.mas_right).offset (-19);
            make.bottom.mas_equalTo (cell.mas_bottom).offset (-19);
        }];
    };
    [self.navigationController pushViewController:cardManage animated:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
