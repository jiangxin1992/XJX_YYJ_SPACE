//
//  DD_ClearingTabbar.h
//  YCO SPACE
//
//  Created by yyj on 16/8/4.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_ClearingModel.h"

@interface DD_ClearingTabbar : UIView

/**
 * 初始化方法
 */
-(instancetype)initWithClearingModel:(DD_ClearingModel *)clearingModel WithCountPrice:(CGFloat )countPrice WithCount:(CGFloat )count WithBlock:(void (^)(NSString *type))block;

-(void)SetState;

@property (nonatomic,strong)DD_ClearingModel *clearingModel;

__float(countPrice);

__float(count);

__block_type(block, type);

@end
