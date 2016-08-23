//
//  DD_ShareView.h
//  YCO SPACE
//
//  Created by yyj on 16/8/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_ShareView : UIView
-(instancetype)initWithTitle:(NSString *)title Content:(NSString *)content WithImg:(NSString *)img WithBlock:(void(^)(NSString *type))block;

@property (nonatomic,copy) void (^block)(NSString *type);
__string(content);
__string(img);
__string(title);

__float(height);
@end
