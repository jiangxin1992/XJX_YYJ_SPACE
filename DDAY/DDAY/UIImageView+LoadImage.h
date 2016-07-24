//
//  UIImageView+LoadImage.h
//  DDAY
//
//  Created by yyj on 16/6/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LoadImage)
/**
 * 图片加载
 */
- (void)JX_loadImageUrlStr:(NSString *)urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius;

@end
