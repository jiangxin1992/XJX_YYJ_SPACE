//
//  DD_CircleDailyInfoView.h
//  YCO SPACE
//
//  Created by yyj on 16/9/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_CircleInfoSuggestView.h"
#import "DD_CircleDailyInfoImgView.h"

#import "DD_CircleModel.h"

@interface DD_CircleDailyInfoView : UIView

/**
 * 初始化
 */
-(instancetype)initWithCircleModel:(DD_CircleModel *)model WithBlock:(void (^)(NSString *type,long index))block;

/** 搭配建议*/
@property (nonatomic,strong) DD_CircleInfoSuggestView *commentview;

/** 搭配图*/
@property (nonatomic,strong) DD_CircleDailyInfoImgView *imgView;

/** 发布视图model/管理*/
@property (nonatomic,strong)DD_CircleModel *CircleModel;

/** 回调block*/
@property(nonatomic,copy) void (^block)(NSString *type,long index);

@end
