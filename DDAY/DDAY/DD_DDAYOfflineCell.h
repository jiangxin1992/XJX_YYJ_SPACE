//
//  DD_DDAYOfflineCell.h
//  YCOSPACE
//
//  Created by yyj on 2016/12/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DD_DDAYModel;

@interface DD_DDAYOfflineCell : UITableViewCell

@property (nonatomic,copy) void (^ddayblock)(NSInteger index,NSString *type);

@property (nonatomic,strong)DD_DDAYModel *DDAYModel;

__int(index);

@end
