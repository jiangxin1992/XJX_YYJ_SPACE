//
//  DD_ShopAlertNumView.h
//  YCO SPACE
//
//  Created by yyj on 16/8/2.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DD_ShopItemModel;

@interface DD_ShopAlertNumView : UIView

-(instancetype)initWithSizeArr:(NSArray *)sizeArr WithItem:(DD_ShopItemModel *)ItemModel WithBlock:(void (^)(NSString *type,NSInteger count))block;

+(CGFloat )getHeightWithSizeArr:(NSArray *)sizeArr WithItem:(DD_ShopItemModel *)ItemModel;

@property (nonatomic,copy) void (^block)(NSString *type,NSInteger count);

__array(sizeArr);

@property (nonatomic,strong)DD_ShopItemModel *ItemModel;

__btn(confirmBtn);

@end
