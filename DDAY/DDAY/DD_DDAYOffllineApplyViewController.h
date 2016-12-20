//
//  DD_DDAYOffllineApplyViewController.h
//  YCOSPACE
//
//  Created by yyj on 2016/12/19.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@class DD_DDayDetailModel;

@interface DD_DDAYOffllineApplyViewController : DD_BaseViewController

-(instancetype)initWithGoodsDetailModel:(DD_DDayDetailModel *)model WithUserInfo:(DD_UserModel *)userInfo WithBlock:(void (^)(NSString *type))block;

@property (nonatomic,strong) DD_DDayDetailModel *detailModel;

@property (nonatomic,strong) DD_UserModel *userInfo;

__block_type(block, type);

@end
