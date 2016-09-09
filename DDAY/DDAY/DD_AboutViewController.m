//
//  DD_AboutViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/8/19.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_AboutViewController.h"

#import "DrawView.h"

#import "DD_ImageModel.h"

@interface DD_AboutViewController ()

@end

@implementation DD_AboutViewController
{
    UIScrollView *_scrollView;
    UIView *container;
    NSDictionary *_data_dict;
    
    UIImageView *headIcon;
    UILabel *brief;
    UILabel *version;
    UIView *version_back;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"user_set_about", @"") withmaxwidth:200];//设置标题
}
-(void)PrepareUI{}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateScrollView];
    [self CreateUI];

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
    headIcon=[UIImageView getCustomImg];
    [container addSubview:headIcon];
    headIcon.contentMode=2;
    [regular setZeroBorder:headIcon];
    [headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(70);
        make.width.mas_equalTo(80);
        make.centerX.mas_equalTo(container);
        make.height.mas_equalTo(0);
    }];
    
    brief=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13 WithTextColor:nil WithSpacing:0];
    [container addSubview:brief];
    brief.numberOfLines=0;
    [brief mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(IsPhone6_gt?55:35);
        make.right.mas_equalTo(IsPhone6_gt?-55:-35);
        make.top.mas_equalTo(headIcon.mas_bottom).with.offset(60);
    }];
    [brief sizeToFit];
    
    DrawView *draw=[[DrawView alloc] initWithStartP:CGPointMake(1, 43) WithEndP:CGPointMake(42, 1) WithLineWidth:3 WithColorType:1];
    [container addSubview:draw];
    [draw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(brief.mas_bottom).with.offset(35);
        make.centerX.mas_equalTo(container);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(43);
    }];
    
    version_back=[UIView getCustomViewWithColor:nil];
    [container addSubview:version_back];
    version_back.layer.masksToBounds=YES;
    version_back.layer.cornerRadius=75;
    version_back.layer.borderColor=[_define_black_color CGColor];
    version_back.layer.borderWidth=1;
    [version_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(draw.mas_bottom).with.offset(39);
        make.centerX.mas_equalTo(container);
        make.width.height.mas_equalTo(150);
    }];
    
    version=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [version_back addSubview:version];
    [version mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(version_back);
    }];
}
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"physicalStore/aboutYcoSpace.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _data_dict=data;
            [self setData];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}

#pragma mark - SetData
-(void)setData
{
    DD_ImageModel *imgModel=[DD_ImageModel getImageModel:[_data_dict objectForKey:@"pic"]];
    CGFloat _height=([imgModel.height floatValue]/[imgModel.width floatValue])*80;
    [headIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_height);
    }];
    [headIcon JX_ScaleAspectFill_loadImageUrlStr:imgModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    
    brief.text=[_data_dict objectForKey:@"brief"];

    NSString *time=[regular getTimeStr:[[_data_dict objectForKey:@"time"] longValue]/1000 WithFormatter:@"YYYY.MM"];
    version.text=[[NSString alloc] initWithFormat:@"%@   V%@",time,[_data_dict objectForKey:@"version"]];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(ktabbarHeight);
        // 让scrollview的contentSize随着内容的增多而变化
        make.bottom.mas_equalTo(version_back.mas_bottom).with.offset(40);
    }];
}
#pragma mark - Other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
