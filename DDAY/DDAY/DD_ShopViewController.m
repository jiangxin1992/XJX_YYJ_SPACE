//
//  DD_ShopViewController.m
//  DDAY
//
//  Created by yyj on 16/5/25.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShopViewController.h"

#import "MJRefresh.h"

#import "DD_GoodsDetailViewController.h"
#import "DD_LoginViewController.h"
#import "DD_ClearingDoneViewController.h"
#import "DD_ClearingViewController.h"

#import "DD_ShopClearingView.h"
#import "DD_ShopAlertNumView.h"
#import "DD_ShopAlertSizeView.h"
#import "DD_ShopCell.h"
//#import "DD_ShopHeaderView.h"
//#import "DD_ShopEditingCell.h"

#import "DD_ShopTool.h"
#import "DD_ItemsModel.h"
#import "DD_ShopModel.h"
#import "DD_SizeModel.h"
#import "DD_SizeAlertModel.h"
#import "DD_ShopSeriesModel.h"
#import "DD_ShopItemModel.h"
#import "DD_ClearingModel.h"

@interface DD_ShopViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_ShopViewController
{
    UITableView *_tableview;//tableview
    DD_ShopClearingView *_tabbar;//自定义tabbar
    
    MJRefreshGifHeader *_mj_header;//刷新头
    
    DD_ShopModel *_shopModel;//购物车model
//    BOOL _isEditing;//cell样式切换，是否是编辑状态
    
    UIImageView *mengban_num;//蒙版
    UIImageView *mengban_size;//蒙版
    DD_ShopAlertNumView *_alertNumView;
    DD_ShopAlertSizeView *_alertSizeView;

    
    CGFloat _mengban_size_Height;
    CGFloat _mengban_num_Height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self hideBackNavBtn];
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData
{
//    _isEditing=NO;//初始化状态为非编辑状态
}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"shop_title", @"") withmaxwidth:200];//设置标题
    DD_NavBtn *backBtn=[DD_NavBtn getBackBtn];
//    [backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBtn bk_addEventHandler:^(id sender) {
//        返回
        [self.navigationController popViewControllerAnimated:YES];
        [self cancelAllTimer];
    } forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTableView];
    [self MJRefresh];
    [self CreateTabbar];
}
#pragma mark - MJRefresh
-(void)MJRefresh
{
    //    MJRefreshNormalHeader *header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    NSArray *refreshingImages=[regular getGifImg];
    
    //     Set the ordinary state of animated images
    [_mj_header setImages:refreshingImages duration:1.5 forState:MJRefreshStateIdle];
    //     Set the pulling state of animated images（Enter the status of refreshing as soon as loosen）
    [_mj_header setImages:refreshingImages duration:1.5 forState:MJRefreshStatePulling];
    //     Set the refreshing state of animated images
    [_mj_header setImages:refreshingImages duration:1.5 forState:MJRefreshStateRefreshing];
    
    _mj_header.lastUpdatedTimeLabel.hidden = YES;
    _mj_header.stateLabel.hidden = YES;
    _tableview.mj_header = _mj_header;
    [_tableview.mj_header beginRefreshing];
    
}
-(void)loadNewData
{
    // 进入刷新状态后会自动调用这个block
    [self RequestData];
}
/**
 * 创建自定义tabbar
 */
-(void)CreateTabbar
{
    _tabbar=[[DD_ShopClearingView alloc] initWithShopModel:_shopModel WithBlock:^(NSString *type) {
        if([type isEqualToString:@"cancel_all"])
        {
//            取消全选
            [DD_ShopTool selectAllWithModel:_shopModel WithSelect:NO];
            [self updateTabbarState];
        }else if([type isEqualToString:@"select_all"])
        {
//            全选
            [DD_ShopTool selectAllWithModel:_shopModel WithSelect:YES];
            [self updateTabbarState];
        }else if([type isEqualToString:@"confirm"])
        {
//            结算
            [self ConfirmAction];
        }
    }];
    [self.view addSubview:_tabbar];
    [_tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view).with.offset(-kSafetyZoneHeight);
        make.height.mas_equalTo(kInteractionHeight);
    }];
    
}
/**
 * tableview创建
 */
