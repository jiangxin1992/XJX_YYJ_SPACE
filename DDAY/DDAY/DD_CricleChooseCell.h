//
//  DD_CricleChooseCell.h
//  DDAY
//
//  Created by yyj on 16/6/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_CricleChooseItemModel.h"
#import <UIKit/UIKit.h>

@interface DD_CricleChooseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImgView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
/**
 * cell回调block
 */
@property (nonatomic,copy) void (^block)(NSString *type,NSInteger index);
/**
 * item model
 */
@property (nonatomic,strong)DD_CricleChooseItemModel *itemModel;
/**
 * 当前选择item 的 index
 */
__long(index);
@end
