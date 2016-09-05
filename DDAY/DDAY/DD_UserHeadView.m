//
//  DD_UserHeadView.m
//  DDAY
//
//  Created by yyj on 16/5/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserHeadView.h"

@implementation DD_UserHeadView
{
    UIImageView *head;
    UILabel *nickname;
    UILabel *integral;
}
#pragma mark - 初始化
/**
 * 初始化方法
 */
+(instancetype)buttonWithType:(UIButtonType)buttonType WithModel:(DD_UserModel *)usermodel WithBlock:(void(^)(NSString *type))block
{
    DD_UserHeadView *_headview=[DD_UserHeadView buttonWithType:buttonType];
    if(_headview)
    {
        _headview.touchblock=block;
        _headview.usermodel=usermodel;
    }
    return _headview;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor=_define_backview_color;
        //设置normal状态下 title的颜色
        [self setTitleColor:_define_black_color forState:UIControlStateNormal];
        //设置字体大小
        self.titleLabel.font=[regular getFont:17.0f];
        //设置居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - SomeAction
/**
 * 点击用户视图
 */
-(void)touchAction
{
    if([DD_UserModel isLogin])
    {
        _touchblock(@"userinfo");
    }else
    {
        _touchblock(@"login");
    }
}
/**
 * 更新
 */
-(void)updateState
{
    if([DD_UserModel isLogin])
    {
        [self loginState];
    }else
    {
        [self logoutState];
    }
}
/**
 * 登出状态
 */
-(void)logoutState
{
    [head removeFromSuperview];
    [nickname removeFromSuperview];
    [integral removeFromSuperview];
    //        未登录
    [self setTitle:@"登录" forState:UIControlStateNormal];
}
/**
 * 登录状态
 */
-(void)loginState
{
    
    //        登录
    [self setTitle:@"" forState:UIControlStateNormal];
    //        刷新用户信息
    head=[UIImageView getCornerRadiusImg];
    head.frame=CGRectMake(10, 10, 80, 80);
    [self addSubview:head];
    head.contentMode=2;
    [regular setZeroBorder:head];
    [head JX_ScaleAspectFill_loadImageUrlStr:_usermodel.head WithSize:800 placeHolderImageName:nil radius:CGRectGetWidth(head.frame)/2.0f];
    
    nickname=[[UILabel alloc] initWithFrame:CGRectMake(100, 10, 150, 80)];
    [self addSubview:nickname];
    nickname.font=[regular getFont:17.0f];
    nickname.textColor=_define_black_color;
    nickname.textAlignment=0;
    nickname.text=_usermodel.nickName;
    
    integral=[[UILabel alloc] initWithFrame:CGRectMake(260, 10, 100, 80)];
    [self addSubview:integral];
    integral.font=[regular getFont:17.0f];
    integral.textColor=_define_black_color;
    integral.textAlignment=2;
    integral.text=@"积分 3000分";
}

@end
