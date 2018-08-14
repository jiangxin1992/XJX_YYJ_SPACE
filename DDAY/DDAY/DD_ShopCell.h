//
//  DD_ShopCell.h
//  DDAY
//
//  Created by yyj on 16/5/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseCell.h"

@class DD_ShopItemModel;

@interface DD_ShopCell : DD_BaseCell

-(id)initWithIsInvalid:(BOOL )isInvalid style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type,NSIndexPath *indexPath))block;

@property (nonatomic,strong)DD_ShopItemModel *ItemModel;

@property (nonatomic,copy) void (^clickblock)(NSString *type,NSIndexPath *indexPath);

@property (nonatomic,strong)NSIndexPath *indexPath;

__bool(isInvalid);

@end
