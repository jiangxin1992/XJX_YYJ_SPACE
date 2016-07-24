//
//  DD_DDAYMeetViewController.h
//  DDAY
//
//  Created by yyj on 16/6/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@interface DD_DDAYMeetViewController : DD_BaseViewController
-(instancetype)initWithType:(NSString *)type WithSeriesID:(NSString *)SeriesID WithBlock:(void(^)(NSString *type))meetBlock;
__block_type(meetBlock, type);
__string(Type);
__string(SeriesID);
@end
