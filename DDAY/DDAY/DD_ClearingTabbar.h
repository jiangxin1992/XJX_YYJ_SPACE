//
//  DD_ClearingTabbar.h
//  YCO SPACE
//
//  Created by yyj on 16/8/4.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_ClearingTabbar : UIView

/**
 * 初始化方法
 */
-(instancetype)initWithNumStr:(NSString *)numStr WithCountStr:(NSString *)countStr WithBlock:(void (^)(NSString *type))block;

__string(numStr);

__string(countStr);

__block_type(block, type);

@end
