//
//  ImageViewController.h
//  AdminMeetimeApp
//
//  Created by 谢江新 on 14-12-5.
//  Copyright (c) 2014年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_BaseViewController.h"

@interface ImageViewController : DD_BaseViewController
-(instancetype)initWithSize:(CGSize )size WithType:(NSString *)type WithIsFit:(BOOL )is_fit WithBlock:(void(^)(NSString *type,NSInteger index))block;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger maxPage;
@property (nonatomic,copy) NSArray *array;
__bool(is_fit);
__string(type);
/**
 * 高度
 */
@property (nonatomic,assign) CGSize size;
/**
 * 回调block
 */
@property (nonatomic,copy) void (^block)(NSString *type,NSInteger index);
@end
