//
//  DD_GoodsDetailViewController.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#define yellow_color [UIColor colorWithRed:248.0f/255.0f green:210.0f/255.0f blue:82.0f/255.0f alpha:1]
#import "DD_ShopViewController.h"
#import "DD_ClearingViewController.h"
#import "DD_DesignerHomePageViewController.h"
#import "DD_ColorsModel.h"
#import "DD_ClearingModel.h"
#import "DD_GoodInformView.h"
#import "ImageViewController.h"
#import "DD_GoodsDetailModel.h"
#import "DD_GoodsDetailViewController.h"
#import "DD_GoodsDesignerView.h"
#import "DD_ChooseSizeView.h"
@interface DD_GoodsDetailViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@end

@implementation DD_GoodsDetailViewController
{
    UIImageView *mengban;
    DD_GoodsDesignerView *_DesignerView;
    DD_GoodInformView *_InformView;
    UIScrollView *_scrollview;
    DD_GoodsDetailModel *_DetailModel;
    UIPageViewController *_pageViewControler;
    UIPageControl *_pageControl;
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
#pragma mark - UIConfig
-(void)UIConfig
{
    [self createImgScreenView];
    [self CreateInformView];
}
-(void)CreateDesignerView
{
    _DesignerView=[[DD_GoodsDesignerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_InformView.frame)+10, ScreenWidth, 250) WithGoodsDetailModel:_DetailModel WithBlock:^(NSString *type,NSInteger index) {
        
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
    _scrollview.contentSize=CGSizeMake(ScreenWidth, CGRectGetMaxY(_DesignerView.frame));
    _DesignerView.backgroundColor=_define_backview_color;
    [_scrollview addSubview:_DesignerView];
}
-(void)CreateInformView
{
    _InformView=[[DD_GoodInformView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageViewControler.view.frame), ScreenWidth, 1000) WithGoodsDetailModel:_DetailModel WithBlock:^( NSString *type,CGFloat height) {
        if([type isEqualToString:@"color_select"])
        {
//            颜色（款式）选择之后的回调
            [self createImgScreenView];
        }else if([type isEqualToString:@"shop"])
        {
//            加入购物车
            [self Shop_Buy_Action:@"shop"];
        }else if([type isEqualToString:@"collect"])
        {
//            收藏
            [self Colloct_Action];
        }
        else if([type isEqualToString:@"buy"])
        {
//            购买
            [self Shop_Buy_Action:@"buy"];
        }else if([type isEqualToString:@"height"])
        {
//            重置视图高度
            _InformView.frame=CGRectMake(CGRectGetMinX(_InformView.frame), CGRectGetMinY(_InformView.frame), CGRectGetWidth(_InformView.frame), height);
            [self CreateDesignerView];
        }
    }];
    _InformView.backgroundColor=_define_backview_color;
    [_scrollview addSubview:_InformView];
}
-(void)createImgScreenView
{
    DD_ColorsModel *_colorModel=[self getColorsModel];
    if(_colorModel.pics.count)
    {
        [_pageViewControler.view removeFromSuperview];
        //    创建pageViewControler（活动图片浏览视图）
        _pageViewControler = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        ImageViewController *imgvc = [[ImageViewController alloc]initWithHeight:350 WithBlock:^(NSString *type, NSInteger index) {
            
        }];
        imgvc.array=_colorModel.pics;
        imgvc.view.backgroundColor = [UIColor clearColor];
        imgvc.currentPage = 0;
        [_pageViewControler setViewControllers:@[imgvc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        _pageViewControler.delegate = self;
        _pageViewControler.dataSource = self;
        _pageViewControler.view.frame = CGRectMake(0, 0, ScreenWidth, 350);
        [_scrollview addSubview:_pageViewControler.view];
        
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.center = CGPointMake(ScreenWidth/2.0f, 350-10);
        [_scrollview addSubview:_pageControl];
        _pageControl.numberOfPages = _colorModel.pics.count;
        _pageControl.currentPageIndicatorTintColor = yellow_color;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
   
    }
}
-(void)CreateScrollView
{
    _scrollview =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+ktabbarHeight)];
    _scrollview.contentSize=CGSizeMake(ScreenWidth, ScreenHeight);
    [self.view addSubview:_scrollview];
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
    
}
-(void)PrepareData{}
-(void)PrepareUI
{

    UIButton *buyBtn=[regular getBarCustomBtnWithImg:@"System_Buy" WithSelectImg:@"System_Buy" WithSize:CGSizeMake(24, 25)];
    
    [buyBtn addTarget:self action:@selector(PushShopView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:buyBtn];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}
#pragma  mark-pageViewController代理方法
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    DD_ColorsModel *_colorModel=[self getColorsModel];
    
    ImageViewController *vc = (ImageViewController*)viewController;
    NSInteger index = vc.currentPage;
    index ++ ;
    
    ImageViewController *imgvc = [[ImageViewController alloc]initWithHeight:350 WithBlock:^(NSString *type, NSInteger index) {
        
    }];
    imgvc.array=_colorModel.pics;
    imgvc.view.backgroundColor = [UIColor clearColor];
    imgvc.maxPage = _colorModel.pics.count-1;
    imgvc.currentPage = index;
    return imgvc;
    
    
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    DD_ColorsModel *_colorModel=[self getColorsModel];
    ImageViewController *vc = (ImageViewController*)viewController;
    NSInteger index = vc.currentPage;
    index -- ;
    
    ImageViewController *imgvc = [[ImageViewController alloc]initWithHeight:350 WithBlock:^(NSString *type, NSInteger index) {
        
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
    _pageControl.currentPage = vc.currentPage;
    return;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    
    DD_ColorsModel *_colorModel=[self getColorsModel];
    return _colorModel.pics.count;
}

#pragma mark - SomeAction
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [_InformView cancelTime];
}

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
-(NSString *)getPriceStr
{
    long _nowTime=[regular date];
    if(_nowTime>=_DetailModel.item.saleEndTime)
    {
        //        已经结束
        if(_DetailModel.item.discountEnable)
        {
            return _DetailModel.item.price;
        }else
        {
            return  _DetailModel.item.originalPrice;
        }
        
    }else
    {
        //        发布中
        return _DetailModel.item.price;
    }
}
-(NSString *)getColorNameWithID:(NSString *)colorID
{
    for (DD_ColorsModel *color in _DetailModel.item.colors) {
        if([color.colorId isEqualToString:colorID])
        {
            if(color.colorName)
            {
                return color.colorName;
                
            }else
            {
                return @"";
            }
            break;
        }
    }
    return @"";
}
-(void)ShopAction:(NSString *)sizeid
{
    NSArray *_itemArr=@[@{
                            @"itemId":_DetailModel.item.itemId
                            ,@"itemName":_DetailModel.item.itemName
                            ,@"colorId":_DetailModel.item.colorId
                            ,@"colorName":[self getColorNameWithID:_DetailModel.item.colorId]
                            ,@"sizeId":sizeid
                            ,@"sizeName":[_DetailModel.item getSizeNameWithID:sizeid]
                            
                            ,@"discountEnable":[NSNumber numberWithBool:_DetailModel.item.discountEnable]
                            ,@"seriesId":_DetailModel.item.series.s_id
                            ,@"seriesName":_DetailModel.item.series.name
                            ,@"designerId":_DetailModel.designer.designerId
                            ,@"brandName":_DetailModel.designer.brandName
                            
                            ,@"number":@"1"
                            ,@"price":[self getPriceStr]
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
-(void)BuyAction:(NSString *)sizeid
{
//    NSArray *_itemArr=@[@{@"itemId":@"3",@"colorId":@"39",@"sizeId":@"24",@"number":@"6",@"price":@"2000"}
//                        ,@{@"itemId":@"6",@"colorId":@"34",@"sizeId":@"20",@"number":@"1",@"price":@"5000"}
//                        ,@{@"itemId":@"9",@"colorId":@"35",@"sizeId":@"20",@"number":@"2",@"price":@"1000"}
//                        ,@{@"itemId":@"11",@"colorId":@"41",@"sizeId":@"20",@"number":@"4",@"price":@"1000"}
//                        ,@{@"itemId":@"4",@"colorId":@"38",@"sizeId":@"20",@"number":@"3",@"price":@"2100"}
//                        ];
    NSArray *_itemArr=@[@{@"itemId":_DetailModel.item.itemId,@"colorId":_DetailModel.item.colorId,@"sizeId":sizeid,@"number":@"1",@"price":[self getPriceStr]}];
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
-(void)mengban_dismiss
{
    [mengban removeFromSuperview];
}
//shop buy
-(void)Shop_Buy_Action:(NSString *)type
{
    mengban=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:mengban];
    mengban.userInteractionEnabled=YES;
    mengban.image=[UIImage imageNamed:@"蒙板"];
    [mengban addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mengban_dismiss)]];
    DD_ColorsModel *_colorModel=[self getColorsModel];
    [mengban addSubview:[[DD_ChooseSizeView alloc] initWithFrame:CGRectMake((ScreenWidth-300)/2.0f, (ScreenHeight-400)/2.0f, 300, 400) WithSizeArr:_colorModel.size WithColorID:_colorModel.colorId WithType:type WithBlock:^(NSString *type,NSString *sizeid,NSString *colorid) {
        if([type isEqualToString:@"shop"]||[type isEqualToString:@"buy"])
        {
            if([sizeid isEqualToString:@""])
            {
                [self presentViewController:[regular alertTitle_Simple:@"请先选择尺寸"] animated:YES completion:nil];
            }else
            {
                [self mengban_dismiss];
                if([type isEqualToString:@"shop"])
                {
                    //                加入购物车
                    [self ShopAction:sizeid];
                }else if([type isEqualToString:@"buy"])
                {
                    //                购买
                    [self BuyAction:sizeid];
                }
            }
        }
        
    }]];
}
-(DD_ColorsModel *)getColorsModel
{
    NSString *_colorId=_DetailModel.item.colorId;
    for (DD_ColorsModel *_color in _DetailModel.item.colors) {
        if([_color.colorId isEqualToString:_colorId])
        {
            return _color;
        }
    }
    return nil;
}
-(void)PushItemView:(NSInteger )index
{
    DD_GoodsDetailViewController *_GoodsDetailView=[[DD_GoodsDetailViewController alloc] init];
    DD_OtherItemModel *_OtherItem=[_DetailModel.item.otherItems objectAtIndex:index];
    DD_ItemsModel *_ItemsModel=[[DD_ItemsModel alloc] init];
    _ItemsModel.colorId=_OtherItem.colorId;
    _ItemsModel.g_id=_OtherItem.itemId;
    
    _GoodsDetailView.title=_OtherItem.itemName;
    _GoodsDetailView.model=_ItemsModel;
    
    [self.navigationController pushViewController:_GoodsDetailView animated:YES];
}
-(void)PushDesignerView
{
    DD_DesignerHomePageViewController *_designer=[[DD_DesignerHomePageViewController alloc] init];
    _designer.title=_DetailModel.designer.designerName;
    _designer.designerId=_DetailModel.designer.designerId;
    [self.navigationController pushViewController:_designer animated:YES];
}
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
//跳转购物车
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
