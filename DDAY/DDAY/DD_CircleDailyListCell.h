//
//  DD_CircleDailyListCell.h
//  YCO SPACE
//
//  Created by yyj on 16/9/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseCell.h"

@class DD_OrderItemModel;
@class DD_CircleListModel;

@interface DD_CircleDailyListCell : DD_BaseCell

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

__bool(isNameCenterFit);

/** 回调block*/
@property(nonatomic,copy) void (^cellBlock)(NSString *type,NSInteger index,DD_OrderItemModel *item);

__view(last_count_view);

@end
