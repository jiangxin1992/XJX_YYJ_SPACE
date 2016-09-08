//
//  DD_ShopViewController.m
//  DDAY
//
//  Created by yyj on 16/5/25.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShopViewController.h"

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

@interface DD_ShopViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_ShopViewController
{
    UITableView *_tableview;//tableview
    DD_ShopClearingView *_tabbar;//自定义tabbar
    
    
    DD_ShopModel *_shopModel;//购物车model
//    BOOL _isEditing;//cell样式切换，是否是编辑状态
    
    UIImageView *mengban_num;//蒙版
    UIImageView *mengban_size;//蒙版
    DD_ShopAlertNumView *_alertNumView;
    DD_ShopAlertSizeView *_alertSizeView;

    
    CGFloat _mengban_size_Height;
    
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
    [backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
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
    _tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self RequestData];
    }];
    
    [_tableview.header beginRefreshing];
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
        make.bottom.mas_equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(ktabbarHeight);
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
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
/**
 * 创建Size选择视图
 */
-(void)CreateSizeChooseViewWithSizeAlertModel:(DD_SizeAlertModel *)sizeAlertModel WithIndexPath:(NSIndexPath *)indexPath
{
    if(!mengban_num&&!mengban_size)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        mengban_size=[UIImageView getMaskImageView];
        [self.view addSubview:mengban_size];
        [mengban_size addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mengban_size_dismiss)]];
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
                            [[JX_AFNetworking alloc] GET:@"item/delFromShoppingCart.do" parameters:@{@"token":[DD_UserModel getToken],@"items":[_parameters JSONString]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                                if(success)
                                {
                                    [DD_ShopTool removeItemModelWithIndexPath:indexPath WithModel:_shopModel];
                                    [_tableview reloadData];
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
                                                        @"items":[_itemsArr JSONString]
                                                        ,@"token":[DD_UserModel getToken]
                                                        };
                            [[JX_AFNetworking alloc] GET:@"item/editShoppingCart.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                                if(success)
                                {
                                    itemModel.sizeId=sizeId;
                                    itemModel.sizeName=sizeName;
                                    itemModel.number=[[NSString alloc] initWithFormat:@"%ld",count];
                                    [_tableview reloadData];
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
            }
            
        }];
        [mengban_size addSubview:_alertSizeView];
        //    230:187
        _mengban_size_Height=0;
        if(!sizeAlertModel.sizeBriefPic||[sizeAlertModel.sizeBriefPic isEqualToString:@""])
        {
            _mengban_size_Height=IsPhone6_gt?(78+ktabbarHeight):(58+ktabbarHeight);
        }else
        {
            CGFloat _imgHeight=(((CGFloat)sizeAlertModel.sizeBriefPicHeight)/((CGFloat)sizeAlertModel.sizeBriefPicWidth))*(ScreenWidth-kEdge*2);
            _mengban_size_Height=IsPhone6_gt?(97+6+ktabbarHeight+_imgHeight):(77+6+ktabbarHeight+_imgHeight);
        }
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
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        mengban_num=[UIImageView getMaskImageView];
        [self.view addSubview:mengban_num];
        [mengban_num addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mengban_num_dismiss)]];
        
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
                        [[JX_AFNetworking alloc] GET:@"item/delFromShoppingCart.do" parameters:@{@"token":[DD_UserModel getToken],@"items":[_parameters JSONString]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                            if(success)
                            {
                                [DD_ShopTool removeItemModelWithIndexPath:indexPath WithModel:_shopModel];
                                [_tableview reloadData];
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
                                                    @"items":[_itemsArr JSONString]
                                                    ,@"token":[DD_UserModel getToken]
                                                    };
                        [[JX_AFNetworking alloc] GET:@"item/editShoppingCart.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                            if(success)
                            {
                                itemModel.number=[[NSString alloc] initWithFormat:@"%ld",count];
                                [_tableview reloadData];
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
        
        _alertNumView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, IsPhone6_gt?161:138);
        [UIView animateWithDuration:0.3 animations:^{
            _alertNumView.frame=CGRectMake(0, ScreenHeight-(IsPhone6_gt?(66+4+ktabbarHeight):(46+4+ktabbarHeight)), ScreenWidth, IsPhone6_gt?(66+ktabbarHeight):(46+ktabbarHeight));
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
            [_tableview.header endRefreshing];
            [_tableview.footer endRefreshing];
            
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
            [_tableview.header endRefreshing];
            [_tableview.footer endRefreshing];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
        [_tableview.header endRefreshing];
        [_tableview.footer endRefreshing];
    }];
}

#pragma mark - SomeActions

/**
 * 返回
 * 取消所有定时器
 */
-(void)popAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self cancelAllTimer];
}
/**
 * 取消所有定时器
 */
