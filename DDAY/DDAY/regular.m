//
//  regular.m
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "Tools.h"
#import "regular.h"
#import <CommonCrypto/CommonDigest.h>
@implementation regular
static regular *_t = nil;
/**
 * 单例
 */
+(id)sharedManager
{
    @synchronized(self)
    {
        if (!_t) {
            _t = [[regular alloc]init];
        }
    }
    return _t;
}
+(UIButton *)getBarCustomBtnWithImg:(NSString *)_img WithSelectImg:(NSString *)_select_img WithSize:(CGSize )_size
{
    UIButton *_btn=[UIButton getCustomBackImgBtnWithImageStr:_img WithSelectedImageStr:_select_img];
    _btn.frame=CGRectMake(0, 0, _size.width, _size.height);
    return _btn;
}
+(void)updateProfileSignInWithPUID
{
    if(![[DD_UserModel getToken] isEqualToString:@""])
    {
        NSInteger _thirdPartType=[DD_UserModel getThirdPartLogin];
        NSString *_provider=_thirdPartType==2?@"WECHAT":_thirdPartType==3?@"QQ":_thirdPartType==3?@"SINA":@"PHONE";
        NSString *token=[DD_UserModel getToken];
        [MobClick profileSignInWithPUID:token provider:_provider];
    }
    
}
+(void)drawLayerWithView:(UIView *)view WithR:(CGFloat )r WithColor:(UIColor *)color
{
    view.layer.masksToBounds=YES;
    view.layer.borderWidth=1;
    view.layer.borderColor=[color CGColor];
    view.layer.cornerRadius=5;
}
+(UIView *)getViewForSection
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
+(void)setBorder:(UIView *)view
{
    view.layer.masksToBounds=YES;
    view.layer.borderColor=[[UIColor blackColor] CGColor];
    view.layer.borderWidth=1;
}
+(void)dismissKeyborad
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
+(BOOL )codeVerify:(NSString *)phone
{
    return [self Verify:phone WithCode:@"^[A-Za-z0-9]+$"];
}
+(BOOL )phoneVerify:(NSString *)phone
{
    return [self Verify:phone WithCode:@"^1[3|4|5|7|8][0-9]\\d{8}$"];
}
+(BOOL )PostCodeVerify:(NSString *)phone
{
    return [self Verify:phone WithCode:@"[1-9]\\d{5}(?![0-9])"];
}
+(BOOL )pswLengthVerify:(NSString *)phone
{
    if(phone.length>=6&&phone.length<=15)
    {
        return YES;
    }
    return NO;
}
+(BOOL)numberVerift:(NSString *)phone
{
    return [self Verify:phone WithCode:@"^[0-9]+([.]{0,1}[0-9]+){0,1}$"];
}
+(BOOL)Verify:(NSString *)content WithCode:(NSString *)code
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:code options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:content options:0 range:NSMakeRange(0, [content length])];
    if (result) {
        return YES;
    }
    return NO;
}
+ (NSString *)md5:(NSString *)str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
+(UIFont *)get_en_Font:(CGFloat)font
{
    CGFloat _font=0;
    if(_isPad)
    {
        _font=font+16;
        
    }else
    {
        _font=font;
        
    }
    return [UIFont fontWithName:@"HelveticaNeue" size:_font];
}
+(UIFont *)getFont:(CGFloat )font
{
    CGFloat _font=0;
    if(_isPad)
    {
        _font=font+16;
        
    }else
    {
        _font=font;
        
    }
    return (kIOSVersions_v9? [UIFont fontWithName:@"PingFangSC-Regular" size:_font]:[UIFont fontWithName:@"HelveticaNeue" size:_font]);
}
+(UIFont *)getSemiboldFont:(CGFloat )font
{
    CGFloat _font=0;
    if(_isPad)
    {
        _font=font+16;
        
    }else
    {
        _font=font;
        
    }
    return (kIOSVersions_v9? [UIFont fontWithName:@"PingFangSC-Semibold" size:_font]:[UIFont fontWithName:@"HelveticaNeue-Bold" size:_font]);
}
+(UIAlertController *)alertTitle_Simple:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    return alertController;
}
+(UIAlertController *)alertTitle_Simple:(NSString *)title WithBlock:(void(^)())block
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block();
    }];
    [alertController addAction:okAction];
    return alertController;
}
+(UIAlertController *)alert_NONETWORKING
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"NetworkConnectError", @"") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    return alertController;
}
+(UIView *)returnNavView:(NSString *)title withmaxwidth:(CGFloat )maxwidth
{
    
    
    CGFloat _Default_font=16.0;
    CGFloat _Default_Spacing=3.0f;
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, maxwidth, 40)];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];

    titleLabel.font =  [regular getSemiboldFont:_Default_font];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.textAlignment=1;
    [titleLabel setAttributedText:[regular createAttributeString:title andFloat:@(_Default_Spacing)]];
    [view addSubview:titleLabel];
    [titleLabel sizeToFit];
    BOOL _isfit;
    if(CGRectGetWidth(titleLabel.frame)<=maxwidth)
    {
        _isfit=NO;
    }else
    {
        for (int i=_Default_font*2;i>0;i--) {
            
            
            if(_Default_Spacing<=0)
            {
                _Default_font-=0.5f;
                
            }else
            {
                _Default_Spacing-=0.5f;
            }
            titleLabel.font =
            (kIOSVersions>=9.0? [UIFont systemFontOfSize:_Default_font]:[UIFont fontWithName:@"Helvetica Neue" size:_Default_font]);
            [titleLabel setAttributedText:[regular createAttributeString:title andFloat:@(_Default_Spacing)]];
            [titleLabel sizeToFit];
            if(CGRectGetWidth(titleLabel.frame)<=maxwidth||_Default_font<=13.0f)
            {
                break;
            }
        }
    }
    
    if(CGRectGetWidth(titleLabel.frame)>maxwidth&&_Default_font==13.0f)
    {
        titleLabel.frame=CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
        
    }else
    {
        titleLabel.frame=CGRectMake((CGRectGetWidth(view.frame)-CGRectGetWidth(titleLabel.frame))/2.0f, (CGRectGetHeight(view.frame)-CGRectGetHeight(titleLabel.frame))/2.0f, CGRectGetWidth(titleLabel.frame), CGRectGetHeight(titleLabel.frame));
        
    }
    return view;
}
+ (NSMutableAttributedString *)createAttributeString:(NSString *)str andFloat:(NSNumber*)nsKern{
    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:str attributes:@{NSKernAttributeName : nsKern}];
    return attributedString;
}
+(NSString *)getImgUrl:(NSString *)img WithSize:(NSInteger )_size
{
    return [[NSString alloc] initWithFormat:@"%@-z%ld.jpg",img,_size];
}
+(NSString *)getSize
{
    SDImageCache *cache=[SDImageCache sharedImageCache];
    NSInteger cachecount=cache.getDiskCount;
    return [[NSString alloc] initWithFormat:@"%.2f",cachecount/1024.0];
//    return  cacheSize;
//
//    return (CGFloat)(((CGFloat)[[SDImageCache sharedImageCache] getSize])/1024);
    
}

