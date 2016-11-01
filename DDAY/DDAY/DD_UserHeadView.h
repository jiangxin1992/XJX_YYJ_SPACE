//
//  DD_UserHeadView.h
//  DDAY
//
//  Created by yyj on 16/5/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_UserHeadView : UIButton

+(instancetype)buttonWithType:(UIButtonType)buttonType WithModel:(DD_UserModel *)usermodel WithBlock:(void(^)(NSString *type))block;

-(void)updateState;

@property (nonatomic,strong) DD_UserModel *usermodel;

__block_type(touchblock, type);

@end