-(void)CreateTableView
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:_tableview];
    //    消除分割线
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.1)];
    _tableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.1)];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-kTabbarHeight);
    }];
}
/**
 * 创建Size选择视图
 */
-(void)CreateSizeChooseViewWithSizeAlertModel:(DD_SizeAlertModel *)sizeAlertModel WithIndexPath:(NSIndexPath *)indexPath
{
    if(!mengban_num&&!mengban_size)
    {
        [self MJ_Hide];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        mengban_size=[UIImageView getMaskImageView];
        [self.view addSubview:mengban_size];
        [mengban_size bk_whenTapped:^{
            [self mengban_size_dismiss];
        }];
        DD_ShopItemModel *itemModel=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
        _alertSizeView=[[DD_ShopAlertSizeView alloc] initWithSizeAlertModel:sizeAlertModel WithItem:itemModel WithBlock:^(NSString *type,NSString *sizeId,NSString *sizeName,NSInteger count) {
            if([type isEqualToString:@"alert"])
            {
                if([sizeId isEqualToString:@""])
                {
                    [self presentViewController:[regular alertTitle_Simple:@"请先选择尺寸"] animated:YES completion:nil];
                }else
                {
                    if(![DD_UserModel isLogin])
                    {
                        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
                            [self pushLoginView];
                        }] animated:YES completion:nil];
                    }else
                    {
                        [self mengban_size_dismiss];
                        //                判断是否有相同item
                        //                有则删除、没有则修改
                        if([self haveSameItemWithIndexPath:indexPath WithSizeID:sizeId WithColorID:itemModel.colorId])
                        {
                            NSArray *_parameters=@[@{@"itemId":itemModel.itemId,@"colorId":itemModel.colorId,@"sizeId":sizeName,@"colorCode":itemModel.colorCode}];
                            [[JX_AFNetworking alloc] GET:@"item/delFromShoppingCart.do" parameters:@{@"token":[DD_UserModel getToken],@"items":[_parameters mj_JSONString]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                                if(success)
                                {
                                    [DD_ShopTool removeItemModelWithIndexPath:indexPath WithModel:_shopModel];
                                    [_tableview reloadData];
                                    _tabbar.shopModel=_shopModel;
                                    [_tabbar SetState];
                                }else
                                {
                                    [self presentViewController:successAlert animated:YES completion:nil];
                                    [_tableview reloadData];
                                }
                            } failure:^(NSError *error, UIAlertController *failureAlert) {
                                [self presentViewController:failureAlert animated:YES completion:nil];
                                [_tableview reloadData];
                            }];
                        }else
                        {
                            NSArray *_itemsArr=@[@{
                                                     @"itemId":itemModel.itemId
                                                     ,@"itemName":itemModel.itemName
                                                     ,@"colorId":itemModel.colorId
                                                     ,@"colorName":itemModel.colorName
                                                     ,@"colorCode":itemModel.colorCode
                                                     ,@"sizeId":sizeId
                                                     ,@"sizeName":sizeName
                                                     ,@"discountEnable":[NSNumber numberWithBool:itemModel.discountEnable]
                                                     ,@"seriesId":itemModel.seriesId
                                                     ,@"seriesName":itemModel.seriesName
                                                     ,@"designerId":itemModel.designerId
                                                     ,@"brandName":itemModel.brandName
                                                     ,@"number":[NSNumber numberWithLong:count]
                                                     ,@"price":itemModel.price
                                                     ,@"originalPrice":itemModel.originalPrice
                                                     ,@"pics":itemModel.pics
                                                     ,@"saleEndTime":[NSNumber numberWithLong:itemModel.saleEndTime*1000]
                                                     ,@"saleStartTime":[NSNumber numberWithLong:itemModel.saleStartTime*1000]
                                                     ,@"signEndTime":[NSNumber numberWithLong:itemModel.signEndTime*1000]
                                                     ,@"signStartTime":[NSNumber numberWithLong:itemModel.signStartTime*1000]
                                                     ,@"oldSizeId":itemModel.sizeId
                                                     }
                                                 ];
                            NSDictionary *_parameters=@{
                                                        @"items":[_itemsArr mj_JSONString]
                                                        ,@"token":[DD_UserModel getToken]
                                                        };
                            [[JX_AFNetworking alloc] GET:@"item/editShoppingCart.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                                if(success)
                                {
                                    itemModel.sizeId=sizeId;
                                    itemModel.sizeName=sizeName;
                                    itemModel.number=[[NSString alloc] initWithFormat:@"%ld",count];
                                    [_tableview reloadData];
                                    _tabbar.shopModel=_shopModel;
                                    [_tabbar SetState];
                                }else
                                {
                                    [self presentViewController:successAlert animated:YES completion:nil];
                                }
                            } failure:^(NSError *error, UIAlertController *failureAlert) {
                                [self presentViewController:failureAlert animated:YES completion:nil];
                            }];
                            
                        }
                    }
                    
                }
            }else if([type isEqualToString:@"stock_warning"])
            {
                [self presentViewController:[regular alertTitle_Simple:@"库存不足"] animated:YES completion:nil];
            }else if([type isEqualToString:@"no_alert"])
            {
                [self mengban_size_dismiss];
            }else if([type isEqualToString:@"no_stock"])
            {
                [self presentViewController:[regular alertTitle_Simple:@"已售罄"] animated:YES completion:nil];
            }
            
        }];
        [mengban_size addSubview:_alertSizeView];
    
        _mengban_size_Height=[DD_ShopAlertSizeView getHeightWithSizeAlertModel:sizeAlertModel WithItem:itemModel];
        
        _alertSizeView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, _mengban_size_Height);
        [UIView animateWithDuration:0.5 animations:^{
            _alertSizeView.frame=CGRectMake(0, ScreenHeight-_mengban_size_Height, ScreenWidth, _mengban_size_Height);
        }];
    }
}
/**
 * 创建数量选择视图
 */
