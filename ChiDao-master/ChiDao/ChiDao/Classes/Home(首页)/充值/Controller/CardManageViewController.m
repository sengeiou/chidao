//
//  CardManageViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/8/18.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "CardManageViewController.h"
#import "addCardNoViewController.h"
#import "ETCCardInfoCell.h"
@interface CardManageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *cardView;
    NSMutableArray *dataArray;
}
@property (nonatomic,strong) UITableView *tb;
@end

@implementation CardManageViewController

- (void)addNavButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 20, 100, 46);
    addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    addBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [addBtn setTitle:@"添加卡片" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addCard) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-15时，间距正好调整
     *  为10；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -15;

    self.navigationItem.rightBarButtonItems = @[negativeSpacer, addItem];
    
}
-(void)doBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
//添加卡片
-(void)addCard{
    addCardNoViewController *cardNoVC = [[addCardNoViewController alloc] init];
    cardNoVC.addNewCard = ^(NSDictionary *dataDic){
        [dataArray addObject:dataDic];
        [self.tb reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:cardNoVC animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的ETC卡";
    self.view.backgroundColor = NavBarColor;
    [self addNavButton];
    self.tb = [UITableView new];
    self.tb.delegate = self;
    self.tb.dataSource = self;
    self.tb.backgroundColor = [UIColor clearColor];
    self.tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tb.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tb];
    [self.tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.view.mas_top);
        make.left.mas_equalTo (self.view.mas_left);
        make.right.mas_equalTo (self.view.mas_right);
        make.bottom.mas_equalTo (self.view.mas_bottom);
        
    }];

    dataArray =[@[@{@"cardNum":@"2222 2222 2222 2222 2222",@"plateNum":@"鲁F90K71",@"name":@"测试"},@{@"cardNum":@"3333 3333 3333 3333 3333",@"plateNum":@"鲁F90K72",@"name":@"测试1"}]mutableCopy];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [dataArray count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ETCCardInfoCell *cell = [ETCCardInfoCell cellWithTableView:tableView];
    cell.plateNumLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"plateNum"];
    cell.nameLabel.text=  [[dataArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.cardNumLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"cardNum"];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
    
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ETCCardInfoCell *cell = [self.tb cellForRowAtIndexPath:indexPath];
    
    if (self.addCardView) {
        self.addCardView(cell.cardView);
    }
    [self doBack];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
