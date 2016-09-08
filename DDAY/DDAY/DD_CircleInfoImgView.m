//
//  DD_CircleInfoImgView.m
//  DDAY
//
//  Created by yyj on 16/6/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleInfoImgView.h"

@implementation DD_CircleInfoImgView
{
    
    UIView *_downView;
    UIButton *middleBtn;
    
    NSMutableArray *btnArr;
    
    CGFloat _width;
    CGFloat intes;
    
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
    intes=12;//间距为12
    _width=(ScreenWidth-intes*2-kEdge*2)/3.0f;
    btnArr=[[NSMutableArray alloc] init];
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
    for (UIView *view in btnArr) {
        [view removeFromSuperview];
    }
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
        //    224  220
        // 创建一个空view 代表上一个view
        __block UIView *lastView = nil;
        // 每行3个
        int num = 3;
        NSInteger _count=0;
        // 循环创建view
        if(_circleModel.picArr.count<6)
        {
            _count=_circleModel.picArr.count+1;
        }else
        {
            _count=_circleModel.picArr.count;
        }
        for (int i = 0; i < _count; i++) {
            UIView *backView=[UIView getCustomViewWithColor:nil];
            [_downView addSubview:backView];
            // 添加约束
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                // 给个高度约束
                make.height.and.width.mas_equalTo(_width);
                // 2. 判断是否是第一列
                if (i % num == 0) {
                    // 一：是第一列时 添加左侧与父视图左侧约束
                    make.left.mas_equalTo(backView.superview).offset(kEdge);
                } else {
                    // 二： 不是第一列时 添加左侧与上个view左侧约束
                    make.left.mas_equalTo(lastView.mas_right).offset(intes);
                }
                // 4. 判断是否为第一列
                if (i / num == 0) {
                    // 第一列添加顶部约束
                    make.top.mas_equalTo(backView.superview).offset(20);
                } else {
                    // 其余添加顶部约束 intes*10 是我留出的距顶部高度
                    make.top.mas_equalTo(20+( i / num )* (_width + intes));
                }
            }];
            
            UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imgBtn.tag=100+i;
            BOOL _has_delete=YES;
            if(_circleModel.picArr.count<_count)
            {
                if(i<_count-1)
                {
                    NSDictionary *dict=[_circleModel.picArr objectAtIndex:i];
                    [imgBtn setImage:[dict objectForKey:@"data"] forState:UIControlStateNormal];
                    [imgBtn setImageEdgeInsets:UIEdgeInsetsMake(16, 0, 0, 16)];
                    imgBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
                    [imgBtn addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
                }else
                {
                    
                    [imgBtn setImage:[UIImage imageNamed:@"System_Big_Issue"] forState:UIControlStateNormal];
                    CGFloat _in = (_width-3.5-12.5-35)/2.0f;
                    [imgBtn setImageEdgeInsets:UIEdgeInsetsMake(_in+16, _in, _in, _in+16)];
                    [imgBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
                    _has_delete=NO;
                }
            }else
            {
                NSDictionary *dict=[_circleModel.picArr objectAtIndex:i];
                [imgBtn setImage:[dict objectForKey:@"data"] forState:UIControlStateNormal];
                [imgBtn setImageEdgeInsets:UIEdgeInsetsMake(16, 0, 0, 16)];
                [imgBtn addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            [backView addSubview:imgBtn];
            
            [imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(backView);
            }];
            if(_has_delete)
            {
                UIButton *deleteBtn=[UIButton getCustomImgBtnWithImageStr:@"System_Delete" WithSelectedImageStr:nil];
                [imgBtn addSubview:deleteBtn];
                deleteBtn.tag=150+i;
                [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
                [deleteBtn setEnlargeEdge:10];
                [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(3.5);
                    make.right.mas_equalTo(-3.5);
                    make.width.height.mas_equalTo(25);
                }];
            }
            // 每次循环结束 此次的View为下次约束的基准
            lastView = backView;
            [btnArr addObject:backView];
        }

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
