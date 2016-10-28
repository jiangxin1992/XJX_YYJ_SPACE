//
//  DD_UnReadMsgModel.h
//  YCO SPACE
//
//  Created by yyj on 2016/10/28.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_UnReadMsgModel : NSObject

+(DD_UnReadMsgModel *)getUnReadMsgModel:(NSDictionary *)dict;

/**
 * tabbar底部是否有未查看消息
 */
//__bool(isHaveUnReadBottomRedPoint);
@property(nonatomic,assign) BOOL isHaveUnReadBottomRedPoint;

/**
 * tabbar底部未查看消息数量
 */
//__number(unReadBottomRedPointNumber);
@property(nonatomic,strong) NSNumber *unReadBottomRedPointNumber;

/**
 * 个人主页右上角msg 是否有未读msg
 */
//__bool(isHaveUnReadMessage);
@property(nonatomic,assign) BOOL isHaveUnReadMessage;

/**
 * 个人主页右上角msg 未读msg数量（通知）
 */
//__number(unReadMessageNumber);
@property(nonatomic,strong) NSNumber *unReadMessageNumber;

@end
