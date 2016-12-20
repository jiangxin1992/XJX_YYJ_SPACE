//
//  DD_DDAYDetailOfflineViewController.h
//  YCOSPACE
//
//  Created by yyj on 2016/12/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@class DD_DDAYModel;

@interface DD_DDAYDetailOfflineViewController : DD_BaseViewController

-(instancetype)initWithModel:(DD_DDAYModel *)model;

@property (nonatomic,strong) DD_DDAYModel *model;

@end
