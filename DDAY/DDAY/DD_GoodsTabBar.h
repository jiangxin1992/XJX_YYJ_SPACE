//
//  DD_GoodsTabBar.h
//  YCO SPACE
//
//  Created by yyj on 16/7/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_GoodsItemModel.h"

@interface DD_GoodsTabBar : UIView

-(instancetype)initWithItem:(DD_GoodsItemModel *)item WithBlock:(void (^)(NSString *type))block;

@property (nonatomic,strong)DD_GoodsItemModel *item;
__block_type(block, type);

@end
