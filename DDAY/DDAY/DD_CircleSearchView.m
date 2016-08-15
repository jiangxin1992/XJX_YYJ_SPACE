//
//  DD_CircleSearchView.m
//  YCO SPACE
//
//  Created by yyj on 16/8/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleSearchView.h"

#import "DD_CricleChooseItemModel.h"

@implementation DD_CircleSearchView
{
    UITextField *searchField;
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
    
    searchField=[[UITextField alloc] init];
    [searchView addSubview:searchField];
    searchField.returnKeyType=UIReturnKeySearch;
    searchField.placeholder=@"搜索款式、设计师、品牌";
    searchField.delegate=self;
    searchField.textColor=_define_black_color;
    searchField.text=_queryStr;
    [searchField becomeFirstResponder];
    [searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16+35);
        make.right.mas_equalTo(-16-35);
        make.top.bottom.mas_equalTo(0);
    }];
    
    UIView *leftView=[UIView getCustomViewWithColor:_define_white_color];
    [searchView addSubview:leftView];
    leftView.frame=CGRectMake(16, 0, 35, 43);
    
    UIButton *leftBtn=[UIButton getCustomImgBtnWithImageStr:@"System_Search" WithSelectedImageStr:nil];
    [leftView addSubview:leftBtn];
    leftBtn.frame=CGRectMake(0, (CGRectGetHeight(leftView.frame)-26)/2.0f, 26, 26);
    [leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView=[UIView getCustomViewWithColor:_define_white_color];
    [searchView addSubview:rightView];
    rightView.frame=CGRectMake(ScreenWidth-16-35, 0, 35, 43);
    UIButton *rightBtn=[UIButton getCustomImgBtnWithImageStr:@"System_Search" WithSelectedImageStr:nil];
    [rightView addSubview:rightBtn];
    rightBtn.frame=CGRectMake(CGRectGetWidth(rightView.frame)-26,(CGRectGetHeight(rightView.frame)-26)/2.0f, 26, 26);
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
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
//    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(searchView.mas_bottom).with.offset(0);
    }];
}
-(void)leftAction
{
    [searchField becomeFirstResponder];
}
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
    UITableViewCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text=item.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_CricleChooseItemModel *item=[_dataArr objectAtIndex:indexPath.section];
    _block(@"search",item.name);
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(![searchField.text isEqualToString:@""])
    {
        NSDictionary *_parameters=@{@"itemName":searchField.text,@"page":[NSNumber numberWithLong:_page],@"token":[DD_UserModel getToken]};
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
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    _block(@"search",searchField.text);
    return YES;
}
@end