-(void)CreateNumChooseViewWithSizeAlertModel:(DD_SizeAlertModel *)sizeAlertModel WithIndexPath:(NSIndexPath *)indexPath
{
    if(!mengban_num&&!mengban_size)
    {
        [self MJ_Hide];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        mengban_num=[UIImageView getMaskImageView];
        [self.view addSubview:mengban_num];
        [mengban_num bk_whenTapped:^{
            [self mengban_num_dismiss];
        }];
        
        DD_ShopItemModel *itemModel=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
        _alertNumView=[[DD_ShopAlertNumView alloc] initWithSizeArr:sizeAlertModel.size WithItem:itemModel WithBlock:^(NSString *type,NSInteger count) {
            if([type isEqualToString:@"alert"])
            {
                if(![DD_UserModel isLogin])
                {
                    [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"login_first", @"") WithBlock:^{
                        [self pushLoginView];
                    }] animated:YES completion:nil];
                }else
                {
                    [self mengban_num_dismiss];
                    
                    //                判断是否有相同item
                    //                有则删除、没有则修改
                    if([self haveSameItemWithIndexPath:indexPath WithSizeID:itemModel.sizeId WithColorID:itemModel.colorId])
                    {
                        NSArray *_parameters=@[@{@"itemId":itemModel.itemId,@"colorId":itemModel.colorId,@"sizeId":itemModel.sizeId,@"colorCode":itemModel.colorCode}];
                        [[JX_AFNetworking alloc] GET:@"item/delFromShoppingCart.do" parameters:@{@"token":[DD_UserModel getToken],@"items":[_parameters mj_JSONString]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                            if(success)
                            {
                                [DD_ShopTool removeItemModelWithIndexPath:indexPath WithModel:_shopModel];
                                [_tableview reloadData];
                                _tabbar.shopModel=_shopModel;
                                [_tabbar SetState];
                            }else
                            {
                                [self presentViewController:successAlert animated:YES completion:nil];
                                [_tableview reloadData];
                            }
                        } failure:^(NSError *error, UIAlertController *failureAlert) {
                            [self presentViewController:failureAlert animated:YES completion:nil];
                            [_tableview reloadData];
                        }];
                    }else
                    {
                        NSArray *_itemsArr=@[@{
                                                 @"itemId":itemModel.itemId
                                                 ,@"itemName":itemModel.itemName
                                                 ,@"colorId":itemModel.colorId
                                                 ,@"colorName":itemModel.colorName
                                                 ,@"colorCode":itemModel.colorCode
                                                 ,@"sizeId":itemModel.sizeId
                                                 ,@"sizeName":[self GetSizeNameWithID:itemModel.sizeId WithSizeArr:sizeAlertModel.size]
                                                 ,@"discountEnable":[NSNumber numberWithBool:itemModel.discountEnable]
                                                 ,@"seriesId":itemModel.seriesId
                                                 ,@"seriesName":itemModel.seriesName
                                                 ,@"designerId":itemModel.designerId
                                                 ,@"brandName":itemModel.brandName
                                                 ,@"number":[NSNumber numberWithLong:count]
                                                 ,@"price":itemModel.price
                                                 ,@"originalPrice":itemModel.originalPrice
                                                 ,@"pics":itemModel.pics
                                                 ,@"saleEndTime":[NSNumber numberWithLong:itemModel.saleEndTime*1000]
                                                 ,@"saleStartTime":[NSNumber numberWithLong:itemModel.saleStartTime*1000]
                                                 ,@"signEndTime":[NSNumber numberWithLong:itemModel.signEndTime*1000]
                                                 ,@"signStartTime":[NSNumber numberWithLong:itemModel.signStartTime*1000]
                                                 ,@"oldSizeId":itemModel.sizeId
                                                 }
                                             ];
                        NSDictionary *_parameters=@{
                                                    @"items":[_itemsArr mj_JSONString]
                                                    ,@"token":[DD_UserModel getToken]
                                                    };
                        [[JX_AFNetworking alloc] GET:@"item/editShoppingCart.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                            if(success)
                            {
                                itemModel.number=[[NSString alloc] initWithFormat:@"%ld",count];
                                [_tableview reloadData];
                                _tabbar.shopModel=_shopModel;
                                [_tabbar SetState];
                            }else
                            {
                                [self presentViewController:successAlert animated:YES completion:nil];
                            }
                        } failure:^(NSError *error, UIAlertController *failureAlert) {
                            [self presentViewController:failureAlert animated:YES completion:nil];
                        }];
                        
                    }
                }
            }else if([type isEqualToString:@"stock_warning"])
            {
                [self presentViewController:[regular alertTitle_Simple:@"库存不足"] animated:YES completion:nil];
            }
            
        }];
        [mengban_num addSubview:_alertNumView];
        _mengban_num_Height=[DD_ShopAlertNumView getHeightWithSizeArr:sizeAlertModel.size WithItem:itemModel];
        _alertNumView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, _mengban_num_Height);
        [UIView animateWithDuration:0.3 animations:^{
            _alertNumView.frame=CGRectMake(0, ScreenHeight-_mengban_num_Height, ScreenWidth, _mengban_num_Height);
        }];
    }
   
    
}
#pragma mark - RequestData
/**
 * 获取购物车数据
 */
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"item/showShoppingCart.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _shopModel=[DD_ShopModel getShopModel:data];//解析数据
            _tabbar.shopModel=_shopModel;
            [self updateTabbarState];
            [_tableview.mj_header endRefreshing];
            [_tableview.mj_footer endRefreshing];
            
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
            [_tableview.mj_header endRefreshing];
            [_tableview.mj_footer endRefreshing];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
    }];
}

