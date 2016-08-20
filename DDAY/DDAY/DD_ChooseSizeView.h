//
//  DD_ChooseSizeView.h
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_ColorsModel.h"

@interface DD_ChooseSizeView : UIView
-(instancetype)initWithColorModel:(DD_ColorsModel *)colorModel WithBlock:(void (^)(NSString *type,NSString *sizeid,NSString *colorid,NSInteger count))block;
@property (nonatomic,copy) void (^block)(NSString *type,NSString *sizeid,NSString *colorid,NSInteger count);
__array(sizeArr);
__string(colorid);
@property(nonatomic,strong)DD_ColorsModel *ColorsModel;
@end
