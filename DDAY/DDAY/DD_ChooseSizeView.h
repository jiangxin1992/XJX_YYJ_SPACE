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
-(instancetype)initWithFrame:(CGRect)frame WithSizeArr:(NSArray *)sizeArr WithColorID:(NSString *)colorID WithType:(NSString *)type WithBlock:(void (^)(NSString *type,NSString *sizeid,NSString *colorid))block;
@property (nonatomic,copy) void (^block)(NSString *type,NSString *sizeid,NSString *colorid);
__array(sizeArr);
__string(type);
__string(colorid);
@end
