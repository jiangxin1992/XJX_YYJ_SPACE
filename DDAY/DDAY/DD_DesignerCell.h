//
//  DD_DesignerCell.h
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DD_DesignerModel;

@interface DD_DesignerCell : UITableViewCell


+ (CGFloat)heightWithModel:(DD_DesignerModel *)model;

@property (nonatomic,copy) void (^followblock)(NSInteger index,NSString *type);

@property (nonatomic,strong)DD_DesignerModel *Designer;

__int(index);

__scrollView(scrollview);

@end
