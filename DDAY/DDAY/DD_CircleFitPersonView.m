//
//  DD_CircleFitPersonView.m
//  DDAY
//
//  Created by yyj on 16/6/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_CircleTagModel.h"
#import "DD_CricleTagItemModel.h"
#import "DD_CircleFitPersonView.h"

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
    self.backgroundColor=[UIColor whiteColor];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateUpView];
    [self CreateDownView];
}
-(void)CreateUpView
{
    _upView=[[UIView alloc] init];
    [self addSubview:_upView];
    [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.mas_equalTo(0);
        make.height.mas_equalTo(@50);
    }];
    
    UILabel *leftLabel=[[UILabel alloc] init];
    [_upView addSubview:leftLabel];
    leftLabel.textAlignment=0;
    leftLabel.textColor=[UIColor lightGrayColor];
    leftLabel.text=@"适合人群";
    leftLabel.font=[regular getFont:14.0f];
    
    UIView *_xian=[[UIView alloc] init];
    [_upView addSubview:_xian];
    _xian.backgroundColor=_define_backview_color;
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.and.bottom.mas_equalTo(0);
    }];
    
    [_xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-1);
        make.height.mas_equalTo(@1);
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
        DD_CircleTagModel *_tagModel=[_circleModel.personTags objectAtIndex:i];
        UIView *backView=[[UIView alloc] init];
        [_downView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(10);
            }else
            {
                make.top.mas_equalTo(10);
            }
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
        }];
        UILabel *titleLabel=[[UILabel alloc] init];
        [backView addSubview:titleLabel];
        titleLabel.font=[regular getFont:15.0f];
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.textAlignment=0;
        titleLabel.text=_tagModel.CategoryName;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.right.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        // 创建一个空view 代表上一个view
        UIButton *lastBtn = nil;
        // 间距为10
        int intes = 10;
        // 每行4个
        int num = 4;
        CGFloat width=(ScreenWidth-40-30)/4.0f;
        // 循环创建view
        for (int j=0; j<_tagModel.tags.count; j++) {
            DD_CricleTagItemModel *item=[_tagModel.tags objectAtIndex:j];
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            if(item.is_select)
            {
                btn.selected=item.is_select;
                btn.backgroundColor=[UIColor blackColor];
            }else
            {
                btn.selected=item.is_select;
                btn.backgroundColor=[UIColor whiteColor];
            }
            
            [backView addSubview:btn];
            btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
            btn.tag=100*i+j;
            [regular drawLayerWithView:btn WithR:5 WithColor:[UIColor blackColor]];
            
            [btn setTitle:item.tagName forState:UIControlStateNormal];
            [btn setTitle:item.tagName forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                // 给个高度约束
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(@40);
                // 2. 判断是否是第一列
                if (j % num == 0) {
                    // 一：是第一列时 添加左侧与父视图左侧约束
                    make.left.mas_equalTo(btn.superview).offset(0);
                } else {
                    // 二： 不是第一列时 添加左侧与上个view左侧约束
                    make.left.mas_equalTo(lastBtn.mas_right).offset(intes);
                }
                // 3. 判断是否是最后一列 给最后一列添加与父视图右边约束
                if (j % num == (num - 1)) {
                    make.right.mas_equalTo(btn.superview).offset(0);
                }
                // 4. 判断是否为第一列
                if (j / num == 0) {
                    // 第一列添加顶部约束
                    make.top.mas_equalTo(btn.superview).offset(30);
                } else {
                    // 其余添加顶部约束 intes*10 是我留出的距顶部高度
                    make.top.mas_equalTo(30 + ( j / num )* (40 + intes));
                }
            }];
            // 每次循环结束 此次的View为下次约束的基准
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
            make.bottom.mas_equalTo(-20);
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
    DD_CircleTagModel *_tagModel=[_circleModel.personTags objectAtIndex:_index];
    DD_CricleTagItemModel *item=[_tagModel.tags objectAtIndex:_row];
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
