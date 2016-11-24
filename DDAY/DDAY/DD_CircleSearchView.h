//
//  DD_CircleSearchView.h
//  YCO SPACE
//
//  Created by yyj on 16/8/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

@interface DD_CircleSearchView : DD_BaseView

-(instancetype)initWithQueryStr:(NSString *)queryStr WithChooseItem:(NSArray *)chooseItem WithBlock:(void(^)(NSString *type,NSString *queryStr))block;

__string(queryStr);

__array(chooseItem);

@property(nonatomic,copy) void (^block)(NSString *type,NSString *queryStr);

@end
