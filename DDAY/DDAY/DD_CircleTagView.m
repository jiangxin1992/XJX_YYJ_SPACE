//
//  DD_CircleTagView.m
//  YCO SPACE
//
//  Created by yyj on 16/9/5.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleTagView.h"

#import "DD_CricleTagItemModel.h"

@implementation DD_CircleTagView

-(instancetype)initWithTagArr:(NSArray *)tagArr
{
    self=[super init];
    if(self)
    {
        _tagArr=tagArr;
        [self UIConfig];
    }
    return self;
}
-(void)setState
{
    [self UIConfig];
}
-(void)UIConfig
{
    if(_tagArr.count)
    {
        UIView *lastView=nil;
        CGFloat _x_p=0;
        CGFloat _y_p=0;
        for (int i=0; i<_tagArr.count; i++) {

            DD_CricleTagItemModel *item=[_tagArr objectAtIndex:i];
            UILabel *label=[UILabel getLabelWithAlignment:1 WithTitle:item.tagName WithFont:13.0f WithTextColor:_define_white_color WithSpacing:0];
            [self addSubview:label];
            label.backgroundColor=_define_black_color;
            CGFloat _width=[regular getWidthWithHeight:28 WithContent:item.tagName WithFont:[regular getFont:13.0f]]+25;
            label.frame=CGRectMake(_x_p, _y_p, _width, 28);
            if((_x_p+_width+10)>ScreenWidth-2*kEdge)
            {
                _x_p=0;
                _y_p+=28+10;
            }else
            {
                _x_p+=_width+10;
            }
            lastView=label;
        }
        
        _height=_y_p+28;
    }
}
@end
