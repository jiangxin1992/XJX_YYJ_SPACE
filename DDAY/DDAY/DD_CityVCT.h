//
//  DD_CityVCT.h
//  DDAY
//
//  Created by yyj on 16/5/17.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DD_CityVCT : UIViewController

-(instancetype)initWithBlock:(void(^)(NSString *p_id,NSString *c_id))block;

@property (nonatomic,copy) void(^chooseblock)(NSString *p_id,NSString *c_id);
__string(p_id);
@end
