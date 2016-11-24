//
//  DD_GoodsSimilarView.h
//  YCO SPACE
//
//  Created by yyj on 16/8/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

@class DD_OrderItemModel;

@interface DD_GoodsSimilarView : DD_BaseView

-(instancetype)initWithGoodsSimilarArr:(NSArray *)similarArr WithBlock:(void (^)(NSString *type,DD_OrderItemModel *itemModel))block;

__array(similarArr);

@property (nonatomic,copy) void (^block)(NSString *type,DD_OrderItemModel *itemModel);

@end
