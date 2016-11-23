//
//  DD_UserMessageDDAYCell.h
//  YCO SPACE
//
//  Created by yyj on 2016/11/4.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DD_UserMessageItemModel;

@interface DD_UserMessageDDAYCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type))block;

@property (nonatomic,copy)DD_UserMessageItemModel *messageItem;

__block_type(block, type);

/** 是否是通知类型的消息*/
__bool(isNotice);

@end
