//
//  DD_CustomViewController.h
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

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
@end
