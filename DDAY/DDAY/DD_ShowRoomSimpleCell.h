//
//  DD_ShowRoomSimpleCell.h
//  YCO SPACE
//
//  Created by yyj on 16/9/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DD_ShowRoomModel;

@interface DD_ShowRoomSimpleCell : UITableViewCell

@property (nonatomic,strong) DD_ShowRoomModel *showRoomModel;

+ (CGFloat)heightWithModel:(DD_ShowRoomModel *)model;

__label(address);

@end
