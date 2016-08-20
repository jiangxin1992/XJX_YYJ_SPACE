//
//  DD_drawManageView.m
//  YCO SPACE
//
//  Created by yyj on 16/7/28.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DrawManageView.h"

#import "DrawView.h"

@implementation DD_DrawManageView{
    UIView *backview;
    NSMutableArray *viewArr;
}
-(instancetype)initWithImgCount:(NSInteger)imgCount
{
    self=[super init];
    if(self){
        viewArr=[[NSMutableArray alloc] init];
        _imgCount=imgCount;
        [self UIConfig];
        
    }
    return self;
}
#pragma mark - UIConfig
-(void)UIConfig{
    [self CreateBackView];
    [self CreateDrawItem];
}
-(void)CreateBackView{
    backview=[UIView getCustomViewWithColor:nil];
//    Item_Frame
    [self addSubview:backview];
    backview.contentMode=UIViewContentModeScaleAspectFit;
    CGFloat height=_imgCount*12+(_imgCount-1)*5;
    [backview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(height);
        make.center.mas_equalTo(self);
    }];
}
-(void)CreateDrawItem
{
    CGFloat _x_p=((IsPhone6_gt?60:49)-16)/2.0f;
    CGFloat _y_p=0;
    for (int i=0; i<_imgCount; i++) {
        DrawView *drawView=[[DrawView alloc] initWithFrame:CGRectMake(_x_p, i*17,16, 12) WithStartP:CGPointMake(0, 4.5) WithEndP:CGPointMake(16, 4.5) WithLineWidth:3 WithColorType:1];
        [backview addSubview:drawView];
        _y_p+=17;
        [viewArr addObject:drawView];
    }
    [self changeSelectNum:0];
}
#pragma mark - Action
-(void)changeSelectNum:(NSInteger )selectNum{
    CGFloat _x_p=((IsPhone6_gt?60:49)-16)/2.0f;
    for (int i=0; i<viewArr.count; i++) {
        DrawView *drawView=[viewArr objectAtIndex:i];
        if(selectNum==i)
        {
            if(drawView.type==1)
            {
                [drawView removeFromSuperview];
                [viewArr removeObjectAtIndex:i];
                drawView=[[DrawView alloc] initWithFrame:CGRectMake(_x_p, i*17,16, 12) WithStartP:CGPointMake(2, 2) WithEndP:CGPointMake(14, 10) WithLineWidth:3 WithColorType:2];
                [backview addSubview:drawView];
                [viewArr insertObject:drawView atIndex:i];
            }
        }else
        {
            if(drawView.type==2)
            {
                [drawView removeFromSuperview];
                [viewArr removeObjectAtIndex:i];
                drawView=[[DrawView alloc] initWithFrame:CGRectMake(_x_p, i*17,16, 12) WithStartP:CGPointMake(0, 4.5) WithEndP:CGPointMake(16, 4.5) WithLineWidth:3 WithColorType:1];
                [backview addSubview:drawView];
                [viewArr insertObject:drawView atIndex:i];
            }
        }
    }
}



@end
