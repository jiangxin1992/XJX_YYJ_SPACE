//
//  UIImageView+Custom.m
//  DDAY
//
//  Created by yyj on 16/7/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "UIImageView+Custom.h"


@implementation UIImageView (Custom)


+(UIImageView *)getImgWithImageStr:(NSString *)_imageStr
{
    UIImageView *imageview=[[UIImageView alloc] init];
    imageview.userInteractionEnabled=YES;
    if(_imageStr){
        imageview.image=[UIImage imageNamed:_imageStr];
    }
    imageview.contentMode=UIViewContentModeScaleAspectFit;
    return imageview;
}

+(UIImageView *)getloadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius
{
    UIImageView *imageview=[[UIImageView alloc] init];
    imageview.userInteractionEnabled=YES;
    [imageview JX_loadImageUrlStr:_urlStr WithSize:size placeHolderImageName:placeHolderStr radius:radius];
    imageview.contentMode=UIViewContentModeScaleAspectFit;
    return imageview;
}

+(UIImageView *)getMaskImageView
{
    UIImageView *mengban=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    mengban.userInteractionEnabled=YES;
    mengban.image=[UIImage imageNamed:@"System_Mask"];
    return mengban;
}
+(UIImageView *)getCustomImg
{
    UIImageView *img=[[UIImageView alloc] init];
    img.contentMode=UIViewContentModeScaleAspectFit;
    return img;
}
@end
