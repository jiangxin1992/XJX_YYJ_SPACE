//
//  DD_CircleDetailImgView.h
//  DDAY
//
//  Created by yyj on 16/6/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_CircleListModel.h"

@interface DD_CircleDetailImgView : UIView
/**
 * 初始化
 */
-(instancetype)initWithCircleListModel:(DD_CircleListModel *)model WithBlock:(void (^)(NSString *type,NSInteger index))block;
-(instancetype)initWithCirclePicArr:(NSArray *)picArr WithBlock:(void (^)(NSString *type,NSInteger index))block;
/**
 * 更新
 */
-(void)setState;
/**
 * 搭配model
 */
@property (nonatomic,strong) DD_CircleListModel *detailModel;
__array(picArr);
__string(type);
/**
 * 回调block
 */
@property(nonatomic,copy) void (^block)(NSString *type,NSInteger index);
@end
