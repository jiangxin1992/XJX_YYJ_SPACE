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

/**
 * 更新我关注的设计师数据
 * 因为无法保证数据的一致性  所以目前处理方式是页面出现的时候重新获取数据
 */
-(void)updateListDataWithDesignerId:(NSString *)desginerID WithFollowState:(BOOL )isFollow;

@end
