//
//  DD_SignInAnimationView.h
//  YCO SPACE
//
//  Created by yyj on 2016/11/16.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_SignInAnimationView : UIView

/**
 * 创建单例
 */
+(id)sharedManagerWithBlock:(void (^)(NSString *type))block;

-(void)startAnimation;

__block_type(block, type);

__bool(animationStarting);

@end
