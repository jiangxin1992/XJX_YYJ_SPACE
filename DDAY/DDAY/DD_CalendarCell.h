//
//  DD_CalendarCell.h
//  YCO SPACE
//
//  Created by yyj on 16/8/25.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DrawView.h"

#import "DD_MonthModel.h"

@interface DD_CalendarCell : UICollectionViewCell

@property (weak, nonatomic) UILabel *dayLabel;

@property (strong, nonatomic) DD_MonthModel *monthModel;

__array(SeriesArr);

@end
