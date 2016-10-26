//
//  DD_StartViewController.h
//  YCO SPACE
//
//  Created by yyj on 16/9/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@interface DD_StartViewController : DD_BaseViewController
/**
 * 创建单例
 */
+(id)sharedManager;
-(void)pushMainView;
@end
