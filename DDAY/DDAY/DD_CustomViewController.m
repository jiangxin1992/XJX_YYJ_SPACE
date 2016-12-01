//
//  DD_CustomViewController.m
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CustomViewController.h"

#import "DD_BenefitListViewController.h"
#import "DD_UserViewController.h"
#import "DD_CircleViewController.h"
#import "DD_DesignerMainViewController.h"
#import "DD_GoodsViewController.h"
#import "DD_DDAYViewController.h"
#import "DD_LoginViewController.h"

#import "DD_TabbarItem.h"
#import "DD_SignInAnimationView.h"
#import "DD_VersionView.h"

#import "DD_UnReadMsgModel.h"
#import "DD_VersionModel.h"

@interface DD_CustomViewController ()<UITabBarControllerDelegate>
{
    //    自定义的标签栏
    UIImageView *_tabbar;
    NSMutableArray *btnarr;
    
    DD_TabbarItem *_goodsItem;
    DD_TabbarItem *_designerItem;
    DD_TabbarItem *_ddayItem;
    DD_TabbarItem *_circleItem;
    DD_TabbarItem *_userItem;
    
    DD_UnReadMsgModel *_unReadMsgModel;
}

@end

@implementation DD_CustomViewController

static DD_CustomViewController *tabbarController = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.隐藏系统自带的标签栏
    [self SomePrepare];
    //2.添加一个自定义的view
    [self createTabbar];
    
    //3.添加按钮(标签)
    [self createTabbarItem];
    
    //4.设置视图控制器数组
    [self createViewControllers];
    
    [self UpdateNoReadMessageState];
    
    [self Notifications];
    
}

#pragma mark - SomePrepare
-(void)SomePrepare
{
    btnarr=[[NSMutableArray alloc] init];
    self.delegate=self;
    //1.隐藏系统自带的标签栏
    self.tabBar.hidden = YES;
    
    _goodsCtn=[[DD_GoodsViewController alloc]init];
    _designerCtn=[[DD_DesignerMainViewController alloc] init];
    _ddayCtn=[[DD_DDAYViewController alloc] init];
    _circleCtn=[[DD_CircleViewController alloc]init];
    _userCtn=[[DD_UserViewController alloc] init];
    
    _goodsItem = [DD_TabbarItem buttonWithType:UIButtonTypeCustom];
    _designerItem = [DD_TabbarItem buttonWithType:UIButtonTypeCustom];
    _ddayItem = [DD_TabbarItem buttonWithType:UIButtonTypeCustom];
    _circleItem = [DD_TabbarItem buttonWithType:UIButtonTypeCustom];
    _userItem = [DD_TabbarItem buttonWithType:UIButtonTypeCustom];
}
-(void)Notifications
{
    //        新增粉丝
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NEWFANS_NOT_Action) name:@"NEWFANS_NOT" object:nil];
    //        新的发布会通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NEWSERIES_NOT_Action) name:@"NEWSERIES_NOT" object:nil];
    //        已报名发布会开始的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(STARTSERIES_NOT_Action) name:@"STARTSERIES_NOT" object:nil];
    
    
    //        评论的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(COMMENTSHARE_NOT_Action) name:@"COMMENTSHARE_NOT" object:nil];
    //        评论回复的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(REPLYCOMMENT_NOT_Action) name:@"REPLYCOMMENT_NOT" object:nil];
    //        申请达人审核进度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DOYENAPPLY_NOT_Action) name:@"DOYENAPPLY_NOT" object:nil];
    
}
#pragma mark - NotificationsAction
//        申请达人审核进度通知
-(void)DOYENAPPLY_NOT_Action
{
    [self updateBtnStatus:3];
    [_circleCtn PushCircleApplyView];
}
//        评论回复的通知
-(void)REPLYCOMMENT_NOT_Action
{
    [self updateBtnStatus:3];
    [_circleCtn PushCircleDetailView];
}
//        评论的通知
-(void)COMMENTSHARE_NOT_Action
{
    [self updateBtnStatus:3];
    [_circleCtn PushCircleDetailView];
}
//        新的发布会通知
-(void)NEWSERIES_NOT_Action
{
    [self updateBtnStatus:2];
    [_ddayCtn PushDDAYDetailView];
}
//        已报名发布会开始的通知
-(void)STARTSERIES_NOT_Action
{
    [self updateBtnStatus:2];
    [_ddayCtn PushDDAYDetailView];
}
//        新增粉丝
-(void)NEWFANS_NOT_Action
{
    [self updateBtnStatus:4];
    [_userCtn PushFansView];
}

