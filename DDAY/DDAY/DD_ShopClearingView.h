//
//  DD_ShopClearingView.h
//  DDAY
//
//  Created by yyj on 16/5/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_ShopTool.h"
#import "DD_ShopModel.h"
#import <UIKit/UIKit.h>

@interface DD_ShopClearingView : UIView
-(instancetype)initWithFrame:(CGRect)frame WithShopModel:(DD_ShopModel *)shopModel WithBlock:(void (^)(NSString *type))block;
-(void)SetState;
@property (nonatomic,copy) void (^block)(NSString *type);
@property (nonatomic,strong)DD_ShopModel *shopModel;

@end
