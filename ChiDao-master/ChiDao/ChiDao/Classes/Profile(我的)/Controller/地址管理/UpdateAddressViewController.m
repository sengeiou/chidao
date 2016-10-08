//
//  UpdateAddressViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/7/25.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "UpdateAddressViewController.h"
#import "fieldCell.h"
#import "UIView+RGSize.h"

@interface UpdateAddressViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate>{
    
    
    NSIndexPath *areaPath;

    NSIndexPath *namePath;
    NSIndexPath *phonePath;
    NSIndexPath *addressPath;
    NSIndexPath *postcodePath;
    
}
@property (nonatomic,strong) UITableView *tb;

//地区
@property (strong, nonatomic) UIPickerView *myPicker;
@property (strong, nonatomic) UIView *pickerBgView;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;

@end

@implementation UpdateAddressViewController
@synthesize textID,text1,text2,text3,text4,text5;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CD_BackAddress" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑收货地址";
    self.view.backgroundColor = NavBarColor;
    [self addNavButton];
    
    self.tb = [[UITableView alloc] initWithFrame:CGRectMake(0,0, myScreenWidth,280)];
    self.tb.delegate = self;
    self.tb.dataSource = self;
    self.tb.scrollEnabled = NO;
    self.tb.backgroundColor = NavBarColor;
    self.tb.separatorColor = NavBarColor;
    
    self.tb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tb];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.backgroundColor = btnColor;
    saveBtn.layer.cornerRadius = myCornerRadius;
    saveBtn.clipsToBounds = YES;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.tb.mas_bottom).offset (20);
        make.left.mas_equalTo (self.view.mas_left).offset (20);
        make.right.mas_equalTo (self.view.mas_right).offset (-20);
        make.height.mas_equalTo (50);
    }];
    
    //地区
    [self getPickerData];
    [self initView];
}
- (void)saveClick{
    //校验填写项目为空、手机号位数和有效性、邮编6位
    fieldCell *cell1 = [self.tb cellForRowAtIndexPath:namePath];
    fieldCell *cell2 = [self.tb cellForRowAtIndexPath:phonePath];
    UITableViewCell *cell3 = [self.tb cellForRowAtIndexPath:areaPath];
    fieldCell *cell4 = [self.tb cellForRowAtIndexPath:addressPath];
    fieldCell *cell5 = [self.tb cellForRowAtIndexPath:postcodePath];
    
    if ([cell1.tf.text isEqualToString:@""]) {
        
        [Tool showMessage:@"收货人姓名不能为空"];
    }else if([cell2.tf.text isEqualToString:@""]){
        [Tool showMessage:@"手机号不能为空"];
        
    }else if([cell3.detailTextLabel.text isEqualToString:@""]){
        [Tool showMessage:@"所在地区不能为空"];
        
    }else if([cell4.tf.text isEqualToString:@""]){
        [Tool showMessage:@"详细地址不能为空"];
        
    }else if([cell5.tf.text isEqualToString:@""]){
        [Tool showMessage:@"邮政编码不能为空"];
        
    }else if(![Tool isMobile:cell2.tf.text]||[cell2.tf.text length]<11){
        [Tool showMessage:@"请填写正确手机号"];
    }else if([cell5.tf.text length]!=6){
        [Tool showMessage:@"请填写6位邮政编码"];
    }else{
        //修改收货地址
        
        NSURLSessionDataTask *task = [[NewsClient sharedClient] updateAddress:UpdateAddrURL withToken:[APPConfig getInstance].tokenWord withID:self.textID withName:cell1.tf.text withAddressArea:cell3.detailTextLabel.text withAddrDetail:cell4.tf.text withPostid:cell5.tf.text withMobile:cell2.tf.text  completion:^(NSMutableDictionary *dic, NSError *error) {
            
            if (!error) {
                
                if ([[dic objectForKey:@"code"] isEqualToString:@"000000"]) {
                    
                    [self doBack];
                    [Tool showMessage:@"修改成功"];
                    
                }else{
                    
                    [Tool showMessage:[dic objectForKey:@"desc"]];
                }
                
            }
            
        }];
        [task resume];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"fieldCell";
    
    fieldCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[fieldCell alloc] initWithStyle:UITableViewCellStyleDefault withIndexPath:indexPath reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLabel.text = @"收  货  人";
            cell.tf.text = self.text1;
            namePath = indexPath;
        }
            break;
        case 1:
        {
            cell.titleLabel.text = @"联系电话";
            cell.tf.text = self.text2;
            phonePath = indexPath;
        }
            break;
        case 2:
        {
            static NSString *CellIdentifier2 = @"cell";
            
            UITableViewCell *cell2 = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier2];
            if (!cell2) {
                cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier2];
            }
            areaPath = indexPath;
            cell2.textLabel.text = @"所在地区";
            [cell2.detailTextLabel setTextColor:[UIColor blackColor]];
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            cell2.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
            cell2.detailTextLabel.text = self.text3;
            return cell2;
        }
            break;
        case 3:
        {
            cell.titleLabel.text = @"详细地址";
            cell.tf.text = self.text4;
            addressPath = indexPath;
        }
            break;
        case 4:
        {
            cell.titleLabel.text = @"邮政编码";
            cell.tf.text = self.text5;
            postcodePath = indexPath;
        }
            break;
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
    
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==2) {
        fieldCell *cell1 = [self.tb cellForRowAtIndexPath:namePath];
        fieldCell *cell2 = [self.tb cellForRowAtIndexPath:phonePath];
        fieldCell *cell4 = [self.tb cellForRowAtIndexPath:addressPath];
        fieldCell *cell5 = [self.tb cellForRowAtIndexPath:postcodePath];
        [cell1.tf resignFirstResponder];
        [cell2.tf resignFirstResponder];
        [cell4.tf resignFirstResponder];
        [cell5.tf resignFirstResponder];
        [self showMyPicker];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init view
- (void)initView {
    
    self.maskView = [[UIView alloc] initWithFrame:kScreen_Frame];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    
    self.pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myScreenWidth, 255)];
    self.pickerBgView.backgroundColor = [UIColor whiteColor];
    
    // 选择框
    self.myPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 31, myScreenWidth, 216)];
    // 显示选中框
    self.myPicker .showsSelectionIndicator=YES;
    self.myPicker .dataSource = self;
    self.myPicker .delegate = self;
    [self.pickerBgView addSubview:self.myPicker];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(240, 0, 80, 39);
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(ensurePick) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgView addSubview:saveBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 80, 39);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelPick) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgView addSubview:cancelBtn];
}
#pragma mark - get data
- (void)getPickerData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
    
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else {
        return [self.townArray objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 100;
    } else if (component == 1) {
        return 110;
    } else {
        return 110;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = nil;
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.townArray = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
        } else {
            self.townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}

#pragma mark - private method
- (void)showMyPicker{
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.pickerBgView];
    self.maskView.alpha = 0;
    self.pickerBgView.top = self.view.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.3;
        self.pickerBgView.bottom = self.view.height;
    }];
}

- (void)hideMyPicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.pickerBgView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}

#pragma mark - xib click

- (void)cancelPick{
    [self hideMyPicker];
}

- (void)ensurePick{
    
    UITableViewCell *cell = [self.tb cellForRowAtIndexPath:areaPath];
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@%@%@",[self.provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:0]],[self.cityArray objectAtIndex:[self.myPicker selectedRowInComponent:1]],[self.townArray objectAtIndex:[self.myPicker selectedRowInComponent:2]]];
    [self hideMyPicker];
}

@end
