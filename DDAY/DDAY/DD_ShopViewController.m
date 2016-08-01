//
//  DD_ShopViewController.m
//  DDAY
//
//  Created by yyj on 16/5/25.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ClearingViewController.h"
#import "DD_ShopClearingView.h"
#import "DD_ItemsModel.h"
#import "DD_GoodsDetailViewController.h"
#import "DD_ShopHeaderView.h"
#import "DD_ShopViewController.h"
#import "DD_ShopModel.h"
#import "DD_ShopTool.h"
#import "DD_ShopCell.h"
#import "DD_ShopEditingCell.h"
#import "DD_SizeModel.h"
#import "DD_ChooseSizeView.h"
@interface DD_ShopViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DD_ShopViewController
{
    UITableView *_tableview;//tableview
    DD_ShopClearingView *_tabbar;//自定义tabbar
    UIImageView *mengban;//蒙版
    
    DD_ShopModel *_shopModel;//购物车model
    BOOL _isEditing;//cell样式切换，是否是编辑状态
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData
{
    _isEditing=NO;//初始化状态为非编辑状态
}
-(void)PrepareUI
{

    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"shop_title", @"") withmaxwidth:200];//设置标题
    self.view.backgroundColor=_define_backview_color;//设置背景色
//    创建导航栏baritem
    UIButton *editingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    editingBtn.frame=CGRectMake(0, 0, 50, 25);
    [editingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [editingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [editingBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editingBtn setTitle:@"完成" forState:UIControlStateSelected];
    [editingBtn addTarget:self action:@selector(editingAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:editingBtn];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popAction)];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTableView];
    [self CreateTabbar];
}
/**
 * 创建自定义tabbar
 */
-(void)CreateTabbar
{
    _tabbar=[[DD_ShopClearingView alloc] initWithFrame:CGRectMake(0, ScreenHeight-ktabbarHeight, ScreenWidth, ktabbarHeight) WithShopModel:_shopModel WithBlock:^(NSString *type) {
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
}
/**
 * tableview创建
 */
-(void)CreateTableView
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableview];
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;//    消除分割线
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.1)];
    _tableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.1)];
}
/**
 * 创建选择尺寸视图
 */
