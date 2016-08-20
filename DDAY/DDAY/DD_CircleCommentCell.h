//
//  DD_CircleCommentCell.h
//  DDAY
//
//  Created by yyj on 16/6/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_CircleCommentModel.h"

@interface DD_CircleCommentCell : UITableViewCell
/**
 * 初始化
 */
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
/**
 * 搭配model
 */
@property(nonatomic,strong)DD_CircleCommentModel *CommentModel;
/**
 * 当前model在dataarr中的index
 */
@property(nonatomic,assign)NSInteger index;
/**
 * 回调block
 */
@property(nonatomic,copy) void (^cellBlock)(NSString *type,NSInteger index);
@end
