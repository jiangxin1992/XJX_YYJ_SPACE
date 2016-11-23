//
//  DD_DesignerIntroViewController.h
//  DDAY
//
//  Created by yyj on 16/6/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseViewController.h"

@interface DD_DesignerIntroViewController : DD_BaseViewController

-(instancetype)initWithDesignerID:(NSString *)DesignerID WithBlock:(void(^)(NSString *type))block;
__block_type(block, type);
__string(DesignerID);
@end
