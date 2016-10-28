//
//  DD_UserMessageHeadCell.h
//  YCO SPACE
//
//  Created by yyj on 16/9/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_UserMessageItemModel.h"

@interface DD_UserMessageHeadCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type,DD_UserModel *user))block;

@property (nonatomic,copy)DD_UserMessageItemModel *messageItem;
@property(nonatomic,copy) void (^block)(NSString *type,DD_UserModel *user);
/**
 * 是否是通知类型的消息
 */
__bool(isNotice);
@end
