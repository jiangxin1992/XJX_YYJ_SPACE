//
//  DD_DDAYOfflineContainerView.h
//  YCOSPACE
//
//  Created by yyj on 2016/12/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DD_DDayDetailModel;

@interface DD_DDAYOfflineContainerView : UIView

-(instancetype)initWithGoodsDetailModel:(DD_DDayDetailModel *)model WithBlock:(void (^)(NSString *type))block;

@property (nonatomic,strong) DD_DDayDetailModel *detailModel;

__block_type(block, type);

@end
