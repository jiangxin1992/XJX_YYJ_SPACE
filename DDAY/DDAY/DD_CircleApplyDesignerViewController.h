//
//  DD_CircleApplyDesignerViewController.h
//  DDAY
//
//  Created by yyj on 16/6/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_CircleApplyDesignerModel.h"
#import "DD_BaseViewController.h"

@interface DD_CircleApplyDesignerViewController : DD_BaseViewController
-(instancetype)initWithBlock:(void (^)(NSString *type,DD_CircleApplyDesignerModel *designer))block;
/**
 * 回调block
 */
@property(nonatomic,copy) void (^block)(NSString *type,DD_CircleApplyDesignerModel *designer);

@end
