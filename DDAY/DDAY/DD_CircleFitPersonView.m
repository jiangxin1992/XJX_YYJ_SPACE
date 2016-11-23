//
//  DD_CircleFitPersonView.m
//  DDAY
//
//  Created by yyj on 16/6/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleFitPersonView.h"

#import "DD_CircleTagModel.h"
#import "DD_CricleTagItemModel.h"
#import "DD_CircleModel.h"

@implementation DD_CircleFitPersonView
{
    UIView *_upView;
    UIView *_downView;
    NSMutableArray *backViewArr;
    
    CGFloat _width;
    
    MASConstraint *_downView_h;
}
#pragma mark - 初始化
/**
 * 初始化
 */
-(instancetype)initWithCircleModel:(DD_CircleModel *)CircleModel WithBlock:(void (^)(NSString *type,long tag))block
{
    self=[super init];
    if(self)
    {
        _circleModel=CircleModel;
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
-(void)PrepareData
{
    _width=(ScreenWidth-30-40)/4.0f;
    backViewArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
    self.backgroundColor=_define_white_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateUpView];
    [self CreateDownView];
}
-(void)CreateUpView
{
    _upView=[UIView getCustomViewWithColor:nil];
    [self addSubview:_upView];
    [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.mas_equalTo(0);
        make.height.mas_equalTo(@50);
    }];
    
    UILabel *leftLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"适合人群" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [_upView addSubview:leftLabel];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.and.bottom.mas_equalTo(0);
    }];
    
}
-(void)CreateDownView
{
    _downView=[[UIView alloc] init];
    [self addSubview:_downView];
    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(_upView.mas_bottom).with.offset(0);
        _downView_h=make.height.mas_equalTo(100);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
    }];
    
}
#pragma mark - setState
/**
 * 重新设置当前视图
 */
-(void)setState
{
    for (UIView *view in backViewArr) {
        [view removeFromSuperview];
    }
    [_downView_h uninstall];//使该约束失效
    UIView *lastView=nil;
    
    for (int i=0; i<_circleModel.personTags.count; i++)
    {
        DD_CircleTagModel *_tagModel=_circleModel.personTags[i];
        UIView *backView=[[UIView alloc] init];
        [_downView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(0);
            }else
            {
                make.top.mas_equalTo(0);
            }
            make.left.mas_equalTo(kEdge);
            make.right.mas_equalTo(-kEdge);
        }];
        UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:_tagModel.CategoryName WithFont:14.0f WithTextColor:nil WithSpacing:0];
        [backView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.right.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        // 创建一个空view 代表上一个view
        UIButton *lastBtn = nil;
        // 间距为10
        int intes = 10;
        // 第几行
        int num = 0;
        CGFloat _x_p=0;
        // 循环创建view
        for (int j=0; j<_tagModel.tags.count; j++) {
            DD_CricleTagItemModel *item=_tagModel.tags[j];
            UIButton *btn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0f WithSpacing:0 WithNormalTitle:item.tagName WithNormalColor:_define_black_color WithSelectedTitle:item.tagName WithSelectedColor:_define_white_color];
            [backView addSubview:btn];
            btn.tag=100*i+j;
            [regular setBorder:btn];
            if(item.is_select)
            {
                btn.selected=item.is_select;
                btn.backgroundColor=_define_black_color;
            }else
            {
                btn.selected=item.is_select;
                btn.backgroundColor=_define_white_color;
            }
            
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat __width=[regular getWidthWithHeight:28 WithContent:item.tagName WithFont:[regular getFont:13.0f]]+25;
            
            
            if((_x_p+__width+intes)>ScreenWidth-2*kEdge)
            {
                num++;
                _x_p=0;
            }
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(btn.superview).offset(40+35*num);
                
                make.left.mas_equalTo(_x_p);
                make.width.mas_equalTo(__width);
                make.height.mas_equalTo(28);
            }];
            if((_x_p+__width+intes)>ScreenWidth-2*kEdge)
            {
            }else
            {
                _x_p+=__width+intes;
            }
            
            lastBtn = btn;
        }
        if(lastBtn)
        {
            [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-10);
            }];
        }else
        {
            [backView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }
        lastView=backView;
        [backViewArr addObject:backView];
    }
    if(lastView)
    {
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
    }else
    {
        [_downView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    
}
#pragma mark - SomeAction
/**
 * 按钮点击
 */
-(void)btnAction:(UIButton *)btn
{
    NSInteger _index=btn.tag/100;
    NSInteger _row=btn.tag%100;
    DD_CircleTagModel *_tagModel=_circleModel.personTags[_index];
    DD_CricleTagItemModel *item=_tagModel.tags[_row];
    if(btn.selected)
    {
        item.is_select=NO;
        _block(@"person_tag_delete",btn.tag);
    }else
    {
        for (DD_CricleTagItemModel *__item in _tagModel.tags) {
            __item.is_select=NO;
        }
        item.is_select=YES;
        _block(@"person_tag_add",btn.tag);
    }
}
@end
