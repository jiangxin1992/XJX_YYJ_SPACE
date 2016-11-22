//
//  DD_CustomViewController.h
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_UserViewController.h"
#import "DD_CircleViewController.h"
#import "DD_DesignerMainViewController.h"
#import "DD_GoodsViewController.h"
#import "DD_DDAYViewController.h"

#import "DD_UnReadMsgModel.h"

@interface DD_CustomViewController : UITabBarController

/**
 * 创建单例
 */
+(id)sharedManager;

/**
 * tabbarHide
 */
-(void)tabbarHide;

/**
 * tabbarAppear
 */
-(void)tabbarAppear;

/**
 * 清理缓存  处理内存警告
 */
-(void)cleanCache;

/**
 * toast提示弹框
 */
-(void)startSignInAnimationWithTitle:(NSString *)title WithType:(NSString *)type;

/**
 * 红包toast
 */
-(void)showBenefitWithModel:(DD_BenefitInfoModel *)model;

/**
 * 更新unReadMsgModel
 * 并更新当前tabbar 用户item的状态
 */
-(void)UpdateUnReadMsgModel:(DD_UnReadMsgModel *)unReadMsgModel;

@property (nonatomic,strong) DD_UserViewController *userCtn;

@property (nonatomic,strong) DD_CircleViewController *circleCtn;

@property (nonatomic,strong) DD_DesignerMainViewController *designerCtn;

@property (nonatomic,strong) DD_GoodsViewController *goodsCtn;

@property (nonatomic,strong) DD_DDAYViewController *ddayCtn;

@end
