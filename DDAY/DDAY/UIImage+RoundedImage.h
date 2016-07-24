//
//  UIImage+RoundedImage.h
//  DDAY
//
//  Created by yyj on 16/6/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundedImage)
/**
 * 创建圆角
 */
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;
@end