+(void)pushSystem
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
+(long)date
{
    return [[NSDate date] timeIntervalSince1970];
}
+(NSDate*)zoneChange:(long)time{
    return [NSDate dateWithTimeIntervalSince1970:time];
}
+(NSString *)getTimeStr:(long)time
{
    if(time>=0)
    {
        NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
        NSDate *today = [NSDate date];//得到当前时间
        
        //用来得到具体的时差
        unsigned int unitFlags =  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDate *NiceNewdate=[regular zoneChange:[regular date]+time];
        NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:NiceNewdate options:0];
        
        if([d day]<0||[d hour]<0||[d minute]<0||[d second]<0)
        {
            return @"发布会已结束";
        }else
        {
            return [[NSString alloc] initWithFormat:@"%ld天%ld时%ld分%ld秒",[d day],[d hour],[d minute],[d second]];
        }
    }else
    {
        return @"发布会已结束";
    }
}
+(NSString *)getTimeStr:(long)time WithFormatter:(NSString *)_formatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:_formatter];
     NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *nowtimeStr = [formatter stringFromDate:confromTimesp];//----------将nsdate按formatter格式转成nsstring
    return nowtimeStr;
}
+(void)dispatch_cancel:(dispatch_source_t )_timer
{
    if(_timer)
    {
        if(!dispatch_source_testcancel(_timer))
        {
            dispatch_source_cancel(_timer);
        }
    }
}
/**
 * 根据shareAdvise获取当前label高度
 */
+(CGFloat )getHeightWithContent:(NSString *)shareAdvise WithWidth:(CGFloat)Width WithFont:(CGFloat )font
{
    CGSize size=[Tools sizeOfStr:shareAdvise andFont:[regular getFont:font] andMaxSize:CGSizeMake(Width, 99999999) andLineBreakMode:NSLineBreakByWordWrapping];
    return size.height;
}
+(void)UpdateRoot
{
    [[JX_AFNetworking alloc] GET:@"user/queryUserType.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            if([DD_UserModel getUserType]!=[[data objectForKey:@"userType"] integerValue])
            {
                [DD_UserModel UpdateUserType:[[data objectForKey:@"userType"] integerValue]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"rootChange" object:nil];
            }
        }else
        {
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
    }];
}

@end

