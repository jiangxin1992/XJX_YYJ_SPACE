//
//  DD_DesignerFollowViewController.h
//  DDAY
//
//  Created by yyj on 16/6/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DD_DesignerModel;

@interface DD_DesignerFollowViewController : UIViewController

-(instancetype)initWithBlock:(void(^)(NSString *type ,DD_DesignerModel *model))block;

@property(nonatomic,copy) void (^block)(NSString *type ,DD_DesignerModel *model);

@end
