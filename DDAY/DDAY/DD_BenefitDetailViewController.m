//
//  DD_BenefitDetailViewController.m
//  YCO SPACE
//
//  Created by yyj on 2016/11/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BenefitDetailViewController.h"

#import "DD_BenefitDetailModel.h"

@interface DD_BenefitDetailViewController ()

@end

@implementation DD_BenefitDetailViewController
{
    DD_BenefitDetailModel *_benefitDetailModel;
    UIScrollView *_scrollView;
    UIView *container;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];

}
-(instancetype)initWithBenefitInfoModel:(DD_BenefitInfoModel *)benefitInfoModel WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _benefitInfoModel=benefitInfoModel;
        _block=block;
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
    [self CreateScrollView];
}
-(void)CreateScrollView
{
    _scrollView=[[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    container = [UIView new];
    [_scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
}
-(void)CreateUI
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationItem.titleView=[regular returnNavView:_benefitDetailModel.name withmaxwidth:200];
    });
    
    UIImageView *_backImg=[UIImageView getCustomImg];
    [container addSubview:_backImg];
    _backImg.contentMode=0;
    [_backImg JX_ScaleToFill_loadImageUrlStr:_benefitDetailModel.picInfo.pic WithSize:800 placeHolderImageName:nil radius:0];
    CGFloat _width=floor(ScreenWidth-(IsPhone6_gt?50:30)*2);
    CGFloat _height=([_benefitDetailModel.picInfo.height floatValue]/[_benefitDetailModel.picInfo.width floatValue])*_width;
    [_backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(container).with.offset(14);
        make.centerX.mas_equalTo(container);
        make.width.mas_equalTo(_width);
        make.height.mas_equalTo(_height);
    }];
    
    if(![DD_UserModel isLogin])
    {
        // 270 70
        UIButton *loginBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"立即注册" WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
        [_backImg addSubview:loginBtn];
        loginBtn.backgroundColor=_define_white_color;
        loginBtn.titleLabel.font=[regular getSemiboldFont:15.0f];
        [loginBtn addTarget:self action:@selector(pushLoginView) forControlEvents:UIControlEventTouchUpInside];
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(135);
            make.height.mas_equalTo(35);
            make.centerX.mas_equalTo(_backImg);
            make.bottom.mas_equalTo(_backImg).with.offset(-40);
        }];
    }
    
    UILabel *rule_title_label=[UILabel getLabelWithAlignment:0 WithTitle:_benefitDetailModel.ruleTitle WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [container addSubview:rule_title_label];
    rule_title_label.font=[regular getSemiboldFont:15.0f];
    rule_title_label.numberOfLines=1;
    [rule_title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(_backImg.mas_bottom).with.offset(26);
    }];
    
    UILabel *rule_content_label=[UILabel getLabelWithAlignment:0 WithTitle:_benefitDetailModel.ruleContent WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [container addSubview:rule_content_label];
    rule_content_label.numberOfLines=0;
    [rule_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(rule_title_label.mas_bottom).with.offset(14);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(ktabbarHeight);
        // 让scrollview的contentSize随着内容的增多而变化
        make.bottom.mas_equalTo(rule_content_label.mas_bottom).with.offset(40);
    }];
    
}
#pragma mark - RequestData
-(void)RequestData
{
    [self RequestDetailData];
//    [self RequestCloseData];
}
-(void)RequestDetailData
{
    [[JX_AFNetworking alloc] GET:@"user/queryBenefitDetail.do" parameters:@{@"benefitId":_benefitInfoModel.benefitId,@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _benefitDetailModel=[DD_BenefitDetailModel getBenefitDetailInfoModel:[data objectForKey:@"benefitInfo"]];
            [self CreateUI];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
-(void)RequestCloseData
{
    if([DD_UserModel isLogin])
    {
        //关闭
        [[JX_AFNetworking alloc] GET:@"user/readBenefit.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                _block(@"markread");
            }else
            {
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
        }];
    }
}

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
