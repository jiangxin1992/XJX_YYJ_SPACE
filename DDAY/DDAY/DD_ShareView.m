//
//  DD_ShareView.m
//  YCO SPACE
//
//  Created by yyj on 16/8/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShareView.h"

@implementation DD_ShareView

-(instancetype)initWithContent:(NSString *)CONTENT WithImg:(NSString *)img
{
    self=[super init];
    if(self)
    {
        [self UIConfig];
    }
    return self;
}
-(void)UIConfig
{
    UILabel *labelTitle=[UILabel getLabelWithAlignment:2 WithTitle:@"分享到" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(83);
        make.left.mas_equalTo(0);
    }];
    [labelTitle sizeToFit];
    
    NSArray *imgArr=@[@"System_Weixin",@"System_Friendcircle",@"System_Weibo",@"System_QQ",@"System_Copylink"];
    CGFloat _jiange=(ScreenWidth-50*4-(IsPhone6_gt?35:25)*2)/3.0f;
    UIView *lastView=nil;
    for (int i=0; i<imgArr.count; i++) {
        
    }
    
    
    UIButton *cancelBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"取   消" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(ktabbarHeight);
    }];
    
}
-(void)cancelAction{}
@end
