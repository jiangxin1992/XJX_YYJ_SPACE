//
//  UIImageView+LoadImage.m
//  DDAY
//
//  Created by yyj on 16/6/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "UIImageView+LoadImage.h"

#import "UIImage+RoundedImage.h"

#import <ImageIO/ImageIO.h>

@implementation UIImageView (LoadImage)


- (void)JX_ScaleToFill_loadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius
{
    NSString *urlStr=[regular getImgUrl:_urlStr WithSize:size];
    
    NSURL *url=[NSURL URLWithString:urlStr];
//    YYAnimatedImageView *placeHolder=[[YYAnimatedImageView alloc] init];
    
//    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
//    if (cacheImage) {
//        for (id obj in self.subviews) {
//            if([obj isKindOfClass:[YYAnimatedImageView class]])
//            {
//                [obj removeFromSuperview];
//            }
//        }
        //        placeHolder.hidden=YES;
//        self.image = cacheImage;
//    }else {
//        [self addSubview:placeHolder];
//        placeHolder.contentMode=UIViewContentModeCenter;
//        [placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(self);
//        }];
//        NSURL *path = [[NSBundle mainBundle]URLForResource:@"loading" withExtension:@"gif"];
//        placeHolder.imageURL = path;
        
        [self sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            JXLOG(@"SDImageCacheType=%ld",cacheType);
//            if (!error) {
//                self.image = image;
//                [[SDImageCache sharedImageCache] storeImage:image forKey:urlStr];
//                
//                for (id obj in self.subviews) {
//                    if([obj isKindOfClass:[YYAnimatedImageView class]])
//                    {
//                        [obj removeFromSuperview];
//                    }
//                }
//                //                placeHolder.hidden=YES;
//            }else
//            {}
        }];
//    }
    
}

- (void)JX_ScaleAspectFit_loadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius
{
    NSString *urlStr=[regular getImgUrl:_urlStr WithSize:size];
    
    NSURL *url=[NSURL URLWithString:urlStr];
//    YYAnimatedImageView *placeHolder=[[YYAnimatedImageView alloc] init];
    
//    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
//    if (cacheImage) {
//        for (id obj in self.subviews) {
//            if([obj isKindOfClass:[YYAnimatedImageView class]])
//            {
//                [obj removeFromSuperview];
//            }
//        }
        //        placeHolder.hidden=YES;
//        self.image = cacheImage;
//    }else {
//        [self addSubview:placeHolder];
//        placeHolder.contentMode=UIViewContentModeCenter;
//        [placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(self);
//        }];
//        NSURL *path = [[NSBundle mainBundle]URLForResource:@"loading" withExtension:@"gif"];
//        placeHolder.imageURL = path;
        
        [self sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            JXLOG(@"SDImageCacheType=%ld",cacheType);
//            if (!error) {
//                self.image = image;
//                [[SDImageCache sharedImageCache] storeImage:image forKey:urlStr];
//                
//                for (id obj in self.subviews) {
//                    if([obj isKindOfClass:[YYAnimatedImageView class]])
//                    {
//                        [obj removeFromSuperview];
//                    }
//                }
//                //                placeHolder.hidden=YES;
//            }else
//            {}
        }];
//    }
    
}

- (void)JX_ScaleAspectFill_loadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius
{
    NSString *urlStr=[regular getImgUrl:_urlStr WithSize:size];
    
    NSURL *url=[NSURL URLWithString:urlStr];
//    YYAnimatedImageView *placeHolder=[[YYAnimatedImageView alloc] init];
    
//    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
//    if (cacheImage) {
//        for (id obj in self.subviews) {
//            if([obj isKindOfClass:[YYAnimatedImageView class]])
//            {
//                [obj removeFromSuperview];
//            }
//        }
//        placeHolder.hidden=YES;
//        self.image = cacheImage;
//    }else {
//        [self addSubview:placeHolder];
//        placeHolder.contentMode=UIViewContentModeCenter;
//        [placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(self);
//        }];
//        NSURL *path = [[NSBundle mainBundle]URLForResource:@"loading" withExtension:@"gif"];
//        placeHolder.imageURL = path;
    
        [self sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            JXLOG(@"SDImageCacheType=%ld",cacheType);
//            if (!error) {
//                self.image = image;
//                [[SDImageCache sharedImageCache] storeImage:image forKey:urlStr];
//                
//                for (id obj in self.subviews) {
//                    if([obj isKindOfClass:[YYAnimatedImageView class]])
//                    {
//                        [obj removeFromSuperview];
//                    }
//                }
////                placeHolder.hidden=YES;
//            }else
//            {}
        }];
//    }

}

@end
