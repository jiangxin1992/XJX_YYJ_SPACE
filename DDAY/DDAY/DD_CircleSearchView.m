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

@implementation DD_CircleSearchView
{
    UISearchBar *_searchBar;
    UITableView *_tableview;
    UIView *searchView;
    NSMutableArray *_dataArr;
    NSInteger _page;
}

-(instancetype)initWithQueryStr:(NSString *)queryStr WithChooseItem:(NSArray *)chooseItem WithBlock:(void(^)(NSString *type,NSString *queryStr))block
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
}
-(void)CreateSearchBar
{
    
    searchView=[UIView getCustomViewWithColor:nil];
    [self addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(43);
    }];
    
    _searchBar = [[UISearchBar alloc] init];
    [searchView addSubview:_searchBar];
    _searchBar.delegate=self;
    _searchBar.placeholder=@"搜索款式、设计师、品牌";
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor=_define_white_color;
    imageView.frame=CGRectMake(0, 0, ScreenWidth-40, 43);
    [_searchBar insertSubview:imageView atIndex:1];
    _searchBar.searchBarStyle=UISearchBarStyleDefault;
    _searchBar.text=_queryStr;
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-40);
    }];
    [_searchBar becomeFirstResponder];
    
    UIButton *cancelBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:14.0f WithSpacing:0 WithNormalTitle:@"取消" WithNormalColor:_define_light_gray_color1 WithSelectedTitle:nil WithSelectedColor:nil];
    [searchView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(_searchBar.mas_right).with.offset(0);
    }];
    
    
//    UIView *leftView=[UIView getCustomViewWithColor:_define_white_color];
//    [searchView addSubview:leftView];
//    leftView.frame=CGRectMake(16, 0, 35, 43);
//    
//    UIButton *leftBtn=[UIButton getCustomImgBtnWithImageStr:@"System_Search" WithSelectedImageStr:nil];
//    [leftView addSubview:leftBtn];
//    leftBtn.frame=CGRectMake(0, (CGRectGetHeight(leftView.frame)-26)/2.0f, 26, 26);
//    [leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIView *rightView=[UIView getCustomViewWithColor:_define_white_color];
//    [searchView addSubview:rightView];
//    rightView.frame=CGRectMake(ScreenWidth-16-35, 0, 35, 43);
//    UIButton *rightBtn=[UIButton getCustomImgBtnWithImageStr:@"System_Search" WithSelectedImageStr:nil];
//    [rightView addSubview:rightBtn];
//    rightBtn.frame=CGRectMake(CGRectGetWidth(rightView.frame)-26,(CGRectGetHeight(rightView.frame)-26)/2.0f, 26, 26);
//    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *downLine=[UIView getCustomViewWithColor:_define_black_color];
    [searchView addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
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
                [_tableview reloadData];
            }else
            {
                if(_page==1)
                {
                    [_dataArr removeAllObjects];//删除所有数据
                }
                [_tableview reloadData];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
        }];
    }else
    {
        [_dataArr removeAllObjects];
        _page=1;
        [_tableview reloadData];
    }
}
//-(void)leftAction
//{
//    [_searchBar becomeFirstResponder];
//}
-(void)rightAction
{
    _block(@"back",@"");
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
    DD_CricleChooseItemModel *item=[_dataArr objectAtIndex:indexPath.section];
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
    DD_CricleChooseItemModel *item=[_dataArr objectAtIndex:indexPath.section];
    _block(@"search",item.name);
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self searchAction];
    NSLog(@"ShouldBeginEditing");
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchAction];
    NSLog(@"DidChange");
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _block(@"search",_searchBar.text);

}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    _block(@"search",_searchBar.text);
//    return YES;
//}
@end