-(void)cancelAllTimer
{
    for (DD_ShopSeriesModel *_series in _shopModel.seriesNormal) {
        [regular dispatch_cancel:_series.timer];
    }
    for (DD_ShopSeriesModel *_series in _shopModel.seriesInvalid) {
        [regular dispatch_cancel:_series.timer];
    }
}
/**
 * 遍历当前系列。
 * 是否有相同的item
 * 有则删除请求
 * 反之修改请求
 */
-(BOOL )haveSameItemWithIndexPath:(NSIndexPath *)indexPath WithSizeID:(NSString *)sizeid WithColorID:(NSString *)colorid
{
    DD_ShopSeriesModel *seriesModel=[DD_ShopTool getNumberSection:indexPath.section WithModel:_shopModel];
    for (int i=0; i<seriesModel.items.count; i++) {
        DD_ShopItemModel *_item=[seriesModel.items objectAtIndex:i];
        if([_item.sizeId isEqualToString:sizeid]&&[_item.colorId isEqualToString:colorid]&&i!=indexPath.row)
        {
            return YES;
        }
    }
    return NO;
}
/**
 * 根据当前选择的sizeid获取sizename
 */
-(NSString *)GetSizeNameWithID:(NSString *)sizeID WithSizeArr:(NSArray *)sizeArr
{
    for (DD_SizeModel *sizeModel in sizeArr) {
        if([sizeModel.sizeId isEqualToString:sizeID])
        {
            return sizeModel.sizeName;
        }
    }
    return @"";
}
/**
 * 选择尺寸
 */
-(void)ChooseSizeWithItem:(DD_ShopItemModel *)_ItemModel WithIndexPath:(NSIndexPath *)indexPath WithType:(NSString *)type
{
    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"itemId":_ItemModel.itemId,@"colorCode":_ItemModel.colorCode};
    [[JX_AFNetworking alloc] GET:@"item/getItemSizeInfo.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            DD_SizeAlertModel *sizeAlertModel=[DD_SizeAlertModel getSizeAlertModel:data];
//            NSArray *sizeArr=[DD_SizeModel getSizeModelArr:[data objectForKey:@"size"]];
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
        [mengban_size removeFromSuperview];
        mengban_size=nil;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }];
}
-(void)mengban_num_dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        _alertNumView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, IsPhone6_gt?(66+ktabbarHeight):(46+ktabbarHeight));
    } completion:^(BOOL finished) {
        [mengban_num removeFromSuperview];
        mengban_num=nil;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }];
}

/**
 * 结算
 */
