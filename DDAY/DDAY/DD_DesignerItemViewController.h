//
//  DD_DesignerItemViewController.h
//  DDAY
//
//  Created by yyj on 16/6/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@class DD_ItemsModel;

@interface DD_DesignerItemViewController : DD_BaseViewController
-(instancetype)initWithDesignerID:(NSString *)DesignerID WithBlock:(void(^)(NSString *type,DD_ItemsModel *model))block;
@property(nonatomic,copy) void (^block)(NSString *type,DD_ItemsModel *model);
__string(DesignerID);
@end
