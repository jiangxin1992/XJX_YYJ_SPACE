//
//  DD_GoodCircleView.h
//  YCO SPACE
//
//  Created by yyj on 16/7/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

@class DD_CircleListModel;
@class DD_OrderItemModel;

@interface DD_GoodsCircleView : DD_BaseView

-(instancetype)initWithGoodsItem:(DD_CircleListModel *)circle WithBlock:(void (^)(NSString *type,DD_OrderItemModel *item))block;

-(void)setAction;

@property (nonatomic,strong) DD_CircleListModel *circle;

@property(nonatomic,copy) void (^block)(NSString *type,DD_OrderItemModel *item);

@end
