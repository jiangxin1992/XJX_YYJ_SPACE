//
//  DD_GoodsDetailViewController.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_GoodsDetailViewController.h"

#import "DD_ShopViewController.h"
#import "DD_ClearingViewController.h"
#import "DD_DesignerHomePageViewController.h"
#import "ImageViewController.h"

#import "DD_ColorsModel.h"
#import "DD_ClearingModel.h"
#import "DD_GoodsDetailModel.h"

#import "DD_GoodsInformView.h"
#import "DD_GoodsDesignerView.h"
#import "DD_GoodsCircleView.h"
#import "DD_GoodsFabricView.h"
#import "DD_GoodsSendAndReturnsView.h"
#import "DD_GoodsK_POINTView.h"
#import "DD_GoodsTabBar.h"
#import "DD_ShopBtn.h"

#import "DD_ChooseSizeView.h"
#import "DD_DrawManageView.h"

@interface DD_GoodsDetailViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

__bool(isExpanded);

@end

@implementation DD_GoodsDetailViewController
{
    DD_GoodsDetailModel *_DetailModel;//单品model
    
    UIScrollView *_scrollview;
    UIImageView *mengban;//蒙板
    DD_ChooseSizeView *sizeView;
    
    DD_GoodsInformView *_InformView;//信息视图
    DD_GoodsDesignerView *_DesignerView;//设计师系列视图
    DD_GoodsCircleView *_CircleView;//搭配师说
    DD_GoodsFabricView *_FabricView;//面料与洗涤
    DD_GoodsSendAndReturnsView *_ReturnView;//寄送与退换
    DD_GoodsK_POINTView *_K_PonitView;//YCO SPACE 体验店
    
    UIPageViewController *_pageViewControler;//单品图片浏览
    DD_DrawManageView *ManageView;//自定义pageControler
    
    UIView *container;//_scrollView的view

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self CreateScrollView];
    [self RequestData];
}
#pragma mark - 初始化
-(instancetype)initWithModel:(DD_ItemsModel *)model WithBlock:(void (^)(DD_ItemsModel *model,NSString *type))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _model=model;
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData
{
    _isExpanded=YES;
}
-(void)PrepareUI
{
    
    DD_ShopBtn *buyBtn=[DD_ShopBtn getShopBtn];
    [buyBtn addTarget:self action:@selector(PushShopView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:buyBtn];
    
    UIButton *backBtn=[UIButton getBackBtn];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.navigationItem.titleView=[regular returnNavView:@"单品" withmaxwidth:110];
}
#pragma mark - UIConfig
-(void)CreateScrollView
{
    _scrollview=[[UIScrollView alloc] init];
    [self.view addSubview:_scrollview];
    container = [UIView new];
    [_scrollview addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollview);
        make.width.equalTo(_scrollview);
//        make.bottom.mas_equalTo();
    }];
}
-(void)UIConfig
{
    [self CreateImgScreenView];
    [self CreateInformView];
    [self CreateDesignerView];
    [self CreateCircleView];
    [self CreateFabricView];
    [self CreateSendAndReturnsView];
    [self CreateKPOINTView];
    [self CreateTabbar];
}
-(void)CreateImgScreenView
{
    DD_ColorsModel *_colorModel=[_DetailModel getColorsModel];
    [_pageViewControler.view removeFromSuperview];
    [ManageView removeFromSuperview];
    
    if(_colorModel.pics.count)
    {
        //    创建pageViewControler（活动图片浏览视图）
        _pageViewControler = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        [container addSubview:_pageViewControler.view];
        ImageViewController *imgvc = [[ImageViewController alloc] initWithSize:CGSizeMake(ScreenWidth-(IsPhone6_gt?60:49)-26*2, IsPhone6_gt?363:301) WithBlock:^(NSString *type, NSInteger index) {
        }];
        imgvc.array=_colorModel.pics;
        imgvc.view.backgroundColor = [UIColor clearColor];
        [regular setBorder:_pageViewControler.view];
        imgvc.currentPage = 0;
        [_pageViewControler setViewControllers:@[imgvc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        _pageViewControler.delegate = self;
        _pageViewControler.dataSource = self;
        
        
        
        ManageView=[[DD_DrawManageView alloc] initWithImgCount:_colorModel.pics.count];
        [container addSubview:ManageView];
        ManageView.userInteractionEnabled=NO;
        ManageView.backgroundColor=_define_light_gray_color;
        
        [_pageViewControler.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(26);
            make.right.mas_equalTo(-26);
            make.top.mas_equalTo(12);
            make.height.mas_equalTo(IsPhone6_gt?363:301);
        }];
        [ManageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_pageViewControler.view.mas_right).with.offset(-1);
            make.bottom.mas_equalTo(_pageViewControler.view).with.offset(-1);
            make.top.mas_equalTo(_pageViewControler.view).with.offset(1);
            make.width.mas_equalTo(IsPhone6_gt?60:49);
        }];
        
    }else
    {
        _pageViewControler = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        [container addSubview:_pageViewControler.view];
        [_pageViewControler.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.top.mas_equalTo(12);
            make.height.mas_equalTo(IsPhone6_gt?363:301);
        }];
    }
}
-(void)CreateInformView
{
    _InformView=[[DD_GoodsInformView alloc] initWithGoodsDetailModel:_DetailModel WithBlock:^( NSString *type) {
        if([type isEqualToString:@"color_select"])
        {
//            颜色（款式）选择之后的回调
            [self CreateImgScreenView];
        }else if([type isEqualToString:@"collect"])
        {
            //            收藏
            [self Colloct_Action];
        }
    }];
    [container addSubview:_InformView];
    [_InformView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(container).with.offset((IsPhone6_gt?363:301)+12);
        make.left.and.right.mas_equalTo(0);
    }];

}
-(void)CreateDesignerView
{
    _DesignerView=[[DD_GoodsDesignerView alloc] initWithGoodsDetailModel:_DetailModel WithBlock:^(NSString *type,NSInteger index) {
        
        if([type isEqualToString:@"follow"]||[type isEqualToString:@"unfollow"])
        {
            [self followAction:type];
            
        }else if([type isEqualToString:@"designer"])
        {
            [self PushDesignerView];
        }else if([type isEqualToString:@"item"])
        {
            [self PushItemView:index];
        }else if([type isEqualToString:@"servies"])
        {
            //            跳转系列详情
        }
    }];
    [container addSubview:_DesignerView];
    [_DesignerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_InformView.mas_bottom).with.offset(0);
        make.left.and.right.mas_equalTo(0);
    }];
    
}
-(void)CreateCircleView
{
    _CircleView=[[DD_GoodsCircleView alloc] initWithBlock:^(NSString *type) {
        if([type isEqualToString:@"click"])
        {
            [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"pay_attention", @"")] animated:YES completion:nil];
        }
    }];
    [container addSubview:_CircleView];
    [_CircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_DesignerView.mas_bottom).with.offset(0);
        make.left.and.right.mas_equalTo(0);
    }];
}
-(void)CreateFabricView
{
    _FabricView=[[DD_GoodsFabricView alloc] initWithBlock:^(NSString *type) {
        if([type isEqualToString:@"click"])
        {
            [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"pay_attention", @"")] animated:YES completion:nil];
        }
    }];
    [container addSubview:_FabricView];
    [_FabricView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_CircleView.mas_bottom).with.offset(0);
        make.left.and.right.mas_equalTo(0);
    }];
}
-(void)CreateSendAndReturnsView
{
    _ReturnView=[[DD_GoodsSendAndReturnsView alloc] initWithBlock:^(NSString *type) {
        if([type isEqualToString:@"click"])
        {
            [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"pay_attention", @"")] animated:YES completion:nil];
        }
    }];
    [container addSubview:_ReturnView];
    [_ReturnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_FabricView.mas_bottom).with.offset(0);
        make.left.and.right.mas_equalTo(0);
    }];
}
-(void)CreateKPOINTView
{
    _K_PonitView=[[DD_GoodsK_POINTView alloc] initWithBlock:^(NSString *type) {
        if([type isEqualToString:@"click"])
        {
            [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"pay_attention", @"")] animated:YES completion:nil];
        }
    }];
    [container addSubview:_K_PonitView];
    [_K_PonitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_ReturnView.mas_bottom).with.offset(0);
        make.left.and.right.mas_equalTo(0);
    }];
    [_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-88+ktabbarHeight);
        // 让scrollview的contentSize随着内容的增多而变化
        make.bottom.mas_equalTo(_K_PonitView.mas_bottom).with.offset(0);
    }];
}
-(void)CreateTabbar
{
    DD_GoodsTabBar *tabbar=[[DD_GoodsTabBar alloc] initWithBlock:^(NSString *type) {
        if([type isEqualToString:@"buy"])
        {
            [self Shop_Buy_Action:@"buy"];
        }
    }];
    [self.view addSubview:tabbar];
    [tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
}
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"item/queryItemDetail.do" parameters:@{@"token":[DD_UserModel getToken],@"itemId":_model.g_id,@"colorId":_model.colorId} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _DetailModel=[DD_GoodsDetailModel getGoodsDetailModel:data];
            [self UIConfig];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}

