//
//  DD_ItemCell.h
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_ItemsModel.h"

@interface DD_ItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *item_img;
@property (weak, nonatomic) IBOutlet UILabel *price_label;
@property (weak, nonatomic) IBOutlet UILabel *name_label;
@property (nonatomic,strong)DD_ItemsModel *item;

@end
