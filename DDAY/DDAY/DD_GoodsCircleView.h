//
//  DD_GoodCircleView.h
//  YCO SPACE
//
//  Created by yyj on 16/7/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_CircleListModel.h"
#import "DD_OrderItemModel.h"

@interface DD_GoodsCircleView : UIView

-(instancetype)initWithGoodsItem:(DD_CircleListModel *)circle WithBlock:(void (^)(NSString *type,DD_OrderItemModel *item))block;

-(void)setAction;

@property (nonatomic,strong) DD_CircleListModel *circle;

@property(nonatomic,copy) void (^block)(NSString *type,DD_OrderItemModel *item);

@end
