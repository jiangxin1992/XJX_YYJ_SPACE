//
//  Xiexian.h
//  asadsadsads
//
//  Created by yyj on 16/7/28.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

/**
 * 初始化方法
 */
-(instancetype)initWithFrame:(CGRect)frame WithStartP:(CGPoint )start_point WithEndP:(CGPoint )end_point WithLineWidth:(CGFloat )width WithColorType:(NSInteger )type;

-(instancetype)initWithStartP:(CGPoint )start_point WithEndP:(CGPoint )end_point WithLineWidth:(CGFloat )width WithColorType:(NSInteger )type;

-(void)Update;

/** 起始位置*/
@property (nonatomic,assign) CGPoint start_point;

/** 结束位置*/
@property (nonatomic,assign) CGPoint end_point;

/** 宽度*/
@property (nonatomic,assign) CGFloat width;

/** 颜色类型*/
@property (nonatomic,assign) NSInteger type;

@end
