//
//  DD_ShopAlertSizeView.h
//  YCO SPACE
//
//  Created by yyj on 16/8/2.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_ShopItemModel.h"
#import <UIKit/UIKit.h>

@interface DD_ShopAlertSizeView : UIView
-(instancetype)initWithSizeArr:(NSArray *)sizeArr WithItem:(DD_ShopItemModel *)ItemModel WithBlock:(void (^)(NSString *type,NSString *sizeId,NSString *sizeName,NSInteger count))block;
@property (nonatomic,copy) void (^block)(NSString *type,NSString *sizeId,NSString *sizeName,NSInteger count);
__array(sizeArr);
@property (nonatomic,strong)DD_ShopItemModel *ItemModel;
@end
