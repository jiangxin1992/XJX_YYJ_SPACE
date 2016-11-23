//
//  DD_CircleListUserView.h
//  DDAY
//
//  Created by yyj on 16/6/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DD_CircleListModel;

@interface DD_CircleListUserView : UIView

/**
 * 初始化
 */
-(instancetype)initWithCircleListModel:(DD_CircleListModel *)model WithBlock:(void (^)(NSString *type))block;

/**
 * 更新
 */
-(void)setState;

/** 搭配model*/
@property (nonatomic,strong) DD_CircleListModel *detailModel;

/** 回调*/
__block_type(block, type);

@end
