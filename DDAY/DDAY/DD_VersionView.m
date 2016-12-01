//
//  DD_VersionView.m
//  YCOSPACE
//
//  Created by yyj on 2016/12/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_VersionView.h"

#import <WebKit/WebKit.h>

@interface DD_VersionView ()<WKNavigationDelegate>

@end

@implementation DD_VersionView
{
    UIView *_backView;
    
    WKWebView *_web;
    UILabel *_titleLabel;
    UILabel *_versionLabel;
}
static DD_VersionView *versionView = nil;
#pragma mark - 创建单例
+(id)sharedManagerWithModel:(DD_VersionModel *)versionModel WithBlock:(void (^)(NSString *type))block;
{
    //    创建CustomTabbarController的单例，并通过此方法调用
    //    互斥锁，确保单例只能被创建一次
    @synchronized(self)
    {
        if (!versionView) {
            versionView = [[DD_VersionView alloc]initWithModel:versionModel WithBlock:block];
        }else
        {
            versionView.versionModel=versionModel;
            [versionView SetState];
        }
    }
    return versionView;
}

-(instancetype)initWithModel:(DD_VersionModel *)versionModel WithBlock:(void (^)(NSString *type))block
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        _block=block;
        _versionModel=versionModel;
        [self UIConfig];
        [self SetState];
    }
    return self;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    
    _backView=[UIView getCustomViewWithColor:_define_white_color];
    [self addSubview:_backView];
    _backView.layer.masksToBounds=YES;
    _backView.layer.borderWidth=1;
    _backView.layer.borderColor=[_define_black_color CGColor];
    _backView.layer.cornerRadius=11;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(295);
    }];
    
    _titleLabel=[UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:20.0f WithTextColor:nil WithSpacing:0];
    [_backView addSubview:_titleLabel];
    _titleLabel.font=[regular getSemiboldFont:20.0f];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
    }];
    
    _versionLabel=[UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [_backView addSubview:_versionLabel];
    _versionLabel.textColor=_define_light_gray_color1;
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(_titleLabel.mas_bottom).with.offset(14);
    }];
    
    UIView *lineView=[UIView getCustomViewWithColor:_define_black_color];
    [_backView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_versionLabel.mas_bottom).with.offset(23);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
    }];
    
    _web=[[WKWebView alloc] init];
    _web.navigationDelegate = self;
    [_backView addSubview:_web];
    [_web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).with.offset(30);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(0);
    }];
    _web.backgroundColor= _define_clear_color;
    
    UIButton *_versionBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"去更新" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [_backView addSubview:_versionBtn];
    _versionBtn.backgroundColor=_define_light_orange_color;
    [_versionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_web.mas_bottom).with.offset(30);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.width.mas_equalTo(45);
        make.bottom.mas_equalTo(-25);
    }];
    [_versionBtn bk_addEventHandler:^(id sender) {
        _block(@"update");
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *_closeBtn=[UIButton getCustomBackImgBtnWithImageStr:@"System_Delete_Black" WithSelectedImageStr:nil];
    [self addSubview:_closeBtn];
    [_closeBtn setEnlargeEdge:20];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.height.width.mas_equalTo(26);
        make.top.mas_equalTo(_backView.mas_bottom).with.mas_equalTo(25);
    }];
    [_closeBtn bk_addEventHandler:^(id sender) {
        _block(@"close");
    } forControlEvents:UIControlEventTouchUpInside];
}
-(void)SetState
{
    _titleLabel.text=_versionModel.title;
    _versionLabel.text=[[NSString alloc] initWithFormat:@"V %@",_versionModel.appVersion];
    _versionModel.updateInfo=@"1963年进入东映动画公司，从事动画师工作。1971年加入手冢治虫成立的““虫Production动画部”。1974年加入Zuiyou映像与高田勋、小田部羊一共同创作《阿尔卑斯山的少女》[2]  。1979年转入东京电影新社创作了自己首部电影《鲁邦三世卡里奥斯特罗之城》[3]  。1982年开始独立创作漫画，在《Animage》上连载漫画《风之谷》，该作品获得第23届日本漫画家协会赏[4]  。1984年执导《风之谷》，该片获得罗马奇幻电影节最佳动画短片奖等4项大奖[5]  。1985年与高田勋、铃木敏夫共同创立吉卜力工作室。1986年执导《天空之城》，该片获得第41回每日电影奖大藤信郎赏等6项大奖。1988年执导《龙猫》，该片荣获第13回报知电影奖最佳导演奖等24项大奖。1997年执导《幽灵公主》，该片荣获第21届日本电影学院奖最佳影片奖等27项大奖[6]  。2001年执导《千与千寻》，该片荣获第75届奥斯卡金像奖最佳动画长片奖及第52届柏林电影节最高荣誉“金熊奖”等9项大奖[7]  。2004年执导《哈尔的移动城堡》，该片荣获第9届好莱坞电影奖最佳动画片奖等8项大奖[8]  。1985年与高田勋、铃木敏夫共同创立吉卜力工作室。1986年执导《天空之城》，该片获得第41回每日电影奖大藤信郎赏等6项大奖。1988年执导《龙猫》，该片荣获第13回报知电影奖最佳导演奖等24项大奖。1997年执导《幽灵公主》，该片荣获第21届日本电影学院奖最佳影片奖等27项大奖[6]  。2001年执导《千与千寻》，该片荣获第75届奥斯卡金像奖最佳动画长片奖及第52届柏林电影节最高荣誉“金熊奖”等9项大奖[7]  。2004年执导《哈尔的移动城堡》，该片荣获第9届好莱坞电影奖最佳动画片奖等8项大奖[8]  。1985年与高田勋、铃木敏夫共同创立吉卜力工作室。1986年执导《天空之城》，该片获得第41回每日电影奖大藤信郎赏等6项大奖。1988年执导《龙猫》，该片荣获第13回报知电影奖最佳导演奖等24项大奖。1997年执导《幽灵公主》，该片荣获第21届日本电影学院奖最佳影片奖等27项大奖[6]  。2001年执导《千与千寻》，该片荣获第75届奥斯卡金像奖最佳动画长片奖及第52届柏林电影节最高荣誉“金熊奖”等9项大奖[7]  。2004年执导《哈尔的移动城堡》，该片荣获第9届好莱坞电影奖最佳动画片奖等8项大奖[8]  。1985年与高田勋、铃木敏夫共同创立吉卜力工作室。1986年执导《天空之城》，该片获得第41回每日电影奖大藤信郎赏等6项大奖。1988年执导《龙猫》，该片荣获第13回报知电影奖最佳导演奖等24项大奖。1997年执导《幽灵公主》，该片荣获第21届日本电影学院奖最佳影片奖等27项大奖[6]  。2001年执导《千与千寻》，该片荣获第75届奥斯卡金像奖最佳动画长片奖及第52届柏林电影节最高荣誉“金熊奖”等9项大奖[7]  。2004年执导《哈尔的移动城堡》，该片荣获第9届好莱坞电影奖最佳动画片奖等8项大奖[8]  。1985年与高田勋、铃木敏夫共同创立吉卜力工作室。1986年执导《天空之城》，该片获得第41回每日电影奖大藤信郎赏等6项大奖。1988年执导《龙猫》，该片荣获第13回报知电影奖最佳导演奖等24项大奖。1997年执导《幽灵公主》，该片荣获第21届日本电影学院奖最佳影片奖等27项大奖[6]  。2001年执导《千与千寻》，该片荣获第75届奥斯卡金像奖最佳动画长片奖及第52届柏林电影节最高荣誉“金熊奖”等9项大奖[7]  。2004年执导《哈尔的移动城堡》，该片荣获第9届好莱坞电影奖最佳动画片奖等8项大奖[8]  。1985年与高田勋、铃木敏夫共同创立吉卜力工作室。1986年执导《天空之城》，该片获得第41回每日电影奖大藤信郎赏等6项大奖。1988年执导《龙猫》，该片荣获第13回报知电影奖最佳导演奖等24项大奖。1997年执导《幽灵公主》，该片荣获第21届日本电影学院奖最佳影片奖等27项大奖[6]  。2001年执导《千与千寻》，该片荣获第75届奥斯卡金像奖最佳动画长片奖及第52届柏林电影节最高荣誉“金熊奖”等9项大奖[7]  。2004年执导《哈尔的移动城堡》，该片荣获第9届好莱坞电影奖最佳动画片奖等8项大奖[8]  。1985年与高田勋、铃木敏夫共同创立吉卜力工作室。1986年执导《天空之城》，该片获得第41回每日电影奖大藤信郎赏等6项大奖。1988年执导《龙猫》，该片荣获第13回报知电影奖最佳导演奖等24项大奖。1997年执导《幽灵公主》，该片荣获第21届日本电影学院奖最佳影片奖等27项大奖[6]  。2001年执导《千与千寻》，该片荣获第75届奥斯卡金像奖最佳动画长片奖及第52届柏林电影节最高荣誉“金熊奖”等9项大奖[7]  。2004年执导《哈尔的移动城堡》，该片荣获第9届好莱坞电影奖最佳动画片奖等8项大奖[8]  。1985年与高田勋、铃木敏夫共同创立吉卜力工作室。1986年执导《天空之城》，该片获得第41回每日电影奖大藤信郎赏等6项大奖。1988年执导《龙猫》，该片荣获第13回报知电影奖最佳导演奖等24项大奖。1997年执导《幽灵公主》，该片荣获第21届日本电影学院奖最佳影片奖等27项大奖[6]  。2001年执导《千与千寻》，该片荣获第75届奥斯卡金像奖最佳动画长片奖及第52届柏林电影节最高荣誉“金熊奖”等9项大奖[7]  。2004年执导《哈尔的移动城堡》，该片荣获第9届好莱坞电影奖最佳动画片奖等8项大奖[8]  。";
    
    [_web loadHTMLString:[regular getHTMLStringWithContent:_versionModel.updateInfo WithFont:@"15px/20px" WithColorCode:@"#A8A7A7"] baseURL:nil];
    [_web sizeToFit];
}
#pragma mark - WKNavigationDelegate

//加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        
        CGFloat height = [result doubleValue];
        
        [webView mas_updateConstraints:^(MASConstraintMaker *make) {
            if(height>IsPhone6_gt?200:180)
            {
                make.height.mas_equalTo(IsPhone6_gt?200:180);
            }else
            {
                make.height.mas_equalTo(height);
            }
        }];
    }];
}

@end
