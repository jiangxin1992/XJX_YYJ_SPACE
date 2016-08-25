//
//  DD_RGBModel.m
//  YCO SPACE
//
//  Created by yyj on 16/8/25.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_RGBModel.h"

@implementation DD_RGBModel
+(DD_RGBModel *)initWithColorCode:(NSString *)colorCode
{
    NSMutableString *mustr=[[NSMutableString alloc] initWithFormat:@"%@",colorCode];
    // 转换成标准16进制数
    [mustr replaceCharactersInRange:[colorCode rangeOfString:@"#" ] withString:@"0x"];
    DD_RGBModel *model=[[DD_RGBModel alloc] init];
    // 十六进制字符串转成整形。
    long colorLong = strtoul([mustr cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    // 通过位与方法获取三色值
    model.R = (colorLong & 0xFF0000 )>>16;
    model.G = (colorLong & 0x00FF00 )>>8;
    model.B =  colorLong & 0x0000FF;
    return model;
}
@end
