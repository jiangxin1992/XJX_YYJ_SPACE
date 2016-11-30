//
//  DD_CustomContentView.m
//  YCO SPACE
//
//  Created by yyj on 2016/11/10.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CustomContentView.h"

@implementation DD_CustomContentView
{
    UIImageView *imgView;
    UILabel *titleLabel;
}

-(instancetype)initCustomViewWithTitle:(NSString *)title WithImg:(NSString *)img
{
    self=[super init];
    if(self)
    {
        CGFloat _width=floor([regular getWidthWithHeight:35 WithContent:title WithFont:[regular getFont:15.0f]]+35+13);
        self.size=CGSizeMake(_width, 25);
        
        imgView=[UIImageView getImgWithImageStr:img];
        [self addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            if([img isEqualToString:@"Order_Return"])
            {
                make.width.mas_equalTo(floor((26.0f/21.0f)*25.0f));
            }else
            {
                make.width.mas_equalTo(25);
            }
        }];
        
        titleLabel=[UILabel getLabelWithAlignment:2 WithTitle:title WithFont:15.0f WithTextColor:nil WithSpacing:0];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.top.mas_equalTo(0);
            make.left.mas_equalTo(imgView.mas_right).with.offset(0);
        }];
    }
    return self;
}

@end
