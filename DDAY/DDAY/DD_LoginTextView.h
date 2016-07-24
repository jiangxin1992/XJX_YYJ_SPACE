//
//  DD_LoginTextView.h
//  DDAY
//
//  Created by yyj on 16/7/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_LoginTextView : UIView
-(instancetype)initWithFrame:(CGRect )_frame WithImgStr:(NSString *)_imgStr WithSize:(CGSize )_size isLeft:(BOOL)_isLeft WithBlock:(void (^)(NSString *type))block;
/**
 * 倒计时
 */
-(instancetype)initWithTimingFrame:(CGRect )_frame WithSize:(CGSize )_size isLeft:(BOOL)_isLeft WithBlock:(void (^)(NSString *type))block;

__block_type(block, type);
@end
