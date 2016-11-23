//
//  DD_CircleDailyInfoView.m
//  YCO SPACE
//
//  Created by yyj on 16/9/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleDailyInfoView.h"

#import "DD_CircleInfoSuggestView.h"
#import "DD_CircleDailyInfoImgView.h"

#import "DD_CircleModel.h"

@implementation DD_CircleDailyInfoView

#pragma mark - 初始化
/**
 * 初始化
 */
-(instancetype)initWithCircleModel:(DD_CircleModel *)model WithBlock:(void (^)(NSString *type,long index))block
{
    self=[super init];
    if(self)
    {
        _CircleModel=model;
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
-(void)PrepareData{
}
-(void)PrepareUI
{
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateInfoImgView];
    [self CreateRemarksView];
}
/**
 * 搭配图视图创建
 */
-(void)CreateInfoImgView
{
    _imgView=[[DD_CircleDailyInfoImgView alloc] initWithCircleModel:_CircleModel WithBlock:^(NSString *type,NSInteger index) {
        _block(type,index);
    }];
    [self addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(ScreenWidth-2*kEdge+48);
    }];
}
/**
 * 创建备注视图
 */
-(void)CreateRemarksView
{
    
    _commentview=[[DD_CircleInfoSuggestView alloc] initWithPlaceHoldStr:@"说点什么吧！" WithBlockType:@"suggest_remarks" WithLimitNum:200 Block:^(NSString *type, NSString *content) {
        if([type isEqualToString:@"num_limit"])
        {
            _block(type,0);
        }else
        {
            _CircleModel.remark=content;
        }
    }];
    [self addSubview:_commentview];
    [_commentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imgView.mas_bottom).with.offset(0);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-30);
    }];
}
@end
