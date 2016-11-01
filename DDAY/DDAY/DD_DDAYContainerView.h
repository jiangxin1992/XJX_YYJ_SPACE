//
//  DD_DDAYContainerView.h
//  YCO SPACE
//
//  Created by yyj on 16/8/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_DDayDetailModel.h"

@interface DD_DDAYContainerView : UIView

-(instancetype)initWithGoodsDetailModel:(DD_DDayDetailModel *)model WithBlock:(void (^)(NSString *type))block;

@property (nonatomic,strong) DD_DDayDetailModel *detailModel;

__block_type(block, type);

@end
