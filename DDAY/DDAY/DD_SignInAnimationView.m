//
//  DD_SignInAnimationView.m
//  YCO SPACE
//
//  Created by yyj on 2016/11/16.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_SignInAnimationView.h"

@implementation DD_SignInAnimationView
{
    CGRect _startRect;
    CGRect _endRect;
    
    UILabel *_labelView;
}

static DD_SignInAnimationView *animationView = nil;

#pragma mark - 创建单例
+(id)sharedManagerWithBlock:(void (^)(NSString *))block
{
    //    创建CustomTabbarController的单例，并通过此方法调用
    //    互斥锁，确保单例只能被创建一次
    @synchronized(self)
    {
        if (!animationView) {
            animationView = [[DD_SignInAnimationView alloc]initWithBlock:block];
        }
    }
    return animationView;
}


- (instancetype)initWithBlock:(void (^)(NSString *))block
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        _block=block;
        _animationStarting=NO;
        _startRect=CGRectMake(ScreenWidth, kNavHeight+24, 144, 62);
        _endRect=CGRectMake((ScreenWidth-144)/2.0f, kNavHeight+24, 144, 62);
        
        _labelView=[UILabel getLabelWithAlignment:1 WithTitle:@"每日登录积分 +1" WithFont:14.0f WithTextColor:nil WithSpacing:0];
        [self addSubview:_labelView];
        _labelView.backgroundColor=_define_white_color;
        _labelView.alpha=1;
        _labelView.hidden=YES;
    }
    return self;
}

-(void)startAnimation
{
    _animationStarting=YES;
    _labelView.hidden=NO;
    _labelView.alpha=1;
    _labelView.frame=_startRect;
    [DD_UserModel regisnDailyIntegral];
    [UIView animateWithDuration:0.25 animations:^{
        _labelView.frame=_endRect;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 2秒后异步执行这里的代码...
            [UIView animateWithDuration:0.5 animations:^{
                _labelView.alpha=0;
            } completion:^(BOOL finished) {
                _animationStarting=NO;
                _labelView.hidden=NO;
                _labelView.alpha=1;
                _labelView.frame=_startRect;
                _block(@"end");
            }];
        });
        
    }];
}

@end
