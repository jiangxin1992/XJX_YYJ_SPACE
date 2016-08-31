//
//  DD_TarentoHeadView.m
//  DDAY
//
//  Created by yyj on 16/6/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_TarentoHeadView.h"

@implementation DD_TarentoHeadView
-(instancetype)initWithUserModel:(DD_UserModel *)usermodel WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _usermodel=usermodel;
        _block=block;
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
//+ (CGFloat)heightWithModel:(DD_UserModel *)model{
//    
//    DD_TarentoHeadView *cell = [[DD_TarentoHeadView alloc] initWithUserModel:model WithBlock:nil];
//    [cell layoutIfNeeded];
//    CGRect frame =  cell.des.frame;
//    return frame.origin.y + frame.size.height+10;
//}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
-(void)PrepareUI
{
    self.backgroundColor=[UIColor whiteColor];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    UIView *headBackView=[UIView getCustomViewWithColor:nil];
    [self addSubview:headBackView];
    headBackView.layer.masksToBounds=YES;
    headBackView.layer.cornerRadius=81/2.0f;
    [regular setBorder:headBackView];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(9);
        make.width.height.mas_equalTo(81);
        make.centerX.mas_equalTo(self);
    }];
    
    UIImageView *headImg=[UIImageView getCustomImg];
    [headBackView addSubview:headImg];
    headImg.contentMode=0;
    [headImg JX_ScaleToFill_loadImageUrlStr:_usermodel.head WithSize:800 placeHolderImageName:nil radius:69/2.0f];
    headImg.userInteractionEnabled=YES;
    [headImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(headBackView);
        make.width.and.height.mas_equalTo(69);
    }];
    
    UILabel *nickName=[UILabel getLabelWithAlignment:1 WithTitle:_usermodel.nickName WithFont:18.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:nickName];
    [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(headBackView.mas_bottom).with.offset(6);
    }];
    [nickName sizeToFit];
    
    _des=[UILabel getLabelWithAlignment:1 WithTitle:_usermodel.career WithFont:12.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:_des];
    _des.numberOfLines=2;
    [_des mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nickName.mas_bottom).with.mas_equalTo(6);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
    }];
    [_des sizeToFit];
}
-(void)headClick
{
    _block(@"head_click");
}
@end
