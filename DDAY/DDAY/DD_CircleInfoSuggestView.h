//
//  DD_CircleInfoSuggestView.h
//  DDAY
//
//  Created by yyj on 16/6/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_CircleInfoSuggestView : UIView<UIWebViewDelegate>
/**
 * 初始化
 */
-(instancetype)initWithPlaceHoldStr:(NSString *)holdStr WithBlockType:(NSString *)blockType WithLimitNum:(long)limitNum Block:(void (^)(NSString *type,NSInteger num))block;
/**
 * 更新内容，重新sizetofit webview
 */
-(void)setRemarksWithWebView:(NSString *)content;
/**
 * block type
 */
__string(blockType);
/**
 * holdStr
 */
__string(holdStr);
/**
 * 字数限制
 */
__long(limitNum);
/**
 * 回调block
 */
@property(nonatomic,copy) void (^block)(NSString *type,NSInteger num);

@end