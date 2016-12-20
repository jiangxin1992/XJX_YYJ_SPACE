//
//  DD_DDAYOfflineDetailBar.h
//  YCOSPACE
//
//  Created by yyj on 2016/12/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

#import "DD_DDayDetailModel.h"

@interface DD_DDAYOfflineDetailBar : DD_BaseView

-(instancetype)initWithFrame:(CGRect)frame WithGoodsDetailModel:(DD_DDayDetailModel *)model WithBlock:(void (^)(NSString *type))block;

-(void)cancelTime;
-(void)setState;

@property (nonatomic,strong) DD_DDayDetailModel *detailModel;
@property (nonatomic,copy) void (^block)(NSString *type);

@end
