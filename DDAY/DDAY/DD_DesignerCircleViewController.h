//
//  DD_DesignerCircleViewController.h
//  DDAY
//
//  Created by yyj on 16/6/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

#import "DD_CircleListModel.h"

@interface DD_DesignerCircleViewController : DD_BaseViewController
-(instancetype)initWithDesignerID:(NSString *)DesignerID WithBlock:(void(^)(NSString *type,DD_CircleListModel *listModel))block;
-(void)reloadData;
@property(nonatomic,copy) void (^block)(NSString *type,DD_CircleListModel *listModel);
__string(DesignerID);
@end