#pragma mark - 创建单例
+(id)sharedManager
{
    //    创建CustomTabbarController的单例，并通过此方法调用
    //    互斥锁，确保单例只能被创建一次
    @synchronized(self)
    {
        
        if (!tabbarController) {
            tabbarController = [[DD_CustomViewController alloc]init];
        }
    }
    return tabbarController;
}

#pragma mark - UIConfig

-(void)createViewControllers
{

    //     创建数组并初始化
    NSMutableArray *vcs = [[NSMutableArray alloc]init];
    for (int i = 0; i<5; i++) {
        //        三目运算创建视图
        UIViewController *vc =i==0?_goodsCtn:i==1?_designerCtn:i==2?_ddayCtn:i==3?_circleCtn:_userCtn;
        //        将创建视图加入到navi中
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
        
        [vcs addObject:navi];
    }
    //    将数组中的视图添加到当前的tabbarController中去
    self.viewControllers = vcs;
    self.selectedIndex=0;
    
}
-(void)createTabbarItem
{
    //    创建存放视图标题的数组
    NSArray *titleArr=@[
                        NSLocalizedString(@"goods_title", @"")
                        ,NSLocalizedString(@"designer_title", @"")
                        ,NSLocalizedString(@"dday_title", @"")
                        ,NSLocalizedString(@"circle_title", @"")
                        ,NSLocalizedString(@"user_title", @"")
                        ];
    NSArray *normalImgArr=@[
                            @"Item_Tabbar_Normal"
                            ,@"Designer_Tabbar_Normal"
                            ,@"DDAY_Tabbar_Normal"
                            ,@"Circle_Tabbar_Normal"
                            ,@"User_Tabar_Normal"];
    NSArray *selectImgArr=@[
                            @"Item_Tabbar_Select"
                            ,@"Designer_Tabbar_Select"
                            ,@"DDAY_Tabbar_Select"
                            ,@"Circle_Tabbar_Select"
                            ,@"User_Tabbar_Select"];
    
    CGFloat buttonWidth =ScreenWidth/5;
    for (int i = 0; i<titleArr.count; i++) {
        DD_TabbarItem *item = i==0?_goodsItem:i==1?_designerItem:i==2?_ddayItem:i==3?_circleItem:_userItem;
        //        设置item的frame，标题，normal和select的图片
        //锁定第一个视图为默认出现页面
        if (i == 0) {
            item.selected = YES;
        }
        //        添加标签
        item.tag = 100 + i;
        //        添加select响应事件
        [item addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        [item setImage:[UIImage imageNamed:normalImgArr[i]] forState:UIControlStateNormal];
        [item setImage:[UIImage imageNamed:selectImgArr[i]] forState:UIControlStateSelected];
        //        再自定义标签栏中加入item
        [_tabbar addSubview:item];
        if(btnarr!=nil)
        {
            [btnarr addObject:item];
        }
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i*buttonWidth);
            make.bottom.and.top.mas_equalTo(0);
            make.width.mas_equalTo(buttonWidth);
        }];
    }
    
}
-(void)createTabbar
{
    //     对_tabbar进行初始化，并进行ui布局
    _tabbar = [UIImageView getImgWithImageStr:nil];
    _tabbar.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_tabbar];
    [_tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(IsPhone6_gt?ktabbarHeight+16:ktabbarHeight);
    }];
    
}
#pragma mark - UITabBarControllerDelegate(点击时候触发)
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    //    遍历标签栏子视图，使他们为normal状态
    for (UIButton *b in _tabbar.subviews) {
        
        if([b isKindOfClass:[UIButton class]])
        {
            ((UIButton *)b).selected=NO;
        }
    }
    //    将点击的item变为select状态
    ((DD_TabbarItem*)btnarr[self.selectedIndex]).selected=YES;
    
}
#pragma mark - SomeAction

