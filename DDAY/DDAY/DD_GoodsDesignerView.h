//
//  DD_GoodsDesignerView.h
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_GoodsDetailModel.h"

@interface DD_GoodsDesignerView : UIView
-(instancetype)initWithGoodsDetailModel:(DD_GoodsDetailModel *)model WithBlock:(void (^)(NSString *type,NSInteger index))block;
@property (nonatomic,strong) DD_GoodsDetailModel *detailModel;
@property (nonatomic,copy) void (^block)(NSString *type,NSInteger index);
-(void)UpdateFollowBtnState;
@end
