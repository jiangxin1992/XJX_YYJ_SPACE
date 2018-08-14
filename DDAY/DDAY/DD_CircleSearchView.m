//
//  DD_CircleSearchView.m
//  YCO SPACE
//
//  Created by yyj on 16/8/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleSearchView.h"

#import "DD_CricleChooseItemModel.h"

#import "DD_CircleSearchCell.h"

@interface DD_CircleSearchView()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@end

@implementation DD_CircleSearchView
{
    UISearchBar *_searchBar;
    UITableView *_tableview;
    UIView *searchView;
    NSMutableArray *_dataArr;
    NSInteger _page;
    UIView *_noDataView;
}

-(instancetype)initWithQueryStr:(NSString *)queryStr WithChooseItem:(NSArray *)chooseItem WithBlock:(void(^)(NSString *type,NSString *queryStr,DD_CricleChooseItemModel *chooseItemModel))block
{
    _block=block;
    _queryStr=queryStr;
    _chooseItem=chooseItem;
    self=[super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if(self)
    {
        [self SomePrepare];
        [self UIConfig];
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
    _dataArr=[[NSMutableArray alloc] init];
    _page=1;
}
-(void)PrepareUI
{
    self.backgroundColor=_define_white_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateSearchBar];
    [self CreateTableView];
    [self CreateNoDataView];
}
-(void)CreateSearchBar
{
    
    searchView=[UIView getCustomViewWithColor:nil];
    [self addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kStatusBarHeight+15);
        make.height.mas_equalTo(43);
    }];
    
    _searchBar = [[UISearchBar alloc] init];
    [searchView addSubview:_searchBar];
    _searchBar.delegate=self;
    _searchBar.placeholder=@"请输入设计师、品牌、款式名称";
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor=_define_white_color;
    imageView.frame=CGRectMake(0, 0, ScreenWidth-40, 43);
    [_searchBar insertSubview:imageView atIndex:1];
    _searchBar.searchBarStyle=UISearchBarStyleDefault;
    _searchBar.text=_queryStr;
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-60);
    }];
    [_searchBar becomeFirstResponder];
    
    UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.backgroundColor=[UIColor clearColor];
    [searchField setValue:[regular getFont:12.0f] forKeyPath:@"_placeholderLabel.font"];
    UIView *leftview=[UIView getCustomViewWithColor:nil];
    leftview.frame=CGRectMake(0, 0, 24+20, 30);
    UIImageView *img=[UIImageView getImgWithImageStr:@"System_Search"];
    [leftview addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(leftview);
        make.width.height.mas_equalTo(24);
    }];
    searchField.leftView=leftview;
    
    UIButton *cancelBtn=[UIButton getCustomTitleBtnWithAlignment:1 WithFont:13.0f WithSpacing:0 WithNormalTitle:NSLocalizedString(@"cancel", @"") WithNormalColor:_define_black_color WithSelectedTitle:nil WithSelectedColor:nil];
    [searchView addSubview:cancelBtn];
    [cancelBtn setEnlargeEdgeWithTop:0 right:0 bottom:0 left:15];
    [cancelBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(_searchBar.mas_right).with.offset(15);
    }];
    
}
-(void)CreateTableView
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self addSubview:_tableview];
    //    消除分割线
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(searchView.mas_bottom).with.offset(0);
    }];
}
-(void)CreateNoDataView
{
    _noDataView=[UIView getCustomViewWithColor:nil];
    [_tableview addSubview:_noDataView];
    [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_tableview);
    }];
    
    UIImageView *img=[UIImageView getImgWithImageStr:@"System_Search_NoData"];
    [_noDataView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.centerY.mas_equalTo(_noDataView);
        make.width.height.mas_equalTo(24);
    }];
    
    UILabel *label=[UILabel getLabelWithAlignment:0 WithTitle:@"未找到相关款式" WithFont:13.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [_noDataView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(img.mas_right).with.offset(5);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(_noDataView);
    }];
    _noDataView.hidden=NO;
}
#pragma mark - someAction
-(void)searchAction
{
    if(![_searchBar.text isEqualToString:@""])
    {
        NSDictionary *_parameters=@{@"queryStr":_searchBar.text,@"page":[NSNumber numberWithLong:_page],@"token":[DD_UserModel getToken]};
        [[JX_AFNetworking alloc] GET:@"item/queryColorItemsByParam.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                if(_page==1)
                {
                    [_dataArr removeAllObjects];//删除所有数据
                }
                NSArray *getarr=[DD_CricleChooseItemModel getItemsModelArr:[data objectForKey:@"items"] WithDetail:_chooseItem];
                [_dataArr addObjectsFromArray:getarr];
                [self reload];
            }else
            {
                if(_page==1)
                {
                    [_dataArr removeAllObjects];//删除所有数据
                }
                [self reload];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
        }];
    }else
    {
        [_dataArr removeAllObjects];
        _page=1;
        [self reload];
    }
}
-(void)reload
{
    [_tableview reloadData];
    if(_dataArr.count)
    {
        _noDataView.hidden=YES;
    }else
    {
        if([NSString isNilOrEmpty:_searchBar.text])
        {
            _noDataView.hidden=YES;
        }else
        {
            _noDataView.hidden=NO;
        }
    }
}
//-(void)leftAction
//{
//    [_searchBar becomeFirstResponder];
//}
-(void)rightAction
{
    _block(@"back",@"",nil);
//    _queryStr=@"";
//    searchField.text=_queryStr;
}
#pragma mark - TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_CricleChooseItemModel *item=_dataArr[indexPath.section];
    //    数据还未获取时候
    if(_dataArr.count==indexPath.section)
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
    //获取到数据以后
    static NSString *cellid=@"cellid";
    DD_CircleSearchCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[DD_CircleSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.content=item.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_CricleChooseItemModel *item=_dataArr[indexPath.section];
    _block(@"search",item.name,item);
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self searchAction];
    JXLOG(@"ShouldBeginEditing");
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchAction];
    JXLOG(@"DidChange");
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    [searchBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(!idx)
        {
            UIView *backView = [UIView getCustomViewWithColor:_define_light_gray_color3];
            [obj addSubview:backView];
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20+24+5+10);
                make.centerY.mas_equalTo(obj);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(30);
            }];
            backView.layer.masksToBounds=YES;
            backView.layer.cornerRadius=4;
            [_searchBar insertSubview:backView atIndex:2];
        }
    }];
    
}
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    _block(@"search",_searchBar.text,nil);
//
//}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    _block(@"search",_searchBar.text);
//    return YES;
//}
@end
