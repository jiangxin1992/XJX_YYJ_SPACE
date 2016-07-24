//
//  DD_DesignerCell.h
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_DesignerModel.h"
#import <UIKit/UIKit.h>

@interface DD_DesignerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name_label;
@property (weak, nonatomic) IBOutlet UIImageView *headImge;
@property (weak, nonatomic) IBOutlet UIImageView *item_image;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (nonatomic,copy) void (^followblock)(NSInteger index,NSString *type);
@property (nonatomic,strong)DD_DesignerModel *Designer;
__int(index);
@end
