//
//  DD_CircleInfoImgView.h
//  DDAY
//
//  Created by yyj on 16/6/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DD_CircleModel;

@interface DD_CircleInfoImgView : UIView

/**
 * 初始化
 */
-(instancetype)initWithCircleModel:(DD_CircleModel *)CircleModel WithBlock:(void (^)(NSString *type,NSInteger index))block;

/**
 * 重新设置当前视图
 */
-(void)setState;

/** 搭配图片*/
@property (nonatomic,strong) DD_CircleModel *circleModel;

/** 回调block*/
@property(nonatomic,copy) void (^block)(NSString *type,NSInteger index);

@end
