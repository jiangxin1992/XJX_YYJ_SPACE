//
//  DD_CircleApplyInfoView.h
//  DDAY
//
//  Created by yyj on 16/6/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_CircleChooseStyleView.h"
#import "DD_CircleInfoSuggestView.h"
#import "DD_CircleInfoImgView.h"
#import "DD_CirlcleApplyDesignerChooseView.h"
#import "DD_CircleTagsView.h"
#import "DD_CircleFitPersonView.h"
#import "DD_CircleInfoSuggestSimpleView.h"

#import "DD_CircleModel.h"

@interface DD_CircleApplyInfoView : UIView
/**
 * 初始化
 */

-(instancetype)initWithCircleModel:(DD_CircleModel *)CircleModel WithBlock:(void (^)(NSString *type,long index))block;
/**
 * 选择设计师
 */
//@property (nonatomic,strong)  DD_CirlcleApplyDesignerChooseView *designerView;
@property (nonatomic,strong)  DD_CircleInfoSuggestSimpleView *designerView;
/**
 * 喜欢该设计师的理由
 */
@property (nonatomic,strong) DD_CircleInfoSuggestSimpleView *likeReasonView;
/**
 * 搭配建议
 */
@property (nonatomic,strong) DD_CircleInfoSuggestView *commentview;
/**
 * 款式选择
 */
@property (nonatomic,strong) DD_CircleChooseStyleView *chooseStyleView;
/**
 * 搭配图
 */
@property (nonatomic,strong) DD_CircleInfoImgView *imgView;
/**
 * 官方标签和自定义标签视图
 */
@property (nonatomic,strong) DD_CircleTagsView *tagsView;
/**
 * 适合标签图
 */
@property (nonatomic,strong) DD_CircleFitPersonView *fitPersonView;


/**
 * 发布视图model/管理
 */
//@property (nonatomic,strong) DD_CircleApplyPublishModel *detailModel;
@property (nonatomic,strong)DD_CircleModel *CircleModel;
/**
 * 回调block
 */
@property(nonatomic,copy) void (^block)(NSString *type,long index);

@end