-(void)startSignInAnimationWithTitle:(NSString *)title WithType:(NSString *)type
{
    //    @"integral"
    DD_SignInAnimationView *_animationView=[DD_SignInAnimationView sharedManagerWithTitle:title WithBlock:^(NSString *type) {
        if([type isEqualToString:@"end"])
        {
            for (id obj in self.view.window.subviews) {
                if([obj isKindOfClass:[DD_SignInAnimationView class]])
                {
                    DD_SignInAnimationView *sss=(DD_SignInAnimationView *)obj;
                    [sss removeFromSuperview];
                }
            }
        }
    }];
    if([type isEqualToString:@"integral"])
    {
        if(![DD_UserModel haveDailyIntegral])
        {
            if(!_animationView.animationStarting)
            {
                [self.view.window addSubview:_animationView];
                [_animationView startAnimation];
            }
        }
    }else
    {
        if(!_animationView.animationStarting)
        {
            [self.view.window addSubview:_animationView];
            [_animationView startAnimation];
        }
    }
}
-(void)showVersionViewWithVersonModel:(DD_VersionModel *)versionModel
{
    DD_VersionView *_versionView=[DD_VersionView sharedManagerWithModel:versionModel WithBlock:^(NSString *type) {
        if([type isEqualToString:@"update"])
        {
            JXLOG(@"update");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionModel.downLoadUrl]];
        }else if([type isEqualToString:@"close"])
        {
            
            for (id obj in self.view.window.subviews) {
                if([obj isKindOfClass:[DD_VersionView class]])
                {
                    DD_VersionView *versionView=(DD_VersionView *)obj;
                    [versionView removeFromSuperview];
                }
            }
        }
    }];
    [self.view.window addSubview:_versionView];
}
/**
 * 网络请求
 * 更新当前tabbar 用户item的状态
 */
-(void)UpdateNoReadMessageState
{
    if([DD_UserModel isLogin])
    {
        [[JX_AFNetworking alloc] GET:@"/user/isHaveUnReadMessage.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                _unReadMsgModel=[DD_UnReadMsgModel getUnReadMsgModel:data];
                //更新底部tabbar状态
                [self UpdateUserBtnState];
                
            }else
            {
//                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
//            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }else
    {
        //更新底部tabbar状态为没有消息
        [self UpdateUserBtnState];
    }
}
-(void)UpdateUserBtnState
{
    if([DD_UserModel isLogin])
    {
        if(_unReadMsgModel)
        {
            [self setUserItemState:_unReadMsgModel.isHaveUnReadBottomRedPoint];
        }else
        {
            [self setUserItemState:NO];
        }
    }else
    {
        [self setUserItemState:NO];
    }
}

-(void)UpdateUnReadMsgModel:(DD_UnReadMsgModel *)unReadMsgModel
{
    _unReadMsgModel=unReadMsgModel;
    [self UpdateUserBtnState];
}

-(void)setUserItemState:(BOOL )haveUnRead
{
    if(haveUnRead)
    {
        [_userItem setImage:[UIImage imageNamed:@"User_Tabbar_Not_Normal"] forState:UIControlStateNormal];
        [_userItem setImage:[UIImage imageNamed:@"User_Tabbar_Not_Select"] forState:UIControlStateSelected];
    }else
    {
        [_userItem setImage:[UIImage imageNamed:@"User_Tabar_Normal"] forState:UIControlStateNormal];
        [_userItem setImage:[UIImage imageNamed:@"User_Tabbar_Select"] forState:UIControlStateSelected];
    }
}

-(void)cleanCache
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[[NSString alloc] initWithFormat:@"系统内存不足，是否清除应用缓存（%@M）",[regular getSize]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    }];
    [alertController addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)updateBtnStatus:(NSInteger )index
{
    for (UIButton *b in _tabbar.subviews) {
        
        if([b isKindOfClass:[UIButton class]])
        {
            ((UIButton *)b).selected=NO;
        }
    }
    self.selectedIndex=index;
    UIButton *btn=btnarr[index];
    btn.selected=YES;
}
-(void)selectItem:(UIButton *)btn
{
    //    遍历标签栏子视图，使他们为normal状态
    for (UIView *b in _tabbar.subviews) {
        if([b isKindOfClass:[UIButton class]])
        {
            ((UIButton *)b).selected=NO;
        }
    }
    //    将点击的item变为select状态
    btn.selected = YES;
    //    切换到点击item相对应的视图
    self.selectedIndex = btn.tag - 100;
}
-(void)tabbarAppear
{
    _tabbar.hidden=NO;
}
-(void)tabbarHide
{
    _tabbar.hidden=YES;
}
#pragma mark - Others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