-(void)ConfirmAction
{

    NSArray *_itemArr=[DD_ShopTool getConfirmArrWithModel:_shopModel];
    if(_itemArr.count)
    {
        NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"buyItems":[_itemArr JSONString]};
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
    [[JX_AFNetworking alloc] GET:@"item/delFromShoppingCart.do" parameters:@{@"token":[DD_UserModel getToken],@"items":[_parameters JSONString]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            [DD_ShopTool removeItemModelWithIndexPath:indexPath WithModel:_shopModel];
            [_tableview reloadData];
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
            
            cell=[[DD_ShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:^(NSString *type, NSIndexPath *indexPath) {
                if([type isEqualToString:@"select"])
                {
                    //                    select
                    ((DD_ShopItemModel *)[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel]).is_select=YES;
                    [self updateTabbarState];
                    
                }else if([type isEqualToString:@"cancel"])
                {
                    //                    cancel
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
        }
        cell.indexPath=indexPath;
        cell.ItemModel=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        //获取到数据以后
        static NSString *cellid=@"cell_invalid";
        DD_ShopCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[DD_ShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:nil];
        }
        cell.indexPath=indexPath;
        cell.ItemModel=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
        cell.contentView.backgroundColor=_define_backview_color;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
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
        _ItemsModel.colorId=item.colorId;
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
    [MobClick beginLogPageView:@"DD_ShopViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_ShopViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 弃用代码
/**
 * 编辑,改变cell样式
 */
//-(void)editingAction:(UIButton *)btn
//{
//    if(btn.selected)
//    {
//        btn.selected=NO;
//        _isEditing=NO;
//    }else
//    {
//        btn.selected=YES;
//        _isEditing=YES;
//    }
//    [_tableview reloadData];
//}

//section头部间距
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//section头部高度
//    return 40;
//    return 0;
//}
//section头部视图
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    DD_ShopHeaderView *headerView=[[DD_ShopHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40) WithSection:section WithShopModel:_shopModel WithBlock:^(NSString *type, NSInteger section) {
//        if(![DD_ShopTool isInvalidWithSection:section WithModel:_shopModel])
//        {
//            if([type isEqualToString:@"cancel_all"])
//            {
//                [DD_ShopTool selectAllWithModel:_shopModel WithSelect:NO WithSection:section];
//                headerView.shopModel=_shopModel;
//                [self updateTabbarState];
//            }else if([type isEqualToString:@"select_all"])
//            {
//                [DD_ShopTool selectAllWithModel:_shopModel WithSelect:YES  WithSection:section];
//                headerView.shopModel=_shopModel;
//                [self updateTabbarState];
//            }else if([type isEqualToString:@"refresh"])
//            {
//                headerView.shopModel=_shopModel;
//                [self updateTabbarState];
//            }
//        }
//    }];
//    return headerView;
//    return [[UIView alloc] init];
//}
//section底部间距
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0;
//    if(_shopModel.seriesInvalid.count)
//    {
//        if(section==[DD_ShopTool getInvalidSectionNum:_shopModel])
//        {
//            return 40;
//        }
//        return 0;
//    }else
//    {
//
//        return 0;
//    }
//}
//section底部视图
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [[UIView alloc] init];
//    if(_shopModel.seriesInvalid.count)
//    {
//        if(section==[DD_ShopTool getInvalidSectionNum:_shopModel])
//        {
//            return [DD_ShopTool getViewFooter];
//        }
//        return [[UIView alloc] init];
//    }else
//    {
//        return [[UIView alloc] init];
//    }
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //    数据还未获取时候
//    if(_shopModel==nil)
//    {
//        static NSString *cellid=@"cellid";
//        UITableViewCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
//        if(!cell)
//        {
//            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
//        }
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        return cell;
//    }
//    if(![DD_ShopTool isInvalidWithSection:indexPath.section WithModel:_shopModel])
//    {
//        if(!_isEditing)
//        {
//            //获取到数据以后
//            static NSString *cellid=@"cell_normal";
//            DD_ShopCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
//            if(!cell)
//            {
//                
//                cell=[[DD_ShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid cellForRowAtIndexPath:indexPath WithIsInvalid:NO WithBlock:^(NSString *type, NSIndexPath *indexPath) {
//                    if([type isEqualToString:@"select"])
//                    {
//                        //                    select
//                        ((DD_ShopItemModel *)[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel]).is_select=YES;
//                        [self updateTabbarState];
//                        
//                    }else if([type isEqualToString:@"cancel"])
//                    {
//                        //                    cancel
//                        ((DD_ShopItemModel *)[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel]).is_select=NO;
//                        [self updateTabbarState];
//                    }
//                    
//                    
//                }];
//            }
//            cell.ItemModel=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
//            cell.contentView.backgroundColor=_define_backview_color;
//            cell.selectionStyle=UITableViewCellSelectionStyleNone;
//            return cell;
//        }else
//        {
//            //获取到数据以后
//            //            initWithStyle
//            static NSString *cellid=@"cell_normal_edit";
//            DD_ShopEditingCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
//            if(!cell)
//            {
//                
//                cell=[[DD_ShopEditingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid cellForRowAtIndexPath:indexPath WithBlock:^(NSString *type, NSIndexPath *indexPath,DD_ShopModel *shopModel) {
//                    if([type isEqualToString:@"select"])
//                    {
//                        //                    select
//                        ((DD_ShopItemModel *)[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel]).is_select=YES;
//                        [self updateTabbarState];
//                        
//                    }else if([type isEqualToString:@"cancel"])
//                    {
//                        //                    cancel
//                        ((DD_ShopItemModel *)[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel]).is_select=NO;
//                        [self updateTabbarState];
//                    }else if([type isEqualToString:@"choose_size"])
//                    {
//                        DD_ShopItemModel *shopItem=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
//                        [self ChooseSizeWithItem:shopItem WithIndexPath:indexPath] ;
//                        
//                    }else if([type isEqualToString:@"add"]||[type isEqualToString:@"cut"])
//                    {
//                        DD_ShopItemModel *itemModel=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:shopModel];
//                        NSDictionary *_parameters=@{
//                                                    @"items":[@[@{
//                                                                    @"itemId":itemModel.itemId
//                                                                    ,@"itemName":itemModel.itemName
//                                                                    ,@"colorId":itemModel.colorId
//                                                                    ,@"colorName":itemModel.colorName
//                                                                    ,@"sizeId":itemModel.sizeId
//                                                                    ,@"sizeName":itemModel.sizeName
//                                                                    ,@"discountEnable":[NSNumber numberWithBool:itemModel.discountEnable]
//                                                                    ,@"seriesId":itemModel.seriesId
//                                                                    ,@"seriesName":itemModel.seriesName
//                                                                    ,@"designerId":itemModel.designerId
//                                                                    ,@"brandName":itemModel.brandName
//                                                                    ,@"number":itemModel.number
//                                                                    ,@"price":itemModel.price
//                                                                    ,@"originalPrice":itemModel.originalPrice
//                                                                    ,@"pics":itemModel.pics
//                                                                    ,@"saleEndTime":[NSNumber numberWithLong:itemModel.saleEndTime*1000]
//                                                                    ,@"saleStartTime":[NSNumber numberWithLong:itemModel.saleStartTime*1000]
//                                                                    ,@"signEndTime":[NSNumber numberWithLong:itemModel.signEndTime*1000]
//                                                                    ,@"signStartTime":[NSNumber numberWithLong:itemModel.signStartTime*1000]
//                                                                    ,@"oldSizeId":itemModel.sizeId
//                                                                    }
//                                                                ] JSONString]
//                                                    ,@"token":[DD_UserModel getToken]
//                                                    };
//                        [[JX_AFNetworking alloc] GET:@"item/editShoppingCart.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
//                            if(success)
//                            {
//                                _shopModel=shopModel;
//                                [self updateTabbarState];
//                            }else
//                            {
//                                [self presentViewController:successAlert animated:YES completion:nil];
//                            }
//                        } failure:^(NSError *error, UIAlertController *failureAlert) {
//                            [self presentViewController:failureAlert animated:YES completion:nil];
//                        }];
//                        
//                        
//                    }else if([type isEqualToString:@"cut_no"])
//                    {
//                        [self presentViewController:[regular alertTitle_Simple:@"受不了了，宝贝不能在减少了哦"] animated:YES completion:nil];
//                    }
//                }];
//            }
//            cell.ItemModel=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
//            cell.shopModel=_shopModel;
//            cell.contentView.backgroundColor=_define_backview_color;
//            cell.selectionStyle=UITableViewCellSelectionStyleNone;
//            return cell;
//        }
//        
//    }else
//    {
//        //获取到数据以后
//        static NSString *cellid=@"cell_invalid";
//        DD_ShopCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
//        if(!cell)
//        {
//            cell=[[DD_ShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid cellForRowAtIndexPath:indexPath WithIsInvalid:YES WithBlock:nil];
//        }
//        cell.ItemModel=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
//        cell.contentView.backgroundColor=_define_backview_color;
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        return cell;
//    }
//}
@end
