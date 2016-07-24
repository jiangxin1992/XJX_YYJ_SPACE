//
//  DD_GoodInformView.h
//  DDAY
//
//  Created by yyj on 16/5/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_GoodsDetailModel.h"
#import <UIKit/UIKit.h>

@interface DD_GoodInformView : UIView<UIWebViewDelegate>

-(instancetype)initWithFrame:(CGRect)frame WithGoodsDetailModel:(DD_GoodsDetailModel *)model WithBlock:(void (^)(NSString *type,CGFloat height))block;
-(void)cancelTime;
-(void)setState;
@property (nonatomic,strong) DD_GoodsDetailModel *detailModel;
@property (nonatomic,copy) void (^block)(NSString *type,CGFloat height);
@end
