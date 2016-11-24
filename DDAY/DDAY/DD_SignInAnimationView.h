//
//  DD_SignInAnimationView.h
//  YCO SPACE
//
//  Created by yyj on 2016/11/16.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

@interface DD_SignInAnimationView : DD_BaseView

/**
 * 创建单例
 */
+(id)sharedManagerWithTitle:(NSString *)title WithBlock:(void (^)(NSString *type))block;

/** 开始动画*/
-(void)startAnimation;

/** block回调*/
__block_type(block, type);

/** 动画是否结束*/
__bool(animationStarting);

/** 标题*/
__string(title);

/** 内容*/
__label(labelView);

@end
