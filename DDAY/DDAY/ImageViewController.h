//
//  ImageViewController.h
//  AdminMeetimeApp
//
//  Created by 谢江新 on 14-12-5.
//  Copyright (c) 2014年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
-(instancetype)initWithSize:(CGSize )size WithBlock:(void(^)(NSString *type,NSInteger index))block;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger maxPage;
@property (nonatomic,copy) NSArray *array;

/**
 * 高度
 */
@property (nonatomic,assign) CGSize size;
/**
 * 回调block
 */
@property (nonatomic,copy) void (^block)(NSString *type,NSInteger index);
@end