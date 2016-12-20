//
//  DD_AddNewAddressViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/8/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_AddNewAddressViewController.h"

#import "DD_ProvinceVCT.h"

#import "DD_AddNewAddressDefaultBtn.h"

#import "DD_CityTool.h"
#import "DD_ProvinceModel.h"
#import "DD_CityModel.h"
#import "DD_AddressModel.h"

@interface DD_AddNewAddressViewController()
//<UITextFieldDelegate>

@end

@implementation DD_AddNewAddressViewController
{
    NSString *_p_id;
    NSString *_c_id;
    DD_AddNewAddressDefaultBtn *_Default_btn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
//    [self SetData];
}
#pragma mark - 初始化
-(instancetype)initWithModel:(DD_AddressModel *)AddressModel isDefault:(BOOL )isDefault WithBlock:(void(^)(NSString *type,DD_AddressModel *model,NSString *defaultID))saveblock
{
    self=[super init];
    if(self)
    {
        _AddressModel=AddressModel;
        _saveblock=saveblock;
        _is_default=isDefault;
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
-(void)setTitle:(NSString *)title
{
    self.navigationItem.titleView=[regular returnNavView:title withmaxwidth:200];
}
-(void)setIs_default:(BOOL)is_default
{
    _Default_btn.selected=is_default;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    NSArray *titlearr=@[@"收件人姓名",@"手机号码",@"邮政编码",@"省、市",@"详细地址"];
    NSArray *dataarr=nil;
    if(_AddressModel)
    {
        dataarr=@[_AddressModel.deliverName,_AddressModel.deliverPhone,_AddressModel.postCode,[[NSString alloc] initWithFormat:@"%@ %@",[self getPCNameWithID:_p_id WithType:@"province"],[self getPCNameWithID:_c_id WithType:@"city"]] ,_AddressModel.detailAddress];
    }

    __block UIView *lastview=nil;
    [titlearr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *cellview=[UIView getCustomViewWithColor:nil];
        [self.view addSubview:cellview];
        [cellview mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastview)
            {
                make.top.mas_equalTo(lastview.mas_bottom);
            }else
            {
                make.top.mas_equalTo(kNavHeight+20);
            }
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(41);
        }];
        
        UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:obj WithFont:15.0f WithTextColor:nil WithSpacing:0];
        [cellview addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cellview);
            make.left.mas_equalTo(kEdge);
            make.width.mas_equalTo([self getWeight:obj]);
        }];
        
        
        
        CGFloat _width=ScreenWidth-5-kEdge-15-kEdge-[self getWeight:obj];
        UIView *upline=[UIView getCustomViewWithColor:_define_black_color];
        upline.frame=CGRectMake(0, 41-((41-[self getHeight:obj])/2.0f), _width, 1);
        if(idx==3)
        {
            UIButton *choose_p=[UIButton getCustomTitleBtnWithAlignment:1 WithFont:14.0f WithSpacing:0 WithNormalTitle:nil WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
            [cellview addSubview:choose_p];
            choose_p.tag=100+idx;
            choose_p.frame=CGRectMake(kEdge+[self getWeight:obj]+15, 0, _width, 41);
            [choose_p addTarget:self action:@selector(chooseProvince) forControlEvents:UIControlEventTouchUpInside];
            if(_AddressModel)
            {
                [choose_p setTitle:dataarr[idx] forState:UIControlStateNormal];
            }
            [choose_p addSubview:upline];
        }else
        {
            UITextField *textFiled=[[UITextField alloc] init];
            [cellview addSubview:textFiled];
            textFiled.tag=100+idx;
            //            textFiled.delegate=self;
            [textFiled setBk_shouldReturnBlock:^BOOL(UITextField *textfield) {
                [textfield resignFirstResponder];
                return YES;
            }];
            textFiled.returnKeyType=UIReturnKeyDone;
            if(idx==1||idx==2){
                textFiled.keyboardType=UIKeyboardTypeNumberPad;
            }
            textFiled.font=[regular getFont:14.0f];
            textFiled.textColor=_define_black_color;
            textFiled.textAlignment=0;
            textFiled.frame=CGRectMake(kEdge+[self getWeight:obj]+15, 0, _width, 41);
            if(_AddressModel)
            {
                textFiled.text=dataarr[idx];
            }
            [textFiled addSubview:upline];
        }
        lastview=cellview;
    }];

    _Default_btn=[DD_AddNewAddressDefaultBtn getBtn];
    [self.view addSubview:_Default_btn];
    [_Default_btn addTarget:self action:@selector(DefaultAddress:) forControlEvents:UIControlEventTouchUpInside];
    _Default_btn.selected=_is_default;
    [_Default_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lastview.mas_bottom).with.offset(0);
        make.left.mas_equalTo(kEdge);
        make.width.mas_equalTo(174);
        make.height.mas_equalTo(57);
    }];
    
    if(_AddressModel)
    {
        _Default_btn.selected=_AddressModel.isDefault;
    }
    
    UIButton *saveBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"保   存" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self.view addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(SubmitAction) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.backgroundColor=_define_black_color;
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_Default_btn.mas_bottom).with.offset(15);
        make.width.mas_equalTo(155);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
    }];

}


