//
//  DD_ChooseSizeView.h
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//
//#import "DD_GoodsDetailModel.h"
#import <UIKit/UIKit.h>

@interface DD_ChooseSizeView : UIView
-(instancetype)initWithSizeArr:(NSArray *)sizeArr WithColorID:(NSString *)colorID WithBlock:(void (^)(NSString *type,NSString *sizeid,NSString *colorid,NSInteger count))block;
@property (nonatomic,copy) void (^block)(NSString *type,NSString *sizeid,NSString *colorid,NSInteger count);
__array(sizeArr);
__string(colorid);
@end
