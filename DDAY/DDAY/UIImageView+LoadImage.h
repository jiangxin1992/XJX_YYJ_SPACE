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
- (void)JX_ScaleToFill_loadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius;

- (void)JX_ScaleAspectFit_loadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius;

- (void)JX_ScaleAspectFill_loadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius;

@end
