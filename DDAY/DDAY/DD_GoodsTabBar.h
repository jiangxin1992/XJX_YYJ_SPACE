//
//  DD_GoodsTabBar.h
//  YCO SPACE
//
//  Created by yyj on 16/7/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

@class DD_GoodsItemModel;

@interface DD_GoodsTabBar : DD_BaseView

-(instancetype)initWithItem:(DD_GoodsItemModel *)item WithBlock:(void (^)(NSString *type))block;

@property (nonatomic,strong)DD_GoodsItemModel *item;

__block_type(block, type);

@end