#pragma  mark-pageViewController代理方法
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    DD_ColorsModel *_colorModel=[_DetailModel getColorsModel];
    
    ImageViewController *vc = (ImageViewController*)viewController;
    NSInteger index = vc.currentPage;
    index ++ ;
    
    ImageViewController *imgvc = [[ImageViewController alloc] initWithSize:CGSizeMake(ScreenWidth-(IsPhone6_gt?60:49)-30*2, IsPhone6_gt?363:301) WithBlock:^(NSString *type, NSInteger index) {
    }];
    imgvc.array=_colorModel.pics;
    imgvc.view.backgroundColor = [UIColor clearColor];
    imgvc.maxPage = _colorModel.pics.count-1;
    imgvc.currentPage = index;
    return imgvc;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    DD_ColorsModel *_colorModel=[_DetailModel getColorsModel];
    ImageViewController *vc = (ImageViewController*)viewController;
    NSInteger index = vc.currentPage;
    index -- ;
    
    ImageViewController *imgvc = [[ImageViewController alloc] initWithSize:CGSizeMake(ScreenWidth-(IsPhone6_gt?60:49)-30*2, IsPhone6_gt?363:301) WithBlock:^(NSString *type, NSInteger index) {
    }];
    imgvc.array=_colorModel.pics;
    imgvc.view.backgroundColor = [UIColor clearColor];
    imgvc.maxPage =_colorModel.pics.count-1;
    imgvc.currentPage = index;
    return imgvc;
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    ImageViewController *vc =  pageViewController.viewControllers[0];
    [ManageView changeSelectNum:vc.currentPage];
    return;
}


