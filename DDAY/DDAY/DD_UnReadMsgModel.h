//
//  DD_UnReadMsgModel.h
//  YCO SPACE
//
//  Created by yyj on 2016/10/28.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_baseModel.h"

#define __number(__k__) @property(nonatomic,strong) NSNumber *__k__
#define __bool(__k__) @property(nonatomic,assign) BOOL __k__

@interface DD_UnReadMsgModel : DD_baseModel

+(DD_UnReadMsgModel *)getUnReadMsgModel:(NSDictionary *)dict;

/** tabbar底部是否有未查看消息*/
__bool(isHaveUnReadBottomRedPoint);

/** tabbar底部未查看消息数量*/
__number(unReadBottomRedPointNumber);

/** 个人主页右上角msg 是否有未读msg*/
__bool(isHaveUnReadMessage);

/** 个人主页右上角msg 未读msg数量（通知）*/
__number(unReadMessageNumber);

@end
