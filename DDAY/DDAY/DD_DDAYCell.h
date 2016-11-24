//
//  DD_DDAYCell.h
//  DDAY
//
//  Created by yyj on 16/6/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseCell.h"

@class DD_DDAYModel;

@interface DD_DDAYCell : DD_BaseCell

/**
 * beforeSignStart
 * beforeSignEnd
 * beforeSaleStart
 * beforeSaleEnd
 * afterSaleEnd
 */
@property (nonatomic,copy) void (^ddayblock)(NSInteger index,NSString *type);

@property (nonatomic,strong)DD_DDAYModel *DDAYModel;

__int(index);

@end
