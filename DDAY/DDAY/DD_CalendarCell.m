//
//  DD_CalendarCell.m
//  YCO SPACE
//
//  Created by yyj on 16/8/25.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CalendarCell.h"

#import "DD_CalendarTool.h"

#define cellWH floor(([UIScreen mainScreen].bounds.size.width-40-12)/7)

@implementation DD_CalendarCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGFloat width = floor(self.contentView.frame.size.width*0.90);
        CGFloat height = floor(self.contentView.frame.size.width*0.90);
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake( self.contentView.frame.size.width*0.5-width*0.5,  self.contentView.frame.size.height*0.5-height*0.5, width, height )];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.layer.masksToBounds = YES;
        dayLabel.layer.cornerRadius = height/2.0f;
        
        [self.contentView addSubview:dayLabel];
        self.dayLabel = dayLabel;
        
    }
    return self;
}
-(void)setMonthModel:(DD_MonthModel *)monthModel
{
    _monthModel=monthModel;
    self.dayLabel.text = [NSString stringWithFormat:@"%02ld",monthModel.dayValue];
    if (monthModel.isSelectedDay) {
        self.dayLabel.backgroundColor = [UIColor blackColor];
        self.dayLabel.textColor = [UIColor whiteColor];
    }else
    {
        self.dayLabel.backgroundColor = [UIColor clearColor];
        if([monthModel.week integerValue]%7==0||[monthModel.week integerValue]%6==0)
        {
            self.dayLabel.textColor = [UIColor lightGrayColor];
        }else
        {
            self.dayLabel.textColor = [UIColor blackColor];
        }
    }
    
}


@end
