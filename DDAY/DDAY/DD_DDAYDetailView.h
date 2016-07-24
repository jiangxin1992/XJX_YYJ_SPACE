//
//  DD_DDAYDetailView.h
//  DDAY
//
//  Created by yyj on 16/6/2.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DD_DDayDetailModel.h"
@interface DD_DDAYDetailView : UIView

-(instancetype)initWithFrame:(CGRect)frame WithGoodsDetailModel:(DD_DDayDetailModel *)model WithBlock:(void (^)(NSString *type))block;

-(void)cancelTime;
-(void)setState;

@property (nonatomic,strong) DD_DDayDetailModel *detailModel;
@property (nonatomic,copy) void (^block)(NSString *type);

@end
