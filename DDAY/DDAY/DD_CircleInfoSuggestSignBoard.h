//
//  DD_CircleInfoSuggestSignBoard.h
//  YCO SPACE
//
//  Created by yyj on 16/8/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_CircleInfoSuggestSignBoard : UIView

/**
 * 初始化
 */
-(instancetype)initWithHoldStr:(NSString *)holdStr WithBlock:(void (^)(NSString *type,NSString *content))block;

__string(holdStr);

/** 回调block*/
@property(nonatomic,copy) void (^block)(NSString *type,NSString *content);

/** 输入框 用于外部调用文本框内容*/
@property (nonatomic,strong) UITextView *commentField;

@end
