//
//  DD_OrderLogisticsCell.h
//  YCO SPACE
//
//  Created by yyj on 16/8/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DD_OrderLogisticsModel;

@interface DD_OrderLogisticsCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type,NSString *phoneNum))block;

-(void)setLogisticsModel:(DD_OrderLogisticsModel *)logisticsModel IsFirst:(BOOL )isFirst IsLast:(BOOL )isLast;

+ (CGFloat)heightWithModel:(DD_OrderLogisticsModel *)model;

@property(nonatomic,copy) void (^block)(NSString *type,NSString *phoneNum);

__view(downLine);

@property (nonatomic,strong)DD_OrderLogisticsModel *logisticsModel;

@end
