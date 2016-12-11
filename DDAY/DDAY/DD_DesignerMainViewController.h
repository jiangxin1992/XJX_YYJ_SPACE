//
//  DD_DesignerMainViewController.h
//  DDAY
//
//  Created by yyj on 16/6/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@class DD_DesignerModel;

@interface DD_DesignerMainViewController : DD_BaseViewController

/**
 * 更新设计师列表状态
 * 更新+删除(设计师列表页+我关注的设计师列表)
 */
-(void)updateListDataWithDesignerId:(NSString *)desginerID WithFollowState:(BOOL )isFollow;

-(void)updateLeftListDataWithDesignerId:(NSString *)desginerID WithFollowState:(BOOL )isFollow;

-(void)updateRightListDataWithDesignerId:(NSString *)desginerID WithFollowState:(BOOL )isFollow;

@end
