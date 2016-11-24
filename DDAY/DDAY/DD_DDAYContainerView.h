//
//  DD_DDAYContainerView.h
//  YCO SPACE
//
//  Created by yyj on 16/8/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

@class DD_DDayDetailModel;

@interface DD_DDAYContainerView : DD_BaseView

-(instancetype)initWithGoodsDetailModel:(DD_DDayDetailModel *)model WithBlock:(void (^)(NSString *type))block;

@property (nonatomic,strong) DD_DDayDetailModel *detailModel;

__block_type(block, type);

@end
