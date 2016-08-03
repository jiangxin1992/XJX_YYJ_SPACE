//
//  DD_AddNewAddressViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/8/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_AddNewAddressViewController.h"

#import "DD_CityTool.h"
#import "DD_ProvinceVCT.h"

@implementation DD_AddNewAddressViewController
{
    NSString *_p_id;
    NSString *_c_id;
    UIButton *_Default_btn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self SetData];
}
#pragma mark - 初始化
-(instancetype)initWithModel:(DD_AddressModel *)AddressModel WithBlock:(void(^)(NSString *type,DD_AddressModel *model,NSString *defaultID))saveblock
{
    self=[super init];
    if(self)
    {
        _AddressModel=AddressModel;
        _saveblock=saveblock;
        if(_AddressModel)
        {
            _p_id=AddressModel.provinceId;
            _c_id=AddressModel.cityId;
        }else
        {
            _p_id=@"";
            _c_id=@"";
        }
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
-(void)PrepareUI{}
#pragma mark - UIConfig
-(void)UIConfig
{
    NSArray *titlearr=@[@"收件人姓名",@"手机号码",@"邮政编码",@"省、市",@"详细地址"];
    CGFloat _y_p=10+64;
    for (int i=0; i<titlearr.count; i++) {
        if(i==3)
        {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor=[UIColor whiteColor];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            [btn addTarget:self action:@selector(chooseProvince) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
            btn.tag=100+i;
            btn.frame=CGRectMake(20, _y_p,ScreenWidth-40, 40);
            [btn setTitle:titlearr[i] forState:UIControlStateNormal];
        }else
        {
            UITextField *textfield=[[UITextField alloc] initWithFrame:CGRectMake(20, _y_p,ScreenWidth-40, 40)];
            textfield.backgroundColor=[UIColor whiteColor];
            [self.view addSubview:textfield];
            textfield.textAlignment=0;
            textfield.tag=100+i;
            textfield.placeholder=titlearr[i];
        }
        _y_p+=50;
    }
    _Default_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_Default_btn];
    [_Default_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_Default_btn setTitle:@"默认地址" forState:UIControlStateNormal];
    [_Default_btn setTitle:@"默认地址" forState:UIControlStateSelected];
    [_Default_btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    _Default_btn.frame=CGRectMake(40, 330, 100, 40);
    [_Default_btn addTarget:self action:@selector(DefaultAddress) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *_submit_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_submit_btn];
    [_submit_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_submit_btn setTitle:@"保存" forState:UIControlStateNormal];
    _submit_btn.frame=CGRectMake((ScreenWidth-100)/2.0f, 330, 100, 40);
    [_submit_btn addTarget:self action:@selector(SubmitAction) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - SetData
-(void)SetData
{
    if(_AddressModel)
    {
        NSArray *dataarr=@[_AddressModel.deliverName,_AddressModel.deliverPhone,_AddressModel.postCode,@"",_AddressModel.detailAddress];
        for (int i=0; i<dataarr.count; i++) {
            if(i!=3)
            {
                UITextField *textfield=(UITextField *)[self.view viewWithTag:100+i];
                textfield.text=dataarr[i];
            }
        }
        [((UIButton *)[self.view viewWithTag:103]) setTitle:[[NSString alloc] initWithFormat:@"%@ %@",[self getPCNameWithID:_p_id WithType:@"province"],[self getPCNameWithID:_c_id WithType:@"city"]] forState:UIControlStateNormal];
        
        _Default_btn.selected=_AddressModel.isDefault;
        
        
    }
}

#pragma mark - SomeAction
-(BOOL)checkEmpty
{
    BOOL _have_empty=NO;
    NSArray *dataarr=@[[self getStrWithTag:4],_c_id,_p_id,[self getStrWithTag:1],[self getStrWithTag:0],[self getStrWithTag:2]];
    for (NSString *str in dataarr) {
        if([str isEqualToString:@""])
        {
            _have_empty=YES;
            return YES;
            break;
        }
    }
    return _have_empty;
}
-(NSString *)getTextFieldStr:(NSInteger )tag
{
    UITextField *textfield=[self.view viewWithTag:100+tag];
    return textfield.text;
}
-(void)SubmitAction
{
    if(![self checkEmpty])
    {
        
        //        12
        if([regular phoneVerify:[self getTextFieldStr:1]])
        {
            if([regular PostCodeVerify:[self getTextFieldStr:2]])
            {
                NSString *_url=nil;
                NSDictionary *_parameter=nil;
                if(_AddressModel)
                {
                    _url=@"user/editDeliverAddress.do";
                    _parameter=@{@"udaId":_AddressModel.udaId,@"token":[DD_UserModel getToken],@"isDefault":[NSNumber numberWithBool:_Default_btn.selected],@"detailAddress":[self getStrWithTag:4],@"cityId":_c_id,@"provinceId":_p_id,@"countryId":@"721",@"deliverPhone":[self getStrWithTag:1],@"deliverName":[self getStrWithTag:0],@"postCode":[self getStrWithTag:2]};
                }else
                {
                    _url=@"user/addDeliverAddress.do";
                    _parameter=@{@"token":[DD_UserModel getToken],@"isDefault":[NSNumber numberWithBool:_Default_btn.selected],@"detailAddress":[self getStrWithTag:4],@"cityId":_c_id,@"provinceId":_p_id,@"countryId":@"721",@"deliverPhone":[self getStrWithTag:1],@"deliverName":[self getStrWithTag:0],@"postCode":[self getStrWithTag:2]};
                }
                [[JX_AFNetworking alloc] GET:_url parameters:_parameter success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                    if(success)
                    {
                        DD_AddressModel *_getmodel=[DD_AddressModel getAddressModel:[data objectForKey:@"deliverAddress"]];
                        NSString *defaultId=[data objectForKey:@"defaultId"];
                        if(_AddressModel)
                        {
                            //            修改地址
                            _saveblock(@"modify",_getmodel,defaultId);
                            [self.navigationController popViewControllerAnimated:YES];
                        }else
                        {
                            //            增加地址
                            _saveblock(@"add",_getmodel,defaultId);
                            
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }else
                    {
                        [self presentViewController:successAlert animated:YES completion:nil];
                    }
                } failure:^(NSError *error, UIAlertController *failureAlert) {
                    [self presentViewController:failureAlert animated:YES completion:nil];
                }];
            }else
            {
                [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"right_postcode", @"")] animated:YES completion:nil];
            }
            
        }else
        {
            
            [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"login_phone_flase", @"")] animated:YES completion:nil];
        }
        
    }else
    {
        
    }
}
-(NSString *)getStrWithTag:(NSInteger )_tag
{
    UITextField *textfield=(UITextField *)[self.view viewWithTag:100+_tag];
    return textfield.text;
}

-(void)DefaultAddress
{
    if(_Default_btn.selected)
    {
        _Default_btn.selected=NO;
    }else
    {
        _Default_btn.selected=YES;
    }
}
-(void)chooseProvince
{
    DD_ProvinceVCT *_Province=[[DD_ProvinceVCT alloc] initWithBlock:^(NSString *p_id, NSString *c_id) {
        _p_id=p_id;
        _c_id=c_id;
        
        [((UIButton *)[self.view viewWithTag:103]) setTitle:[[NSString alloc] initWithFormat:@"%@ %@",[self getPCNameWithID:_p_id WithType:@"province"],[self getPCNameWithID:_c_id WithType:@"city"]] forState:UIControlStateNormal];
    }];
    _Province.title=@"选择省";
    [self.navigationController pushViewController:_Province animated:YES];
}
-(NSString *)getPCNameWithID:(NSString *)_id WithType:(NSString *)type
{
    NSArray *_all_data=[DD_CityTool getCityModelArr];
    if([type isEqualToString:@"province"])
    {
        for (int i=0; i<_all_data.count; i++) {
            DD_ProvinceModel *_p_model=[_all_data objectAtIndex:i];
            if([_p_model.p_id isEqualToString:_p_id])
            {
                return _p_model.name;
            }
        }
        
    }else if([type isEqualToString:@"city"])
    {
        NSArray *_dataArr_city=[[NSArray alloc] init];
        NSArray *_all_data=[DD_CityTool getCityModelArr];
        for (int i=0; i<_all_data.count; i++) {
            DD_ProvinceModel *_p_model=[_all_data objectAtIndex:i];
            if([_p_model.p_id isEqualToString:_p_id])
            {
                _dataArr_city=_p_model.City;
                break;
            }
        }
        for (DD_CityModel *_city in _dataArr_city) {
            if([_city.c_id isEqualToString:_id])
            {
                return _city.name;
            }
        }
    }
    return @"";
}
#pragma mark - Other
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_AddNewAddressViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_AddNewAddressViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
