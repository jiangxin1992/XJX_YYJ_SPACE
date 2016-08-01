//
//  DD_GoodsListTableView.h
//  YCO SPACE
//
//  Created by yyj on 16/8/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_GoodsListTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
__array(categoryArr);

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style WithBlock:(void (^)(NSString *type,NSString *categoryName,NSString *categoryID))block;

@property(nonatomic,copy) void (^block)(NSString *type,NSString *categoryName,NSString *categoryID);
@end
