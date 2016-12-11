//
//  DD_DesignerViewController.h
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DD_DesignerModel;

@interface DD_DesignerViewController : UIViewController

-(instancetype)initWithBlock:(void(^)(NSString *type , DD_DesignerModel *model))block;

@property(nonatomic,copy) void (^block)(NSString *type ,DD_DesignerModel *model);

/**
 * 更新设计师列表状态
 * 更新以获取数据的关注状态
 */
-(void)updateListDataWithDesignerId:(NSString *)desginerID WithFollowState:(BOOL )isFollow;

@end
