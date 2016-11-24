//
//  DD_ShopHeaderView.h
//  DDAY
//
//  Created by yyj on 16/5/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

@class DD_ShopModel;

@interface DD_ShopHeaderView : DD_BaseView

-(instancetype)initWithFrame:(CGRect)frame WithSection:(NSInteger )section WithShopModel:(DD_ShopModel *)shopModel WithBlock:(void (^)(NSString *type,NSInteger section))block;

__int(section);

@property (nonatomic,copy) void (^block)(NSString *type,NSInteger section);

@property (nonatomic,strong)DD_ShopModel *shopModel;

@end
