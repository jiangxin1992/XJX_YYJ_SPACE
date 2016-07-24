//
//  DD_CircleListSuggestView.m
//  DDAY
//
//  Created by yyj on 16/6/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleListSuggestView.h"

@implementation DD_CircleListSuggestView
{
    UILabel *suggest;//搭配建议
}
-(instancetype)initWithCircleListModel:(DD_CircleListModel *)model WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _detailModel=model;
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
    suggest=[[UILabel alloc]init];
    [self addSubview:suggest];
    suggest.numberOfLines=0;
    suggest.textAlignment=0;
    suggest.font=[regular getFont:13.0f];
    suggest.textColor=[UIColor lightGrayColor];
    [suggest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
}
-(void)setDetailModel:(DD_CircleListModel *)detailModel
{
    
    _detailModel=detailModel;
    [self setState];
}
#pragma mark - setState
-(void)setState
{
    if(_detailModel)
    {
        [suggest mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_detailModel.suggestHeight);
        }];
        suggest.text=_detailModel.shareAdvise;
    }
    
}
@end