#pragma mark - SomeActions

///**
// * 返回
// * 取消所有定时器
// */
//-(void)popAction
//{
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    [self cancelAllTimer];
//}
/**
 * 取消所有定时器
 */
-(void)cancelAllTimer
{
    [_shopModel.seriesNormal enumerateObjectsUsingBlock:^(DD_ShopSeriesModel *_series, NSUInteger idx, BOOL * _Nonnull stop) {
        [regular dispatch_cancel:_series.timer];
    }];
    [_shopModel.seriesInvalid enumerateObjectsUsingBlock:^(DD_ShopSeriesModel *_series, NSUInteger idx, BOOL * _Nonnull stop) {
        [regular dispatch_cancel:_series.timer];
    }];

}
/**
 * 遍历当前系列。
 * 是否有相同的item
 * 有则删除请求
 * 反之修改请求
 */
-(BOOL )haveSameItemWithIndexPath:(NSIndexPath *)indexPath WithSizeID:(NSString *)sizeid WithColorID:(NSString *)colorid
{
    __block BOOL haveSame=NO;
    DD_ShopSeriesModel *seriesModel=[DD_ShopTool getNumberSection:indexPath.section WithModel:_shopModel];
    [seriesModel.items enumerateObjectsUsingBlock:^(DD_ShopItemModel *_item, NSUInteger idx, BOOL * _Nonnull stop) {
        if([_item.sizeId isEqualToString:sizeid]&&[_item.colorId isEqualToString:colorid]&&idx!=indexPath.row)
        {
            haveSame=YES;
            *stop=YES;
        }
    }];

    return haveSame;
}
/**
 * 根据当前选择的sizeid获取sizename
 */
