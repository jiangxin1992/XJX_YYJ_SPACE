//
//  DD_CircleDailyInfoImgView.m
//  YCO SPACE
//
//  Created by yyj on 16/9/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleDailyInfoImgView.h"

#import "DD_CircleModel.h"

@implementation DD_CircleDailyInfoImgView
{
    
    UIView *_downView;
    UIButton *middleBtn;
    
    CGFloat _width;
    UIButton *imgBtn;
}
#pragma mark - 初始化
/**
 * 初始化
 */
-(instancetype)initWithCircleModel:(DD_CircleModel *)CircleModel WithBlock:(void (^)(NSString *type,NSInteger index))block
{
    
    self=[super init];
    if(self)
    {
        _circleModel=CircleModel;
        _block=block;
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
-(void)PrepareData
{
    _width=ScreenWidth-kEdge*2;
}
-(void)PrepareUI
{
    self.backgroundColor=_define_white_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    _downView=[[UIView alloc] init];
    [self addSubview:_downView];
    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    UILabel *imgTitle=[UILabel getLabelWithAlignment:0 WithTitle:@"添加搭配图" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [_downView addSubview:imgTitle];
    [imgTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    [imgTitle sizeToFit];
}


#pragma mark - SomeAction
-(void)removeUI
{
    [imgBtn removeFromSuperview];
    if(middleBtn)
    {
        middleBtn.hidden=YES;
    }
}
/**
 * 重新设置当前视图
 */
-(void)setState
{
    [self removeUI];
    if(!_circleModel.picArr.count)
    {
        if(!middleBtn)
        {
            middleBtn=[UIButton getCustomImgBtnWithImageStr:@"System_Big_Issue" WithSelectedImageStr:@"System_Big_Issue"];
            [_downView addSubview:middleBtn];
            [middleBtn setEnlargeEdge:50];
            [middleBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
            [middleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(_downView.center);
                make.height.width.mas_equalTo(35);
            }];
        }else
        {
            middleBtn.hidden=NO;
        }
        
    }else
    {
        imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSDictionary *dict=[_circleModel.picArr objectAtIndex:0];
        [imgBtn setImage:[dict objectForKey:@"data"] forState:UIControlStateNormal];
        [imgBtn setImageEdgeInsets:UIEdgeInsetsMake(16, 0, 0, 16)];
        imgBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imgBtn addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
        imgBtn.tag=100;
        [_downView addSubview:imgBtn];
        [imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(16);
            make.bottom.mas_equalTo(-16);
            make.left.mas_equalTo(kEdge);
            make.right.mas_equalTo(-kEdge+16);
        }];
        
        UIButton *deleteBtn=[UIButton getCustomImgBtnWithImageStr:@"System_Delete" WithSelectedImageStr:nil];
        [imgBtn addSubview:deleteBtn];
        deleteBtn.tag=150;
        [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setEnlargeEdge:10];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(3.5);
            make.right.mas_equalTo(-3.5);
            make.width.height.mas_equalTo(25);
        }];
    }
}
/**
 * 显示当前搭配图
 */
-(void)showAction:(UIButton *)btn
{
    _block(@"show_pic",btn.tag-100);
}
/**
 * 删除
 */
-(void)deleteAction:(UIButton *)btn
{
    _block(@"delete_pic",btn.tag-150);
}
/**
 * 添加当前搭配图
 */
-(void)addAction
{
    _block(@"choose_pic",0);
}
@end