#pragma mark - SomeAction
//返回
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//蒙板消失
-(void)mengban_dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        sizeView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, IsPhone6_gt?230:187);
    } completion:^(BOOL finished) {
        [mengban removeFromSuperview];
    }];

}
//收藏
-(void)Colloct_Action
{
    NSString *_url=nil;
    if(_DetailModel.item.isCollect)
    {
//        取消收藏
        _url=@"item/delCollectItem.do";
    }else
    {
//        收藏
        _url=@"item/collectItem.do";
    }
    NSDictionary *_parameters=@{@"itemId":_DetailModel.item.itemId,@"colorId":_DetailModel.item.colorId,@"token":[DD_UserModel getToken]};
    [[JX_AFNetworking alloc] GET:_url parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            if([_DetailModel.item.colorId isEqualToString:[data objectForKey:@"colorId"]])
            {
                _DetailModel.item.isCollect=!_DetailModel.item.isCollect;
                [_InformView setState];
            }
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
    
}
//关注
-(void)followAction:(NSString *)type
{
    NSString *url=nil;
    if([type isEqualToString:@"follow"])
    {
        url=@"designer/careDesigner.do";
    }else if([type isEqualToString:@"unfollow"])
    {
        url=@"designer/unCareDesigner.do";
    }
    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"designerId":_DetailModel.designer.designerId};
    [[JX_AFNetworking alloc] GET:url parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _DetailModel.guanzhu=[[data objectForKey:@"guanzhu"] boolValue];
            _DesignerView.detailModel=_DetailModel;
            [_DesignerView UpdateFollowBtnState];
            
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}

//shop buy
-(void)Shop_Buy_Action:(NSString *)type
{
    mengban=[UIImageView getMaskImageView];
    [self.view.window addSubview:mengban];
    [mengban addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mengban_dismiss)]];
    
    DD_ColorsModel *_colorModel=[_DetailModel getColorsModel];
    sizeView=[[DD_ChooseSizeView alloc] initWithSizeArr:_colorModel.size WithColorID:_colorModel.colorId WithBlock:^(NSString *type,NSString *sizeid,NSString *colorid,NSInteger count) {
        if([type isEqualToString:@"shop"]||[type isEqualToString:@"buy"])
        {
            if([sizeid isEqualToString:@""])
            {
                [self presentViewController:[regular alertTitle_Simple:@"请先选择尺寸"] animated:YES completion:nil];
            }else
            {
                if(count)
                {
                    [self mengban_dismiss];
                    if([type isEqualToString:@"shop"])
                    {
                        //                加入购物车
                        [self ShopAction:sizeid WithNum:count];
                    }else if([type isEqualToString:@"buy"])
                    {
                        //                购买
                        [self BuyAction:sizeid WithNum:count];
                    }
                }
            }
        }else if([type isEqualToString:@"stock_warning"])
        {
            [self presentViewController:[regular alertTitle_Simple:@"库存不足"] animated:YES completion:nil];
        }
        
    }];
    [mengban addSubview:sizeView];
    
    sizeView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, IsPhone6_gt?230:187);
    [UIView animateWithDuration:0.5 animations:^{
        sizeView.frame=CGRectMake(0, ScreenHeight-(IsPhone6_gt?230:187), ScreenWidth, IsPhone6_gt?230:187);
    }];
}
//购买动作
-(void)BuyAction:(NSString *)sizeid WithNum:(NSInteger )count
{
//    NSArray *_itemArr=@[@{@"itemId":@"3",@"colorId":@"39",@"sizeId":@"24",@"number":@"6",@"price":@"2000"}
//                        ,@{@"itemId":@"6",@"colorId":@"34",@"sizeId":@"20",@"number":@"1",@"price":@"5000"}
//                        ,@{@"itemId":@"9",@"colorId":@"35",@"sizeId":@"20",@"number":@"2",@"price":@"1000"}
//                        ,@{@"itemId":@"11",@"colorId":@"41",@"sizeId":@"20",@"number":@"4",@"price":@"1000"}
//                        ,@{@"itemId":@"4",@"colorId":@"38",@"sizeId":@"20",@"number":@"3",@"price":@"2100"}
//                        ];
    NSArray *_itemArr=@[@{@"itemId":_DetailModel.item.itemId,@"colorId":_DetailModel.item.colorId,@"sizeId":sizeid,@"number":[[NSString alloc] initWithFormat:@"%ld",count],@"price":[_DetailModel getPrice]}];
    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"buyItems":[_itemArr JSONString]};
    [[JX_AFNetworking alloc] GET:@"item/buyCheck.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            DD_ClearingModel *_ClearingModel=[DD_ClearingModel getClearingModel:data];
            [self.navigationController pushViewController:[[DD_ClearingViewController alloc] initWithModel:_ClearingModel WithBlock:^(NSString *type) {
                
            }] animated:YES];
            
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
//加入购物车动作
-(void)ShopAction:(NSString *)sizeid WithNum:(NSInteger )count
{
    NSArray *_itemArr=@[@{
                            @"itemId":_DetailModel.item.itemId
                            ,@"itemName":_DetailModel.item.itemName
                            ,@"colorId":_DetailModel.item.colorId
                            ,@"colorName":[_DetailModel getColorNameWithID:_DetailModel.item.colorId]
                            ,@"colorCode":[_DetailModel getColorNameWithCode:_DetailModel.item.colorId]
                            ,@"sizeId":sizeid
                            ,@"sizeName":[_DetailModel.item getSizeNameWithID:sizeid]
                            ,@"categoryName":_DetailModel.item.categoryName
                            
                            ,@"discountEnable":[NSNumber numberWithBool:_DetailModel.item.discountEnable]
                            ,@"seriesId":_DetailModel.item.series.s_id
                            ,@"seriesName":_DetailModel.item.series.name
                            ,@"designerId":_DetailModel.designer.designerId
                            ,@"brandName":_DetailModel.designer.brandName
                            
                            ,@"number":[[NSString alloc] initWithFormat:@"%ld",count]
                            ,@"price":[_DetailModel getPrice]
                            ,@"originalPrice":_DetailModel.item.originalPrice
                            ,@"pics":[_DetailModel.item getPicsArr]
                            
                            ,@"saleEndTime":[NSNumber numberWithLong:_DetailModel.item.saleEndTime*1000]
                            ,@"saleStartTime":[NSNumber numberWithLong:_DetailModel.item.saleStartTime*1000]
                            ,@"signEndTime":[NSNumber numberWithLong:_DetailModel.item.signEndTime*1000]
                            ,@"signStartTime":[NSNumber numberWithLong:_DetailModel.item.signStartTime*1000]
                            }
                        ];
    
    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"items":[_itemArr JSONString]};
    [[JX_AFNetworking alloc] GET:@"item/putToShoppingCart.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"shop_success", @"")] animated:YES completion:nil];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
    
}

//跳转单品详情页
-(void)PushItemView:(NSInteger )index
{
    DD_GoodsDetailViewController *_GoodsDetailView=[[DD_GoodsDetailViewController alloc] init];
    DD_OtherItemModel *_OtherItem=[_DetailModel.item.otherItems objectAtIndex:index];
    DD_ItemsModel *_ItemsModel=[[DD_ItemsModel alloc] init];
    _ItemsModel.colorId=_OtherItem.colorId;
    _ItemsModel.g_id=_OtherItem.itemId;
    _GoodsDetailView.model=_ItemsModel;
    
    [self.navigationController pushViewController:_GoodsDetailView animated:YES];
}
//跳转设计师页面
-(void)PushDesignerView
{
    DD_DesignerHomePageViewController *_designer=[[DD_DesignerHomePageViewController alloc] init];
    _designer.title=_DetailModel.designer.designerName;
    _designer.designerId=_DetailModel.designer.designerId;
    [self.navigationController pushViewController:_designer animated:YES];
}
//跳转购物车视图
-(void)PushShopView
{
    DD_ShopViewController *_shop=[[DD_ShopViewController alloc] init];
    [self.navigationController pushViewController:_shop animated:YES];
}

#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[DD_CustomViewController sharedManager] tabbarHide];
    [MobClick beginLogPageView:@"DD_GoodsDetailViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_GoodsDetailViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
