//
//  UIImageView+LoadImage.m
//  DDAY
//
//  Created by yyj on 16/6/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "UIImageView+LoadImage.h"

#import "UIImage+RoundedImage.h"

#import <YYKit/YYKit.h>
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
    
    
//    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
//    if (cacheImage) {
////        self.contentMode=UIViewContentModeScaleToFill;
//        self.image = cacheImage;
//    }else {
//        UIImageView *placeHolder=[UIImageView getCustomImg];
//        [self addSubview:placeHolder];
//        placeHolder.frame=CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
//        placeHolder.image=placeImg;
//        placeHolder.contentMode=UIViewContentModeCenter;
//        [self sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (error){
////                self.contentMode=UIViewContentModeScaleToFill;
//            }else
//            {
//                self.image = image;
//                [[SDImageCache sharedImageCache] storeImage:image forKey:urlStr];
//                placeHolder.hidden=YES;
////                self.contentMode=UIViewContentModeScaleToFill;
//            }
//        }];
//    }
    [self sd_setImageWithURL:url placeholderImage:placeImg completed:nil];

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
    
//    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
//    if (cacheImage) {
////        self.contentMode=UIViewContentModeScaleAspectFit;
//        self.image = cacheImage;
//    }else {
////        self.contentMode = UIViewContentModeCenter;
//        UIImageView *placeHolder=[UIImageView getCustomImg];
//        [self addSubview:placeHolder];
//        placeHolder.frame=CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
//        placeHolder.image=placeImg;
//        placeHolder.contentMode=UIViewContentModeCenter;
//        [self sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (error){
////                self.contentMode=UIViewContentModeScaleAspectFit;
//            }else
//            {
//                self.image = image;
//                [[SDImageCache sharedImageCache] storeImage:image forKey:urlStr];
////                self.contentMode=UIViewContentModeScaleAspectFit;
//                placeHolder.hidden=YES;
//            }
//        }];
//    }
    [self sd_setImageWithURL:url placeholderImage:placeImg completed:nil];

}

- (void)JX_ScaleAspectFill_loadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius
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
    
//    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
//    if (cacheImage) {
////        self.contentMode=UIViewContentModeScaleAspectFill;
//        self.image = cacheImage;
//    }else {
//        UIImageView *placeHolder=[UIImageView getCustomImg];
//        [self addSubview:placeHolder];
//        placeHolder.frame=CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
//        placeHolder.image=placeImg;
//        placeHolder.contentMode=UIViewContentModeCenter;
////        self.contentMode = UIViewContentModeCenter;
//        [self sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (error){
////                self.contentMode=UIViewContentModeScaleAspectFill;
//            }else
//            {
//                self.image = image;
//                [[SDImageCache sharedImageCache] storeImage:image forKey:urlStr];
////                self.contentMode=UIViewContentModeScaleAspectFill;
//                placeHolder.hidden=YES;
//            }
//        }];
//    }
    [self sd_setImageWithURL:url placeholderImage:placeImg completed:nil];

}


@end