-(NSString *)GetSizeNameWithID:(NSString *)sizeID WithSizeArr:(NSArray *)sizeArr
{
    __block NSString *getSizeID=@"";
    [sizeArr enumerateObjectsUsingBlock:^(DD_SizeModel *sizeModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if([sizeModel.sizeId isEqualToString:sizeID])
        {
            getSizeID=sizeModel.sizeName;
        }
    }];

    return getSizeID;
}
/**
 * 选择尺寸
 */
-(void)ChooseSizeWithItem:(DD_ShopItemModel *)_ItemModel WithIndexPath:(NSIndexPath *)indexPath WithType:(NSString *)type
{
//    if(ItemModel.saleEndTime>[NSDate nowTime])
//    {
//        _priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@ 原价￥%@",ItemModel.price,ItemModel.originalPrice];
//    }else
//    {
//        if(ItemModel.discountEnable)
//        {
//            _priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@ 原价￥%@",ItemModel.price,ItemModel.originalPrice];
//            
//        }else
//        {
//            _priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@",ItemModel.originalPrice];
//        }
//        
//    }
    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"itemId":_ItemModel.itemId,@"colorCode":_ItemModel.colorCode};
    [[JX_AFNetworking alloc] GET:@"item/getItemSizeInfo.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            DD_SizeAlertModel *sizeAlertModel=[DD_SizeAlertModel getSizeAlertModel:data];
            if([type isEqualToString:@"num_alert"])
            {
                [self CreateNumChooseViewWithSizeAlertModel:sizeAlertModel WithIndexPath:indexPath];
            }else if([type isEqualToString:@"size_alert"])
            {
                [self CreateSizeChooseViewWithSizeAlertModel:sizeAlertModel WithIndexPath:indexPath];
            }
            
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
/**
 * 跳转登录界面
 */
-(void)pushLoginView
{
    if(![DD_UserModel isLogin])
    {
        [mengban_size removeFromSuperview];
        mengban_size=nil;
        [mengban_num removeFromSuperview];
        mengban_num=nil;
        
        DD_LoginViewController *_login=[[DD_LoginViewController alloc] initWithBlock:^(NSString *type) {
            if([type isEqualToString:@"success"])
            {
                
            }
        }];
        [self.navigationController pushViewController:_login animated:YES];
    }
}
/**
 * 删除蒙版
 */
-(void)mengban_size_dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        _alertSizeView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, _mengban_size_Height);
    } completion:^(BOOL finished) {
        [self MJ_Appear];
        [mengban_size removeFromSuperview];
        mengban_size=nil;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }];
}
-(void)mengban_num_dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        _alertNumView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, _mengban_num_Height);
    } completion:^(BOOL finished) {
        [self MJ_Appear];
        [mengban_num removeFromSuperview];
        mengban_num=nil;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }];
}
-(void)MJ_Hide
{
    if(_mj_header)
    {
        _mj_header.hidden=YES;
    }
}
-(void)MJ_Appear
{
    if(_mj_header)
    {
        _mj_header.hidden=NO;
    }
}
/**
 * 结算
 */
-(void)ConfirmAction
{

    NSArray *_itemArr=[DD_ShopTool getConfirmArrWithModel:_shopModel];
    if(_itemArr.count)
    {
        NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"buyItems":[_itemArr mj_JSONString]};
        [[JX_AFNetworking alloc] GET:@"item/buyCheck.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                DD_ClearingModel *_ClearingModel=[DD_ClearingModel getClearingModel:data];
                [self.navigationController pushViewController:[[DD_ClearingViewController alloc] initWithModel:_ClearingModel WithBlock:^(NSString *type, NSDictionary *resultDic) {
                    if([type isEqualToString:@"pay_back"]&&[resultDic objectForKey:@"resultStatus"]&&[resultDic objectForKey:@"tradeOrderCode"])
                    {
                        [self.navigationController pushViewController:[[DD_ClearingDoneViewController alloc] initWithReturnCode:[resultDic objectForKey:@"resultStatus"] WithTradeOrderCode:[resultDic objectForKey:@"tradeOrderCode"] WithType:@"clear" WithBlock:^(NSString *type) {
                            
                        }] animated:YES];
                        
                    }
                }] animated:YES];
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }else
    {
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"shop_no_goods", @"")] animated:YES completion:nil];
    }
}

