//
//  DD_CustomViewController.m
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CustomViewController.h"

#import "DD_UserViewController.h"
#import "DD_CircleViewController.h"
#import "DD_DesignerMainViewController.h"
#import "DD_GoodsViewController.h"
#import "DD_DDAYViewController.h"

#import "DD_TabbarItem.h"

@interface DD_CustomViewController ()<UITabBarControllerDelegate>
{
    //    自定义的标签栏
    UIImageView *_tabbar;
    NSMutableArray *btnarr;
}

@end

@implementation DD_CustomViewController
{
    DD_UserViewController *_userCtn;
    DD_GoodsViewController *_goodsCtn;
    DD_DesignerMainViewController *_designerCtn;
    DD_DDAYViewController *_ddayCtn;
    DD_CircleViewController *_circleCtn;
}
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
                            @"System_Item_Normal"
                            ,@"System_Designer_Normal"
                            ,@"System_DDAY_Normal"
                            ,@"System_Circle_Normal"
                            ,@"System_User_Normal"];
    NSArray *selectImgArr=@[
                            @"System_Item_Select"
                            ,@"System_Designer_Select"
                            ,@"System_DDAY_Select"
                            ,@"System_Circle_Select"
                            ,@"System_User_Select"];
    
    CGFloat buttonWidth =ScreenWidth/5;
    for (int i = 0; i<titleArr.count; i++) {
        DD_TabbarItem *item = [DD_TabbarItem buttonWithType:UIButtonTypeCustom];
        //        设置item的frame，标题，normal和select的图片
        item.type=i;
        [item setTitle:titleArr[i] forState:UIControlStateNormal];
        
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
        make.height.mas_equalTo(ktabbarHeight);
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
-(void)updateBtnStatus:(NSInteger )index
{
    for (UIButton *b in _tabbar.subviews) {
        
        if([b isKindOfClass:[UIButton class]])
        {
            ((UIButton *)b).selected=NO;
        }
    }
    self.selectedIndex=index;
    UIButton *btn=[btnarr objectAtIndex:index];
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
