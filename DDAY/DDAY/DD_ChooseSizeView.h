//
//  DD_ChooseSizeView.h
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

@class DD_ColorsModel;
@class DD_SizeAlertModel;

@interface DD_ChooseSizeView : DD_BaseView

-(instancetype)initWithColorModel:(DD_ColorsModel *)colorModel WithPrice:(NSString *)price WithSizeAlertModel:(DD_SizeAlertModel *)sizeAlertModel WithBlock:(void (^)(NSString *type,NSString *sizeid,NSString *colorid,NSInteger count))block;

+(CGFloat )getHeightWithColorModel:(DD_ColorsModel *)colorModel WithPrice:(NSString *)price WithSizeAlertModel:(DD_SizeAlertModel *)sizeAlertModel;

@property (nonatomic,copy) void (^block)(NSString *type,NSString *sizeid,NSString *colorid,NSInteger count);

__array(sizeArr);

__string(colorid);

__string(price);

@property(nonatomic,strong)DD_SizeAlertModel *SizeAlertModel;

@property(nonatomic,strong)DD_ColorsModel *ColorsModel;

__btn(shop);

@end
