//
//  DD_CircleListCell.h
//  DDAY
//
//  Created by yyj on 16/6/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_OrderItemModel.h"
#import "DD_CircleListModel.h"
#import <UIKit/UIKit.h>

@interface DD_CircleListCell : UITableViewCell
/**
 * 初始化
 */
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
+ (CGFloat)heightWithModel:(DD_CircleListModel *)model;
-(void)setAction;
/**
 * 搭配model
 */
@property(nonatomic,strong)DD_CircleListModel *listModel;
/**
 * 当前model在dataarr中的index
 */
@property(nonatomic,assign)NSInteger index;
/**
 * 回调block
 */
@property(nonatomic,copy) void (^cellBlock)(NSString *type,NSInteger index,DD_OrderItemModel *item);
__btn(lastView_state);
@end

