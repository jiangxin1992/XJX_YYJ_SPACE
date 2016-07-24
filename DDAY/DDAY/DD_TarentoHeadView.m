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
    UIImageView *head=[[UIImageView alloc] init];
    [self addSubview:head];
    [head JX_loadImageUrlStr:_usermodel.head WithSize:800 placeHolderImageName:nil radius:40];
    head.userInteractionEnabled=YES;
    [head addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
    [head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.and.height.mas_equalTo(80);
        make.top.mas_equalTo(20);
    }];
    
    UILabel *nickName=[[UILabel alloc] init];
    [self addSubview:nickName];
    nickName.textColor=[UIColor blackColor];
    nickName.font=[regular getFont:13.0f];
    nickName.text=_usermodel.nickName;
    nickName.textAlignment=1;
    
    [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(head.mas_bottom).with.mas_equalTo(0);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *des=[[UILabel alloc] init];
    [self addSubview:des];
    des.textColor=[UIColor lightGrayColor];
    des.font=[regular getFont:13.0f];
    des.text=_usermodel.nickName;
    des.textAlignment=1;
    des.numberOfLines=0;
    
    [des mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nickName.mas_bottom).with.mas_equalTo(0);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];

}
-(void)headClick
{
    _block(@"head_click");
}
@end