#pragma mark - SomeAction
-(void)editBtnAction:(UIButton *)btn
{
    NSInteger _index=btn.tag-200;
    if(_index==3)
    {
        [self chooseProvince];
    }else
    {
        UITextField *textfiled=(UITextField *)[self.view viewWithTag:100+_index];
        [textfiled becomeFirstResponder];
    }
}
-(CGFloat )getWeight:(NSString *)str
{
    UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:str WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [titleLabel sizeToFit];
    return titleLabel.frame.size.width;
}

-(CGFloat )getHeight:(NSString *)str
{
    UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:str WithFont:14.0f WithTextColor:nil WithSpacing:0];
    [titleLabel sizeToFit];
    return titleLabel.frame.size.height;
}

-(BOOL)checkEmpty
{
    __block BOOL _have_empty=NO;
    NSArray *dataarr=@[[self getStrWithTag:4],_c_id,_p_id,[self getStrWithTag:1],[self getStrWithTag:0],[self getStrWithTag:2]];
    [dataarr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isEqualToString:@""])
        {
            _have_empty=YES;
            *stop=YES;
        }
    }];

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
        
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"content_empty", @"")] animated:YES completion:nil];
    }
}
-(NSString *)getStrWithTag:(NSInteger )_tag
{
    UITextField *textfield=(UITextField *)[self.view viewWithTag:100+_tag];
    return textfield.text;
}

-(void)DefaultAddress:(UIButton *)btn
{
    if(btn.selected)
    {
        btn.selected=NO;
    }else
    {
        btn.selected=YES;
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
-(NSString *)getPCNameWithID:(NSString *)ID WithType:(NSString *)type
{
    __block NSString *returnStr=@"";
    NSArray *_all_data=[DD_CityTool getCityModelArr];
    if([type isEqualToString:@"province"])
    {
        [_all_data enumerateObjectsUsingBlock:^(DD_ProvinceModel *_p_model, NSUInteger idx, BOOL * _Nonnull stop) {
            if([_p_model.p_id isEqualToString:_p_id])
            {
                returnStr=_p_model.name;
                *stop=YES;
            }
        }];
        
    }else if([type isEqualToString:@"city"])
    {
        __block NSArray *_dataArr_city=[[NSArray alloc] init];
        NSArray *_all_data=[DD_CityTool getCityModelArr];
        [_all_data enumerateObjectsUsingBlock:^(DD_ProvinceModel *_p_model, NSUInteger idx, BOOL * _Nonnull stop) {
            if([_p_model.p_id isEqualToString:_p_id])
            {
                _dataArr_city=_p_model.City;
                *stop=YES;
            }
        }];

        [_dataArr_city enumerateObjectsUsingBlock:^(DD_CityModel *_city, NSUInteger idx, BOOL * _Nonnull stop) {
            if([_city.c_id isEqualToString:ID])
            {
                returnStr=_city.name;
                *stop=YES;
            }
        }];
    }
    return returnStr;
}
#pragma mark - Other
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 弃用代码
//#pragma mark - SetData
//-(void)SetData
//{
//    if(_AddressModel)
//    {
//        NSArray *dataarr=@[_AddressModel.deliverName,_AddressModel.deliverPhone,_AddressModel.postCode,@"",_AddressModel.detailAddress];
//        for (int i=0; i<dataarr.count; i++) {
//            if(i!=3)
//            {
//                UITextField *textfield=(UITextField *)[self.view viewWithTag:100+i];
//                textfield.text=dataarr[i];
//            }
//        }
//        [((UIButton *)[self.view viewWithTag:103]) setTitle:[[NSString alloc] initWithFormat:@"%@ %@",[self getPCNameWithID:_p_id WithType:@"province"],[self getPCNameWithID:_c_id WithType:@"city"]] forState:UIControlStateNormal];
//
//        _Default_btn.selected=_AddressModel.isDefault;
//    }
//}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}
@end