-(void)CreateSizeChooseViewWithSizeArr:(NSArray *)sizeArr WithIndexPath:(NSIndexPath *)indexPath
{
    mengban=[UIImageView getMaskImageView];
    [self.view.window addSubview:mengban];
    [mengban addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mengban_dismiss)]];
    
    DD_ShopItemModel * itemModel=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
    [mengban addSubview:[[DD_ChooseSizeView alloc] initWithSizeArr:sizeArr WithColorID:itemModel.colorId WithBlock:^(NSString *type,NSString *sizeid,NSString *colorid,NSInteger count) {
        [self mengban_dismiss];
        if([type isEqualToString:@"alert"])
        {
            if([sizeid isEqualToString:@""])
            {
                [self presentViewController:[regular alertTitle_Simple:@"请先选择尺寸"] animated:YES completion:nil];
            }
            else
            {
                DD_ShopItemModel *itemModel=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
//                判断是否有相同item
//                有则删除、没有则修改
                if([self haveSameItemWithIndexPath:indexPath WithSizeID:sizeid WithColorID:colorid])
                {
                    NSArray *_parameters=@[@{@"itemId":itemModel.itemId,@"colorId":itemModel.colorId,@"sizeId":itemModel.sizeId}];
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
                                             ,@"sizeId":sizeid
                                             ,@"sizeName":[self GetSizeNameWithID:sizeid WithSizeArr:sizeArr]
                                             ,@"discountEnable":[NSNumber numberWithBool:itemModel.discountEnable]
                                             ,@"seriesId":itemModel.seriesId
                                             ,@"seriesName":itemModel.seriesName
                                             ,@"designerId":itemModel.designerId
                                             ,@"brandName":itemModel.brandName
                                             ,@"number":itemModel.number
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
                            itemModel.sizeId=sizeid;
                            itemModel.sizeName=[self GetSizeNameWithID:sizeid WithSizeArr:sizeArr];
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
    }]];
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
            [_tableview reloadData];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
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
-(void)ChooseSizeWithItem:(DD_ShopItemModel *)_ItemModel WithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"itemId":_ItemModel.itemId,@"colorId":_ItemModel.colorId};
    [[JX_AFNetworking alloc] GET:@"item/getItemSizeInfo.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            NSArray *sizeArr=[DD_SizeModel getSizeModelArr:[data objectForKey:@"size"]];
            [self CreateSizeChooseViewWithSizeArr:sizeArr WithIndexPath:indexPath];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
/**
 * 删除蒙版
 */
-(void)mengban_dismiss
{
    [mengban removeFromSuperview];
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
                [self.navigationController pushViewController:[[DD_ClearingViewController alloc] initWithModel:_ClearingModel WithBlock:nil] animated:YES];
                
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
 * 编辑,改变cell样式
 */
-(void)editingAction:(UIButton *)btn
{
    if(btn.selected)
    {
        btn.selected=NO;
        _isEditing=NO;
    }else
    {
        btn.selected=YES;
        _isEditing=YES;
    }
    [_tableview reloadData];
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
    NSArray *_parameters=@[@{@"itemId":itemModel.itemId,@"colorId":itemModel.colorId,@"sizeId":itemModel.sizeId}];
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
    return 140;
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
        if(!_isEditing)
        {
            //获取到数据以后
            static NSString *cellid=@"cell_normal";
            DD_ShopCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
            if(!cell)
            {
                
                cell=[[DD_ShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid cellForRowAtIndexPath:indexPath WithIsInvalid:NO WithBlock:^(NSString *type, NSIndexPath *indexPath) {
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
                    }
                    
                    
                }];
            }
            cell.ItemModel=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
            cell.contentView.backgroundColor=_define_backview_color;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else
        {
            //获取到数据以后
//            initWithStyle
            static NSString *cellid=@"cell_normal_edit";
            DD_ShopEditingCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
            if(!cell)
            {
                
                cell=[[DD_ShopEditingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid cellForRowAtIndexPath:indexPath WithBlock:^(NSString *type, NSIndexPath *indexPath,DD_ShopModel *shopModel) {
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
                    }else if([type isEqualToString:@"choose_size"])
                    {
                        DD_ShopItemModel *shopItem=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
                        [self ChooseSizeWithItem:shopItem WithIndexPath:indexPath] ;
                        
                    }else if([type isEqualToString:@"add"]||[type isEqualToString:@"cut"])
                    {
                        DD_ShopItemModel *itemModel=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:shopModel];
                        NSDictionary *_parameters=@{
                                                    @"items":[@[@{
                                                                    @"itemId":itemModel.itemId
                                                                    ,@"itemName":itemModel.itemName
                                                                    ,@"colorId":itemModel.colorId
                                                                    ,@"colorName":itemModel.colorName
                                                                    ,@"sizeId":itemModel.sizeId
                                                                    ,@"sizeName":itemModel.sizeName
                                                                    ,@"discountEnable":[NSNumber numberWithBool:itemModel.discountEnable]
                                                                    ,@"seriesId":itemModel.seriesId
                                                                    ,@"seriesName":itemModel.seriesName
                                                                    ,@"designerId":itemModel.designerId
                                                                    ,@"brandName":itemModel.brandName
                                                                    ,@"number":itemModel.number
                                                                    ,@"price":itemModel.price
                                                                    ,@"originalPrice":itemModel.originalPrice
                                                                    ,@"pics":itemModel.pics
                                                                    ,@"saleEndTime":[NSNumber numberWithLong:itemModel.saleEndTime*1000]
                                                                    ,@"saleStartTime":[NSNumber numberWithLong:itemModel.saleStartTime*1000]
                                                                    ,@"signEndTime":[NSNumber numberWithLong:itemModel.signEndTime*1000]
                                                                    ,@"signStartTime":[NSNumber numberWithLong:itemModel.signStartTime*1000]
                                                                    ,@"oldSizeId":itemModel.sizeId
                                                                    }
                                                                ] JSONString]
                                                    ,@"token":[DD_UserModel getToken]
                                                    };
                        [[JX_AFNetworking alloc] GET:@"item/editShoppingCart.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                            if(success)
                            {
                                _shopModel=shopModel;
                                [self updateTabbarState];
                            }else
                            {
                                [self presentViewController:successAlert animated:YES completion:nil];
                            }
                        } failure:^(NSError *error, UIAlertController *failureAlert) {
                            [self presentViewController:failureAlert animated:YES completion:nil];
                        }];
                        
                        
                    }else if([type isEqualToString:@"cut_no"])
                    {
                        [self presentViewController:[regular alertTitle_Simple:@"受不了了，宝贝不能在减少了哦"] animated:YES completion:nil];
                    }
                }];
            }
            cell.ItemModel=[DD_ShopTool getNumberOfRowsIndexPath:indexPath WithModel:_shopModel];
            cell.shopModel=_shopModel;
            cell.contentView.backgroundColor=_define_backview_color;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else
    {
        //获取到数据以后
        static NSString *cellid=@"cell_invalid";
        DD_ShopCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[DD_ShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid cellForRowAtIndexPath:indexPath WithIsInvalid:YES WithBlock:nil];
        }
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
        DD_GoodsDetailViewController *_GoodsDetailView=[[DD_GoodsDetailViewController alloc] init];
        DD_ItemsModel *_ItemsModel=[[DD_ItemsModel alloc] init];
        _ItemsModel.colorId=item.colorId;
        _ItemsModel.g_id=item.itemId;
        
        _GoodsDetailView.title=item.itemName;
        _GoodsDetailView.model=_ItemsModel;
        
        [self.navigationController pushViewController:_GoodsDetailView animated:YES];
    }
    
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //section头部高度
    return 40;
}
//section头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DD_ShopHeaderView *headerView=[[DD_ShopHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40) WithSection:section WithShopModel:_shopModel WithBlock:^(NSString *type, NSInteger section) {
        if(![DD_ShopTool isInvalidWithSection:section WithModel:_shopModel])
        {
            if([type isEqualToString:@"cancel_all"])
            {
                [DD_ShopTool selectAllWithModel:_shopModel WithSelect:NO WithSection:section];
                headerView.shopModel=_shopModel;
                [self updateTabbarState];
            }else if([type isEqualToString:@"select_all"])
            {
                [DD_ShopTool selectAllWithModel:_shopModel WithSelect:YES  WithSection:section];
                headerView.shopModel=_shopModel;
                [self updateTabbarState];
            }else if([type isEqualToString:@"refresh"])
            {
                headerView.shopModel=_shopModel;
                [self updateTabbarState];
            }
        }
    }];
    return headerView;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if(_shopModel.seriesInvalid.count)
    {
        if(section==[DD_ShopTool getInvalidSectionNum:_shopModel])
        {
            return 40;
        }
        return 0;
    }else
    {
     
        return 0;
    }
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(_shopModel.seriesInvalid.count)
    {
        if(section==[DD_ShopTool getInvalidSectionNum:_shopModel])
        {
            return [DD_ShopTool getViewFooter];
        }
        return [[UIView alloc] init];
    }else
    {
        return [[UIView alloc] init];
    }
}

#pragma mark - Others
-(void)viewWillAppear:(BOOL)animated
{
    if(_tableview)
    {
        [self RequestData];
    }
    [[DD_CustomViewController sharedManager] tabbarHide];
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

@end