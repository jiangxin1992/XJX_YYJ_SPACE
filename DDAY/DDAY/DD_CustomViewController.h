//
//  DD_CustomViewController.h
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DD_UserViewController;
@class DD_CircleViewController;
@class DD_DesignerMainViewController;
@class DD_GoodsViewController;
@class DD_DDAYViewController;

@class DD_UnReadMsgModel;
@class DD_VersionModel;

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
 * 显示版本更新试图
 */
-(void)showVersionViewWithVersonModel:(DD_VersionModel *)versionModel;

/**
 * 红包toast
 */
//-(void)showBenefitWithModel:(DD_BenefitInfoModel *)model;

/**
 * 更新设计师列表状态
 * 更新+删除(设计师列表页+我关注的设计师列表)
 */
-(void)updateDesignerListDataWithID:(NSString *)desginerID WithFollowState:(BOOL )isFollow;

-(void)updateLeftDesignerListDataWithID:(NSString *)desginerID WithFollowState:(BOOL )isFollow;

-(void)updateRightDesignerListDataWithID:(NSString *)desginerID WithFollowState:(BOOL )isFollow;

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

__bool(isVisible);

@end
