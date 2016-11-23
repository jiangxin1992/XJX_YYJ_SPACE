//
//  DD_GoodsDetailViewController.h
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@class DD_ItemsModel;

@interface DD_GoodsDetailViewController : DD_BaseViewController

-(instancetype)initWithModel:(DD_ItemsModel *)_model WithBlock:(void (^)(DD_ItemsModel *model,NSString *type))block;

@property (nonatomic,copy) void (^block)(DD_ItemsModel *model,NSString *type);

@property (nonatomic,strong) DD_ItemsModel *model;

@end
