//
//  DD_CircleDailyListCell.h
//  YCO SPACE
//
//  Created by yyj on 16/9/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_OrderItemModel.h"
#import "DD_CircleListModel.h"

@interface DD_CircleDailyListCell : UITableViewCell

/**
 * 初始化
 */
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier IsUserHomePage:(BOOL )isUserHomePage;

+ (CGFloat)heightWithModel:(DD_CircleListModel *)model IsUserHomePage:(BOOL )_isUserHomePage;

-(void)setAction;

/** 搭配model*/
@property(nonatomic,strong)DD_CircleListModel *listModel;

/** 当前model在dataarr中的index*/
@property(nonatomic,assign)NSInteger index;

__bool(isUserHomePage);

/** 回调block*/
@property(nonatomic,copy) void (^cellBlock)(NSString *type,NSInteger index,DD_OrderItemModel *item);

__view(last_count_view);

@end
