//
//  DD_GoodsTabBar.h
//  YCO SPACE
//
//  Created by yyj on 16/7/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

@class DD_ColorsModel;

@interface DD_GoodsTabBar : DD_BaseView

-(instancetype)initWithColorModel:(DD_ColorsModel *)colorModel WithBlock:(void (^)(NSString *type))block;

-(void)setState;

@property (nonatomic,strong)DD_ColorsModel *colorModel;

__block_type(block, type);

@end
