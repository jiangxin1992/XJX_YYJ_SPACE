//
//  DD_GoodsListView.m
//  YCO SPACE
//
//  Created by yyj on 16/8/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsListView.h"

@implementation DD_GoodsListView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置normal状态下 title的颜色
        [self setTitleColor:_define_black_color forState:UIControlStateNormal];
        self.titleLabel.textAlignment=2;
        //设置字体大小
        self.titleLabel.font=[regular getSemiboldFont:17.0f];
    }
    return self;
}
//62 56
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, 80, 40);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(90, 13, 15, 14);
}
@end
