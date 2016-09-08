//
//  YYAnimatedImageView+LoadImage.m
//  YCO SPACE
//
//  Created by yyj on 16/9/7.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "YYAnimatedImageView+LoadImage.h"

@implementation YYAnimatedImageView (LoadImage)
- (void)JX_ScaleToFill_loadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius
{
    NSString *urlStr=[regular getImgUrl:_urlStr WithSize:size];
    
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURL *path = [[NSBundle mainBundle]URLForResource:IS_RETINA?@"loading@2x":@"loading" withExtension:@"gif"];
    YYImage * image = [YYImage imageWithContentsOfFile:path.path];
    
    [self sd_setImageWithURL:url placeholderImage:image completed:nil];
}
- (void)JX_ScaleAspectFit_loadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius
{
    NSString *urlStr=[regular getImgUrl:_urlStr WithSize:size];
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    url = [NSURL URLWithString:urlStr];
    NSURL *path = [[NSBundle mainBundle]URLForResource:IS_RETINA?@"loading@2x":@"loading" withExtension:@"gif"];
    YYImage * image = [YYImage imageWithContentsOfFile:path.path];
    
    [self sd_setImageWithURL:url placeholderImage:image completed:nil];
}
- (void)JX_ScaleAspectFill_loadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius
{
    NSString *urlStr=[regular getImgUrl:_urlStr WithSize:size];
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    url = [NSURL URLWithString:urlStr];
    NSURL *path = [[NSBundle mainBundle]URLForResource:IS_RETINA?@"loading@2x":@"loading" withExtension:@"gif"];
    YYImage * image = [YYImage imageWithContentsOfFile:path.path];
    
    [self sd_setImageWithURL:url placeholderImage:image completed:nil];
}
+(YYAnimatedImageView *)getCustomImg
{
    YYAnimatedImageView *img=[[YYAnimatedImageView alloc] init];
    img.contentMode=1;
    return img;
}
+(YYAnimatedImageView *)getCornerRadiusImg
{
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithRoundingRectImageView];
    imageView.contentMode=1;
    return imageView;
}
@end
