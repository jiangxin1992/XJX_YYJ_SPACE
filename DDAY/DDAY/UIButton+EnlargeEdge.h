//
//  UIButton+EnlargeEdge.h
//  DDAY
//
//  Created by yyj on 16/7/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@interface UIButton (EnlargeEdge)

- (void)setEnlargeEdge:(CGFloat) size;
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end

