//
//  DD_CalendarCell.m
//  YCO SPACE
//
//  Created by yyj on 16/8/25.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CalendarCell.h"

#define cellWH floor((ScreenWidth-40)/7)

@implementation DD_CalendarCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        DrawView *drawView=[[DrawView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        [self.contentView addSubview:drawView];
        drawView.type=3;
        self.backView=drawView;
        
        CGFloat width = self.contentView.frame.size.width*0.8;
        CGFloat height = self.contentView.frame.size.height*0.8;
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake( self.contentView.frame.size.width*0.5-width*0.5,  self.contentView.frame.size.height*0.5-height*0.5, width, height )];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.layer.masksToBounds = YES;
        dayLabel.layer.cornerRadius = height/2.0f;
        
        [drawView addSubview:dayLabel];
        self.dayLabel = dayLabel;
        
    }
    return self;
}

- (void)setMonthModel:(DD_MonthModel *)monthModel{
    _monthModel = monthModel;
    NSString *dasdads=[NSString stringWithFormat:@"%02ld",monthModel.dayValue];
    self.dayLabel.text = dasdads;
    if (monthModel.isSelectedDay) {
        self.dayLabel.backgroundColor = [UIColor blackColor];
        self.dayLabel.textColor = [UIColor whiteColor];
    }else
    {
        self.dayLabel.backgroundColor = [UIColor whiteColor];
        if([monthModel.week integerValue]%7==0||[monthModel.week integerValue]%6==0)
        {
            self.dayLabel.textColor = [UIColor lightGrayColor];
        }else
        {
            self.dayLabel.textColor = [UIColor blackColor];
        }
    }
    self.backView.width=2;
    self.backView.pointArr=@[
                             @{@"colorCode":@"#EE2C2C",@"pointarr":@[@{@"y_p":@"3",@"x_p":@"0"}
                                                                     ,@{@"y_p":@"3",@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                                                     ]},
                             @{@"colorCode":@"#C0FF3E",@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-3],@"x_p":@"0"},@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-3],@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}]}
                             ];
    [self.backView Update];
}
@end
