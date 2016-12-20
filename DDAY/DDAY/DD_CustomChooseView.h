//
//  DD_CustomChooseView.h
//  YCOSPACE
//
//  Created by yyj on 2016/12/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

@interface DD_CustomChooseView : DD_BaseView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)canceltitle otherButtonTitles:(NSString *)othertitle WithBlock:(void (^)(NSString *type))block;

__block_type(block, type);

__string(title);

__string(message);

__string(canceltitle);

__string(othertitle);

@end
