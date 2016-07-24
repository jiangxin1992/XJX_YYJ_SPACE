//
//  UIView+Frame.h
//  百思不得姐
//
//  Created by qianfeng on 16/3/9.
//  Copyright (c) 2016年 谢翼华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
//在分类中声明property,只会生成方法的声明，不会生成方法的实现和带有下划线的成员变量
@property(nonatomic,assign)CGFloat fr_width;

@property(nonatomic,assign)CGFloat fr_height;

@property(nonatomic,assign)CGFloat fr_x;

@property(nonatomic,assign)CGFloat fr_y;

@end
