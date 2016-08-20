//
//  DD_CirlcleApplyDesignerChooseView.h
//  DDAY
//
//  Created by yyj on 16/6/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_CircleFavouriteDesignerModel.h"

@interface DD_CirlcleApplyDesignerChooseView : UIView
/**
 * 初始化
 */
-(instancetype)initWithFavouriteDesignerModel:(DD_CircleFavouriteDesignerModel *)designerModel WithBlock:(void (^)(NSString *type))block;
/**
 * 重新设置当前视图
 */
-(void)setState;
/**
 * designer model
 */
@property (nonatomic,strong)DD_CircleFavouriteDesignerModel *designerModel;
/**
 * 回调block
 */
@property(nonatomic,copy) void (^block)(NSString *type);
@end
