//
//  DD_ShowRoomSimpleCell.h
//  YCO SPACE
//
//  Created by yyj on 16/9/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseCell.h"

@class DD_ShowRoomModel;

@interface DD_ShowRoomSimpleCell : DD_BaseCell

@property (nonatomic,strong) DD_ShowRoomModel *showRoomModel;

/** 是否有多个体验店（区别为黑线）*/
__bool(showDownLine);

@end
