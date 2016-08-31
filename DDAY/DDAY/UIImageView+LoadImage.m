//
//  UIImageView+LoadImage.m
//  DDAY
//
//  Created by yyj on 16/6/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "UIImageView+LoadImage.h"

#import "UIImage+RoundedImage.h"

@implementation UIImageView (LoadImage)

- (void)JX_ScaleToFill_loadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius
{
    NSString *urlStr=[regular getImgUrl:_urlStr WithSize:size];
    //something
    //这里有针对不同需求的处理，我就没贴出来了
    //...
    
    NSURL *url;
    
    //这里传CGFLOAT_MIN，就是默认以图片宽度的一半为圆角
    //    if (radius == CGFLOAT_MIN) {
    //        radius = self.frame.size.width/2.0;
    //    }
    
    url = [NSURL URLWithString:urlStr];
    UIImage *placeImg=nil;
    if(placeHolderStr)
    {
        placeImg=[UIImage imageNamed:placeHolderStr];
    }else
    {
        NSString *gifName=nil;
        if(IS_RETINA){
            gifName=@"loading@2x";
        }else{
            gifName=@"loading";
        }
        NSString* filePath = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
        NSData *_defaultImage = [NSData dataWithContentsOfFile:filePath];
        placeImg=[UIImage imageWithSmallGIFData:_defaultImage scale:10];
    }
    //头像需要手动缓存处理成圆角的图片
    NSString *cacheurlStr = nil;
    if(radius)
    {
        cacheurlStr=[urlStr stringByAppendingString:[[NSString alloc] initWithFormat:@"-radiusCache-%.1lf",radius]];
    }else
    {
        cacheurlStr=[urlStr stringByAppendingString:@"-radiusCache"];
    }
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheurlStr];
    if (cacheImage) {
        self.contentMode=UIViewContentModeScaleToFill;
        self.image = cacheImage;
    }else {
        self.contentMode = UIViewContentModeCenter;
        [self sd_setImageWithURL:url placeholderImage:placeImg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                self.contentMode=UIViewContentModeScaleToFill;
                if(radius)
                {
                    UIImage *radiusImage = [UIImage createRoundedRectImage:image size:self.frame.size radius:radius];
                    self.image = radiusImage;
                    [[SDImageCache sharedImageCache] storeImage:radiusImage forKey:cacheurlStr];
                }else
                {
                    self.image = image;
                    [[SDImageCache sharedImageCache] storeImage:image forKey:cacheurlStr];
                }
                //清除原有非圆角图片缓存
                [[SDImageCache sharedImageCache] removeImageForKey:urlStr];
            }else
            {
                self.contentMode=UIViewContentModeCenter;
            }
        }];
    }

}

- (void)JX_ScaleAspectFit_loadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius
{
    NSString *urlStr=[regular getImgUrl:_urlStr WithSize:size];
    //something
    //这里有针对不同需求的处理，我就没贴出来了
    //...
    
    NSURL *url;
    
    //这里传CGFLOAT_MIN，就是默认以图片宽度的一半为圆角
    //    if (radius == CGFLOAT_MIN) {
    //        radius = self.frame.size.width/2.0;
    //    }
    
    url = [NSURL URLWithString:urlStr];
    UIImage *placeImg=nil;
    if(placeHolderStr)
    {
        placeImg=[UIImage imageNamed:placeHolderStr];
    }else
    {
        NSString *gifName=nil;
        if(IS_RETINA){
            gifName=@"loading@2x";
        }else{
            gifName=@"loading";
        }
        NSString* filePath = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
        NSData *_defaultImage = [NSData dataWithContentsOfFile:filePath];
        placeImg=[UIImage imageWithSmallGIFData:_defaultImage scale:10];
    }
    //头像需要手动缓存处理成圆角的图片
    NSString *cacheurlStr = nil;
    if(radius)
    {
        cacheurlStr=[urlStr stringByAppendingString:[[NSString alloc] initWithFormat:@"-radiusCache-%.1lf",radius]];
    }else
    {
        cacheurlStr=[urlStr stringByAppendingString:@"-radiusCache"];
    }
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheurlStr];
    if (cacheImage) {
        self.contentMode=UIViewContentModeScaleAspectFit;
        self.image = cacheImage;
    }else {
        self.contentMode = UIViewContentModeCenter;
        [self sd_setImageWithURL:url placeholderImage:placeImg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                self.contentMode=UIViewContentModeScaleAspectFit;
                if(radius)
                {
                    UIImage *radiusImage = [UIImage createRoundedRectImage:image size:self.frame.size radius:radius];
                    self.image = radiusImage;
                    [[SDImageCache sharedImageCache] storeImage:radiusImage forKey:cacheurlStr];
                }else
                {
                    self.image = image;
                    [[SDImageCache sharedImageCache] storeImage:image forKey:cacheurlStr];
                }
                //清除原有非圆角图片缓存
                [[SDImageCache sharedImageCache] removeImageForKey:urlStr];
            }else
            {
                self.contentMode=UIViewContentModeCenter;
            }
        }];
    }

}

- (void)JX_ScaleAspectFill_loadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius
{
    NSString *urlStr=[regular getImgUrl:_urlStr WithSize:size];
    //something
    //这里有针对不同需求的处理，我就没贴出来了
    //...
    
    NSURL *url;
    
    url = [NSURL URLWithString:urlStr];
    UIImage *placeImg=nil;
    if(placeHolderStr)
    {
        placeImg=[UIImage imageNamed:placeHolderStr];
    }else
    {
        NSString *gifName=nil;
        if(IS_RETINA){
            gifName=@"loading@2x";
        }else{
            gifName=@"loading";
        }
        NSString* filePath = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
        NSData *_defaultImage = [NSData dataWithContentsOfFile:filePath];
        placeImg=[UIImage imageWithSmallGIFData:_defaultImage scale:10];
    }

    //头像需要手动缓存处理成圆角的图片
    NSString *cacheurlStr = nil;
    if(radius)
    {
        cacheurlStr=[urlStr stringByAppendingString:[[NSString alloc] initWithFormat:@"-radiusCache-%.1lf",radius]];
    }else
    {
        cacheurlStr=[urlStr stringByAppendingString:@"-radiusCache"];
    }
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheurlStr];
    if (cacheImage) {
        self.contentMode=UIViewContentModeScaleAspectFill;
        self.image = cacheImage;
    }else {
        self.contentMode = UIViewContentModeCenter;
        [self sd_setImageWithURL:url placeholderImage:placeImg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                self.contentMode=UIViewContentModeScaleAspectFill;
                if(radius)
                {
                    UIImage *radiusImage = [UIImage createRoundedRectImage:image size:self.frame.size radius:radius];
                    self.image = radiusImage;
                    [[SDImageCache sharedImageCache] storeImage:radiusImage forKey:cacheurlStr];
                }else
                {
                    self.image = image;
                    [[SDImageCache sharedImageCache] storeImage:image forKey:cacheurlStr];
                }
                //清除原有非圆角图片缓存
                [[SDImageCache sharedImageCache] removeImageForKey:urlStr];
            }else
            {
                self.contentMode=UIViewContentModeCenter;
            }
        }];
    }

}


@end
