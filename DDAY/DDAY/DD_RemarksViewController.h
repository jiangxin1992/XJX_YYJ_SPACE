//
//  DD_RemarksViewController.h
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@interface DD_RemarksViewController : DD_BaseViewController
/**
 * 初始化
 * Remarks 备注
 */
-(instancetype)initWithRemarks:(NSString *)Remarks WithLimit:(long)limitNum WithTitle:(NSString *)title WithBlock:(void(^)(NSString *type,NSString *content))doneBlcok;

/** 完成回调*/
@property (nonatomic,copy) void(^doneBlcok)(NSString *type,NSString *content);

/** 备注*/
__string(Remarks);

/** 标题*/
__string(v_title);

/** 字数限制*/
__long(limitNum);

@end
