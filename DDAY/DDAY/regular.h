//
//  regular.h
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface regular : NSObject

/**
 * 单例
 */
+(id)sharedManager;

/** 用户是否打开推送开关*/
+ (BOOL)isEnableAPNS;

/** 获取当前DNS*/
+ (NSString *)getDNS;

/** 获取保留小数点后两位数的字符串*/
+ (NSString *)getRoundNum:(CGFloat )num;

/**
 * 获取html
 * content 内容
 * font 字体大小
 * 字体颜色
 */
+ (NSString *)getHTMLStringWithContent:(NSString *)content WithFont:(NSString *)font WithColorCode:(NSString *)color;

/**
 * 固定内容 字体下
 * 获取高度
 */
+(CGFloat )getHeightWithWidth:(CGFloat )width WithContent:(NSString *)content WithFont:(UIFont *)font;

/**
 * 固定内容 字体下
 * 获取宽度
 */
+(CGFloat )getWidthWithHeight:(CGFloat )height WithContent:(NSString *)content WithFont:(UIFont *)font;

/** 获取过去时间的时间区间*/
+(NSString *)getSpacingTime:(long)createTime;

/**
 * 更新用户权限
 */
+(void)UpdateRoot;

/**
 * 获取下拉动画图片数组
 */
+(NSArray *)getGifImg;

/**
 * 更新友盟用户统计和渠道
 */
+(void)updateProfileSignInWithPUID;

/**
 * 根据shareAdvise获取当前label高度
 */
+(CGFloat )getHeightWithContent:(NSString *)shareAdvise WithWidth:(CGFloat)Width WithFont:(CGFloat )font;

/**
 * 画圆角
 */
+(void)drawLayerWithView:(UIView *)view WithR:(CGFloat )r WithColor:(UIColor *)color;

/**
 * 添加view边框
 * 黑色 边框宽度为1
 */
+(void)setBorder:(UIView *)view;

/**
 * 裁剪
 */
+(void)setZeroBorder:(UIView *)view;

/**
 * 添加自定义边框
 */
+(void)setBorder:(UIView *)view WithColor:(UIColor *)color WithWidth:(CGFloat )width;

/**
 * 获取tableview section head和foot的view
 */
+(UIView *)getViewForSection;

/**
 * 取消线程
 */
+(void)dispatch_cancel:(dispatch_source_t )_time;

/**
 * 获取时间戳对应的nsdate
 */
+(NSDate*)zoneChange:(long)time;

/**
 * 根据当前时间差 获取对应的剩余时间字符串
 */
+(NSString *)getTimeStr:(long)time;

/**
 * 时间戳转时间
 */
+(NSString *)getTimeStr:(long)time WithFormatter:(NSString *)_formatter;

/**
 * 获取时间戳
 */
+(long )getTimeWithTimeStr:(NSString *)time;

/**
 * 获取当前时间戳
 */
+(long)date;

/**
 * 进入系统设置
 */
+(void)pushSystem;

/**
 * 获取当前缓存大小
 */
+(NSString *)getSize;

/**
 * 键盘消失
 */
+(void)dismissKeyborad;

/** 中国大陆手机号判断*/
+ (BOOL)isMobilePhoneOrtelePhone:(NSString *)mobileNum ;

/**
 * 电子邮箱正则
 */
+ (BOOL )emailVerify:(NSString *)email;
/**
 * 正则匹配用户密码6-15位数字和字母组合
 */
+ (BOOL)checkPassword:(NSString *) password;

/**
 * 验证码格式验证
 */
+(BOOL )codeVerify:(NSString *)phone;

/**
 * 邮编格式验证
 */
+(BOOL )PostCodeVerify:(NSString *)phone;

/**
 * 手机号码格式验证
 */
+(BOOL )phoneVerify:(NSString *)phone;

/**
 * 纯数字验证
 */
+(BOOL )numberVerift:(NSString *)phone;

/**
 * 固定电话区号正则
 */
+(BOOL )telephoneAreaCode:(NSString *)telephoneArea;

/**
 * 图片url
 */
+(NSString *)getImgUrl:(NSString *)img WithSize:(NSInteger )_size;

/**
 * 加密
 */
+ (NSString *)md5:(NSString *)str;

/**
 * 获取中文字体
 */
+(UIFont *)getFont:(CGFloat )font;

/**
 * 获取中文粗体
 */
+(UIFont *)getSemiboldFont:(CGFloat )font;

/**
 * 获取英文字体
 */
+(UIFont *)get_en_Font:(CGFloat )font;

/**
 * 获取alert视图
 * title标题内容
 */
+(UIAlertController *)alertTitle_Simple:(NSString *)title;

/**
 * 获取alert视图
 * title标题内容
 * 点击OK回调
 */
+(UIAlertController *)alertTitle_Simple:(NSString *)title WithBlock:(void(^)())block;

/**
 * 获取alert视图
 * title标题内容
 * 点击OK回调
 * 带了个取消
 */
+(UIAlertController *)alertTitleCancel_Simple:(NSString *)title WithBlock:(void(^)())block;

/**
 * 网络错误下的alert视图
 */
+(UIAlertController *)alert_NONETWORKING;

/**
 * 获取标题视图
 */
+ (UIView *)returnNavView:(NSString *)title withmaxwidth:(CGFloat )maxwidth;

/**
 * 设置字间距
 */
+ (NSAttributedString *)createAttributeString:(NSString *)str andFloat:(NSNumber*)nsKern;

@property (nonatomic,strong)NSString *value;

@property(nonatomic,copy) CGFloat (^getSize)(CGFloat length1,CGFloat length2,CGFloat length3);

@end
