//
//  DD_ShopEditingCell.h
//  DDAY
//
//  Created by yyj on 16/5/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_ShopTool.h"
#import "DD_ShopModel.h"
#import "DD_ShopItemModel.h"
#import <UIKit/UIKit.h>

@interface DD_ShopEditingCell : UITableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellForRowAtIndexPath:(NSIndexPath *)indexPath WithBlock:(void(^)(NSString *type,NSIndexPath *indexPath,DD_ShopModel *shopModel))block;

@property (nonatomic,strong)DD_ShopModel *shopModel;
@property (nonatomic,strong)DD_ShopItemModel *ItemModel;
@property (nonatomic,copy) void (^clickblock)(NSString *type,NSIndexPath *indexPath,DD_ShopModel *shopModel);
@property (nonatomic,strong)NSIndexPath *indexPath;
@end
