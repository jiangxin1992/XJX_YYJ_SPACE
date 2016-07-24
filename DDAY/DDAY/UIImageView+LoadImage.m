//
//  UIImageView+LoadImage.m
//  DDAY
//
//  Created by yyj on 16/6/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "UIImage+RoundedImage.h"
#import "UIImageView+LoadImage.h"

@implementation UIImageView (LoadImage)
- (void)JX_loadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius {
    
    NSString *urlStr=[regular getImgUrl:_urlStr WithSize:size];
    //something
    //这里有针对不同需求的处理，我就没贴出来了
    //...
    
    NSURL *url;
    
    if (placeHolderStr == nil) {
//        通用的图片
        placeHolderStr = @"headImg_login1";
    }
    
    //这里传CGFLOAT_MIN，就是默认以图片宽度的一半为圆角
    if (radius == CGFLOAT_MIN) {
        radius = self.frame.size.width/2.0;
    }
    
    url = [NSURL URLWithString:urlStr];
    
    if (radius != 0.0) {
        //头像需要手动缓存处理成圆角的图片
        NSString *cacheurlStr = [urlStr stringByAppendingString:@"radiusCache"];
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheurlStr];
        if (cacheImage) {
            self.image = cacheImage;
        }
        else {
            [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:placeHolderStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!error) {
                    UIImage *radiusImage = [UIImage createRoundedRectImage:image size:self.frame.size radius:radius];
                    self.image = radiusImage;
                    [[SDImageCache sharedImageCache] storeImage:radiusImage forKey:cacheurlStr];
                    //清除原有非圆角图片缓存
                    [[SDImageCache sharedImageCache] removeImageForKey:urlStr];
                }
            }];
        }
    }
    else {
        [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:placeHolderStr] completed:nil];
    }
}
@end
