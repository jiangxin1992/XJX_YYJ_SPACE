//
//  DD_GoodsListBtn.h
//  YCO SPACE
//
//  Created by yyj on 16/8/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_GoodsCategoryModel.h"

@interface DD_GoodsListBtn : UIButton
-(void)setFrame:(CGRect)frame WithIndex:(NSInteger )index WithCategoryModel:(DD_GoodsCategoryModel *)categoryMode WithBlock:(void (^)(NSString *type,NSInteger index))block;
@property (nonatomic,strong)DD_GoodsCategoryModel *categoryMode;
@property(nonatomic,copy) void (^block)(NSString *type,NSInteger index);
__int(index);
@end
