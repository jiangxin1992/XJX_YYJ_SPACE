//
//  DD_DDAYCell.h
//  DDAY
//
//  Created by yyj on 16/6/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_DDAYTool.h"
#import "DD_DDAYModel.h"
#import <UIKit/UIKit.h>

@interface DD_DDAYCell : UITableViewCell

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
