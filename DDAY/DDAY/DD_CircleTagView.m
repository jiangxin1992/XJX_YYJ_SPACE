//
//  DD_CircleTagView.m
//  YCO SPACE
//
//  Created by yyj on 16/9/5.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleTagView.h"

#import "DD_CricleTagItemModel.h"
#import "DD_CircleListModel.h"

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
        __block CGFloat _x_p=0;
        __block int num = 0;
        // 间距为10
        __block int intes = 10;
        
        [_tagArr enumerateObjectsUsingBlock:^(DD_CricleTagItemModel *item, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *label=[UILabel getLabelWithAlignment:1 WithTitle:item.tagName WithFont:13.0f WithTextColor:_define_white_color WithSpacing:0];
            [self addSubview:label];
            label.backgroundColor=_define_black_color;
            CGFloat __width=[regular getWidthWithHeight:28 WithContent:item.tagName WithFont:[regular getFont:13.0f]]+25;
            if((_x_p+__width+intes)>ScreenWidth-2*kEdge)
            {
                num++;
                _x_p=0;
            }
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self).offset((28+intes)*num);
                make.left.mas_equalTo(_x_p);
                make.width.mas_equalTo(__width);
                make.height.mas_equalTo(28);
            }];
            if((_x_p+__width+intes)>ScreenWidth-2*kEdge)
            {
            }else
            {
                _x_p+=__width+intes;
            }
            _lastView=label;
        }];

    }
}
+(CGFloat)GetHeightWithTagArr:(NSArray *)tagArr
{
    DD_CircleTagView *_sizeView = [[DD_CircleTagView alloc] initWithTagArr:tagArr];
    [_sizeView layoutIfNeeded];
    CGRect frame =  _sizeView.lastView.frame;
    return frame.origin.y + frame.size.height+28;
}
@end
