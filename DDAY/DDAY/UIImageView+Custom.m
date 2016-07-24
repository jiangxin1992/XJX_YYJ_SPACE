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
    return imageview;
}
@end
