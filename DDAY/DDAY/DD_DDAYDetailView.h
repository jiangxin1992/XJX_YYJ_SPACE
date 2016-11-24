//
//  DD_DDAYDetailView.h
//  DDAY
//
//  Created by yyj on 16/6/2.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

@class DD_DDayDetailModel;

@interface DD_DDAYDetailView : DD_BaseView

-(instancetype)initWithFrame:(CGRect)frame WithGoodsDetailModel:(DD_DDayDetailModel *)model WithBlock:(void (^)(NSString *type))block;

-(void)cancelTime;

-(void)setState;

@property (nonatomic,strong) DD_DDayDetailModel *detailModel;

@property (nonatomic,copy) void (^block)(NSString *type);

@end
