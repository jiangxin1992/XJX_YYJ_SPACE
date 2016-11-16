//
//  DD_DailyIntegralView.m
//  YCO SPACE
//
//  Created by yyj on 2016/11/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DailyIntegralView.h"

#define  _height [regular getHeightWithWidth:9999 WithContent:@"wqdqd" WithFont:[regular getFont:15.0f]]

@implementation DD_DailyIntegralView
{
    UILabel *_contentLabel;
    UIView *_upview;
    
    CGRect _upFrame;
    CGRect _downFrame;
}

-(instancetype)initDailyIntegralView
{
    self=[super init];
    
    if(self)
    {
        _animationStarting=NO;
        _upFrame=CGRectMake(0, 0, [regular getWidthWithHeight:_height WithContent:@"每日登录积分+1" WithFont:[regular getFont:13.0f]], _height);
        _downFrame=CGRectMake(0, _height, [regular getWidthWithHeight:_height WithContent:@"每日登录积分+1" WithFont:[regular getFont:13.0f]]+6, _height);
        
        _contentLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"每日登录积分+1" WithFont:13.0f WithTextColor:_define_white_color WithSpacing:0];
        [self addSubview:_contentLabel];
        _contentLabel.backgroundColor=_define_light_gray_color1;
        _contentLabel.hidden=YES;
        _contentLabel.frame=_upFrame;
        
        _upview=[UIView getCustomViewWithColor:_define_white_color];
        [self addSubview:_upview];
        _upview.hidden=YES;
        [_upview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(_height);
        }];
        
    }
    return self;
}

-(void)startAnimation
{
    if(![DD_UserModel haveDailyIntegral])
    {
        if(!_animationStarting)
        {
            _animationStarting=YES;
            _upview.hidden=NO;
            _contentLabel.hidden=NO;
            _contentLabel.alpha=1;
            _contentLabel.frame=_upFrame;
            [DD_UserModel regisnDailyIntegral];
            [UIView animateWithDuration:1 animations:^{
                _contentLabel.frame=_downFrame;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1.5 animations:^{
                    _contentLabel.alpha=0;
                } completion:^(BOOL finished) {
                    _animationStarting=NO;
                    _contentLabel.hidden=NO;
                    _upview.hidden=YES;
                }];
            }];
        }
    }
}
@end
