//
//  DD_GoodsListTableViewCell.h
//  YCO SPACE
//
//  Created by yyj on 16/8/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DD_GoodsCategorySubModel;

@interface DD_GoodsListTableViewCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic,strong)DD_GoodsCategorySubModel *CategoryModel;

@end
