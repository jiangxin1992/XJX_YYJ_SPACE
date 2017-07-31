//
//  DD_ProvinceViewController.h
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import "DD_BaseViewController.h"

@interface DD_ProvinceViewController : DD_BaseViewController

-(instancetype)initWithBlock:(void(^)(NSString *p_id,NSString *c_id))block;

@property (nonatomic,copy) void(^chooseblock)(NSString *p_id,NSString *c_id);

@end
