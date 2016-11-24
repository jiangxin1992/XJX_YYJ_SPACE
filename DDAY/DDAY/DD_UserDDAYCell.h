//
//  DD_UserDDAYCell.h
//  YCO SPACE
//
//  Created by yyj on 16/8/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseCell.h"

@class DD_DDAYModel;

@interface DD_UserDDAYCell : DD_BaseCell

@property (nonatomic,copy) void (^ddayblock)(NSInteger index,NSString *type);

@property (nonatomic,strong)DD_DDAYModel *DDAYModel;

__int(index);

@end
