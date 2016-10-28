//
//  DD_UnReadMsgModel.m
//  YCO SPACE
//
//  Created by yyj on 2016/10/28.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UnReadMsgModel.h"

@implementation DD_UnReadMsgModel


+(DD_UnReadMsgModel *)getUnReadMsgModel:(NSDictionary *)dict
{
    return [DD_UnReadMsgModel mj_objectWithKeyValues:dict];
}

@end
