//
//  DD_ClearingOrderViewController.h
//  YCO SPACE
//
//  Created by yyj on 16/8/9.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@interface DD_ClearingOrderViewController : DD_BaseViewController

-(instancetype)initWithDataArr:(NSMutableArray *)dataArr WithTradeOrderCode:(NSString *)tradeOrderCode;

__mu_array(dataArr);
__string(tradeOrderCode);

@end
