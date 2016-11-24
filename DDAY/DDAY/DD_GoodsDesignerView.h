//
//  DD_GoodsDesignerView.h
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

@class DD_GoodsDetailModel;

@interface DD_GoodsDesignerView : DD_BaseView

-(instancetype)initWithGoodsDetailModel:(DD_GoodsDetailModel *)model WithBlock:(void (^)(NSString *type,NSInteger index))block;

@property (nonatomic,strong) DD_GoodsDetailModel *detailModel;

@property (nonatomic,copy) void (^block)(NSString *type,NSInteger index);

-(void)UpdateFollowBtnState;

@end
