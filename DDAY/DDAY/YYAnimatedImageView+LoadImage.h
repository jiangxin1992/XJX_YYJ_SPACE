//
//  YYAnimatedImageView+LoadImage.h
//  YCO SPACE
//
//  Created by yyj on 16/9/7.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <YYImage/YYImage.h>

@interface YYAnimatedImageView (LoadImage)

/**
 * 图片加载
 */
- (void)JX_ScaleToFill_loadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius;

- (void)JX_ScaleAspectFit_loadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius;

- (void)JX_ScaleAspectFill_loadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius;

+(YYAnimatedImageView *)getCustomImg;

+(YYAnimatedImageView *)getCornerRadiusImg;

@end
