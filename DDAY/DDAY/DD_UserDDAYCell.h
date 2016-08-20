//
//  DD_UserDDAYCell.h
//  YCO SPACE
//
//  Created by yyj on 16/8/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_DDAYModel.h"

@interface DD_UserDDAYCell : UITableViewCell
@property (nonatomic,copy) void (^ddayblock)(NSInteger index,NSString *type);
@property (nonatomic,strong)DD_DDAYModel *DDAYModel;
__int(index);
@end
