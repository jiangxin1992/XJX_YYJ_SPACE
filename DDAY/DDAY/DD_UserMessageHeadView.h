//
//  DD_UserMessageHeadView.h
//  YCO SPACE
//
//  Created by yyj on 16/9/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DD_UserMessageModel;

@interface DD_UserMessageHeadView : UIView

-(instancetype)initWithFrame:(CGRect)frame WithUserMessageModel:(DD_UserMessageModel *)messageModel WithSection:(NSInteger )section  WithBlock:(void(^)(NSString *type,NSInteger section))block;

@property (nonatomic,strong)DD_UserMessageModel *messageModel;

__int(section);

@property (nonatomic,copy)void (^block)(NSString *type,NSInteger section);

@end