/**
 * 更新tabbar状态
 * 刷新tableview
 */
-(void)updateTabbarState
{
    _tabbar.shopModel=_shopModel;
    [_tabbar SetState];
    [_tableview reloadData];
}
/**
 * 删除地址
 */
-(void)DeleteAddressWithIndexPath:(NSIndexPath *)indexPath
{
    DD_ShopItemModel *itemModel=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
    NSArray *_parameters=@[@{@"itemId":itemModel.itemId,@"colorId":itemModel.colorId,@"sizeId":itemModel.sizeId,@"colorCode":itemModel.colorCode}];
    [[JX_AFNetworking alloc] GET:@"item/delFromShoppingCart.do" parameters:@{@"token":[DD_UserModel getToken],@"items":[_parameters mj_JSONString]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            [DD_ShopTool removeItemModelWithIndexPath:indexPath WithModel:_shopModel];
            [_tableview reloadData];
            _tabbar.shopModel=_shopModel;
            [_tabbar SetState];
            
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
            [_tableview reloadData];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
        [_tableview reloadData];
    }];
}

#pragma mark - TableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 143;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [DD_ShopTool getNumberOfRowsInSection:section WithModel:_shopModel];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [DD_ShopTool getSectionNumWithModel:_shopModel];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    数据还未获取时候
    if(_shopModel==nil)
    {
        static NSString *cellid=@"cellid";
        UITableViewCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if(![DD_ShopTool isInvalidWithSection:indexPath.section WithModel:_shopModel])
    {
        
        //获取到数据以后
        static NSString *cellid=@"cell_normal";
        DD_ShopCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[DD_ShopCell alloc] initWithIsInvalid:NO style:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:^(NSString *type, NSIndexPath *indexPath) {
                if([type isEqualToString:@"select"])
                {
                    ((DD_ShopItemModel *)[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel]).is_select=YES;
                    [self updateTabbarState];
                    
                }else if([type isEqualToString:@"cancel"])
                {
                    ((DD_ShopItemModel *)[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel]).is_select=NO;
                    [self updateTabbarState];
                }else if([type isEqualToString:@"num_alert"])
                {
                    DD_ShopItemModel *shopItem=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
                    [self ChooseSizeWithItem:shopItem WithIndexPath:indexPath WithType:@"num_alert"];
                }else if([type isEqualToString:@"size_alert"])
                {
                    DD_ShopItemModel *shopItem=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
                    [self ChooseSizeWithItem:shopItem WithIndexPath:indexPath WithType:@"size_alert"];
                }
                
            }];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.indexPath=indexPath;
        cell.ItemModel=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
        return cell;
    }else
    {
        //获取到数据以后
        static NSString *cellid=@"cell_invalid";
        DD_ShopCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[DD_ShopCell alloc] initWithIsInvalid:YES style:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:nil];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor=_define_backview_color;
        }
        cell.indexPath=indexPath;
        cell.ItemModel=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
        return cell;
    }
}
/**
 * 左滑删除
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self DeleteAddressWithIndexPath:indexPath];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![DD_ShopTool isInvalidWithSection:indexPath.section WithModel:_shopModel])
    {
        DD_ShopItemModel *item=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
        //                修改/跳转详情页
        DD_ItemsModel *_ItemsModel=[[DD_ItemsModel alloc] init];
        _ItemsModel.g_id=item.itemId;
        _ItemsModel.colorCode=item.colorCode;
        DD_GoodsDetailViewController *_GoodsDetailView=[[DD_GoodsDetailViewController alloc] initWithModel:_ItemsModel WithBlock:^(DD_ItemsModel *model, NSString *type) {
            
        }];
        [self.navigationController pushViewController:_GoodsDetailView animated:YES];
    }
}


#pragma mark - Others
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_tableview)
    {
        [self RequestData];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
