//
//  DD_CirlcleApplyDesignerChooseView.m
//  DDAY
//
//  Created by yyj on 16/6/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CirlcleApplyDesignerChooseView.h"

@implementation DD_CirlcleApplyDesignerChooseView
{
    UIButton *_designerBtn;
}
#pragma mark - 初始化
-(instancetype)initWithFavouriteDesignerModel:(DD_CircleFavouriteDesignerModel *)designerModel WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _designerModel=designerModel;
        [self SomePrepare];
        [self UIConfig];
        [self setState];
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
    _designerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_designerBtn];
    [_designerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_designerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [_designerBtn setTitle:@"*你最喜欢的独立设计师" forState:UIControlStateSelected];
    
    _designerBtn.titleLabel.font=[regular getFont:14.0f];
    _designerBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [_designerBtn addTarget:self action:@selector(ChooseDesigner) forControlEvents:UIControlEventTouchUpInside];
    
    [_designerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(60);
        make.top.and.bottom.mas_equalTo(0);
    }];
}
#pragma mark - SomeAction
-(void)setState
{
    if([_designerModel.likeDesignerId isEqualToString:@""])
    {
        _designerBtn.selected=YES;
    }else
    {
        [_designerBtn setTitle:_designerModel.likeDesignerName forState:UIControlStateNormal];
        _designerBtn.selected=NO;
    }
    
}
-(void)ChooseDesigner
{
    _block(@"choose_designer");
}
@end
