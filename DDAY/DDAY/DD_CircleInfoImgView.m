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
    NSMutableArray *btnArr;
    
    CGFloat _width;
    
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
    _width=(ScreenWidth-50)/4.0f;
    btnArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
    self.backgroundColor=[UIColor whiteColor];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    _downView=[[UIView alloc] init];
    [self addSubview:_downView];
    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(_width+20);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
    }];
}


#pragma mark - SomeAction
/**
 * 重新设置当前视图
 */
-(void)setState
{
    for (UIButton *btn in btnArr) {
        [btn removeFromSuperview];
    }
    
//    System_Big_Issue
    NSInteger _count=0;
    if(_circleModel.picArr.count)
    {
        if(_circleModel.picArr.count<8)
        {
            _count=_circleModel.picArr.count+1;
        }else
        {
            _count=_circleModel.picArr.count;
        }
    }else
    {
        _count=1;
        
        
    }
    
    
    CGFloat _h=0;
    if(_circleModel.picArr.count)
    {
        _h=(_width+10)*(((_count-1)/4)+1)+10;
    }else
    {
        _h=_width+20;
    }
    [_downView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_h);
    }];
    
    // 创建一个空view 代表上一个view
    __block UIView *lastView = nil;
    // 间距为10
    int intes = 10;
    // 每行4个
    int num = 4;
    // 循环创建view
    
    for (int i = 0; i < _count; i++) {
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.tag=100+i;
        view.backgroundColor=_define_backview_color;
        [_downView addSubview:view];
        if(_circleModel.picArr.count<_count)
        {
            if(i<_count-1)
            {
                NSDictionary *dict=[_circleModel.picArr objectAtIndex:i];
                [view setBackgroundImage:[dict objectForKey:@"data"] forState:UIControlStateNormal];
                [view addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
            }else
            {
                [view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [view setTitle:@"增加" forState:UIControlStateNormal];
                [view addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
            }
        }else
        {
            NSDictionary *dict=[_circleModel.picArr objectAtIndex:i];
            [view setBackgroundImage:[dict objectForKey:@"data"] forState:UIControlStateNormal];
            [view addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        // 添加约束
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            // 给个高度约束
            make.height.and.width.mas_equalTo(_width);
                // 2. 判断是否是第一列
            if (i % num == 0) {
                // 一：是第一列时 添加左侧与父视图左侧约束
                make.left.mas_equalTo(view.superview).offset(intes);
            } else {
                // 二： 不是第一列时 添加左侧与上个view左侧约束
                make.left.mas_equalTo(lastView.mas_right).offset(intes);
            }
            // 3. 判断是否是最后一列 给最后一列添加与父视图右边约束
            if (i % num == (num - 1)) {
                make.right.mas_equalTo(view.superview).offset(-intes);
            }
            // 4. 判断是否为第一列
            if (i / num == 0) {
                // 第一列添加顶部约束
                make.top.mas_equalTo(view.superview).offset(10);
            } else {
                // 其余添加顶部约束 intes*10 是我留出的距顶部高度
                make.top.mas_equalTo(10 + ( i / num )* (_width + intes));
            }
        }];
        // 每次循环结束 此次的View为下次约束的基准
        lastView = view;
        [btnArr addObject:view];
    }
    if(lastView)
    {
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
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
 * 添加当前搭配图
 */
-(void)addAction
{
    _block(@"choose_pic",0);
}
@end
