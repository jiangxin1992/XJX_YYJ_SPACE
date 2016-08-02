//
//  DD_CircleChooseDetailView.m
//  DDAY
//
//  Created by yyj on 16/6/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_ItemsModel.h"
#import "DD_CricleChooseItemModel.h"
#import "DD_CricleCategoryModel.h"
#import "UIButton+WebCache.h"

#import "DD_CricleChooseCell.h"
#import "DD_GoodsDetailViewController.h"

#import "DD_CircleChooseDetailView.h"


@interface DD_CircleChooseDetailView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DD_CircleChooseDetailView
{
    CGFloat _width;//已选款式view宽度
    long _page;//当前页
    NSString *itemName;//关键词
    NSString *categoryCode;//当前选择分类code
    
    UIView *_upView;//上部view
    UILabel *_numLabel;//剩余可选款数
    NSMutableArray *btnArr;//存放的按钮数组
    
    UIView *_downView;//下部view
    UIButton *_screeningBtn;//选择分类按钮
    
    UITableView *_tableView;//选择款式tableview
    NSMutableArray *_dataArr;//当前款式列表数据
    UITableView *_chooseTableView;//下拉框
    BOOL _isShow;// 当前下拉框是否显示
    NSMutableArray *_categoryArr;//下拉框数据
    
    void (^cellblock)(NSString *type,NSInteger index);//cell回调block
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - 初始化
-(instancetype)initWithCircleModel:(DD_CircleModel *)CircleModel WithLimitNum:(NSInteger )num WithBlock:(void (^)(NSString *type,NSInteger index))block
{
    self=[super init];
    if(self)
    {
        _circleModel=CircleModel;
        _block=block;
        _num=num;
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
    [self SomeBlock];
}

-(void)PrepareData
{
    btnArr=[[NSMutableArray alloc] init];
    _dataArr=[[NSMutableArray alloc] init];
    _categoryArr=[[NSMutableArray alloc] init];
    _width=(ScreenWidth-50)/4.0f;
    _isShow=NO;
    _page=1;
    itemName=@"";
    categoryCode=@"";
    
}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:@"款式选择" withmaxwidth:200];
}
-(void)SomeBlock
{
    __block DD_CircleChooseDetailView *_chooseView=self;
    __block NSMutableArray *___chooseItem=_circleModel.chooseItem;
    __block NSMutableArray *___dataArr=_dataArr;
    __block NSInteger ___num=_num;
//    __block UILabel *___numLabel =_numLabel;
    cellblock=^(NSString *type,NSInteger index)
    {
        if([type isEqualToString:@"addItem"])
        {
            if(___chooseItem.count<___num)
            {
                [___chooseItem addObject:[___dataArr objectAtIndex:index]];
                _numLabel.text=[[NSString alloc] initWithFormat:@"还可选择%ld款",___num-___chooseItem.count];
            }else
            {
                [_chooseView presentViewController:[regular alertTitle_Simple:[[NSString alloc] initWithFormat:@"最多可选择%ld款",___num]] animated:YES completion:nil];
            }
            [_chooseView UpdateImgView];
        }else if([type isEqualToString:@"delItem"])
        {
            _block(@"delete_choose_item",index);
            [_chooseView UpdateImgView];
        }
        
    };
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateUpView];
    [self CreateDownView];
}
-(void)CreateUpView
{
    [self initUpView];
    [self CreateImgView];
}
-(void)initUpView
{
    _upView=[[UIView alloc] init];
    [self.view addSubview:_upView];
    _upView.backgroundColor=[UIColor whiteColor];
    [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(ScreenWidth);
        make.top.mas_equalTo(64);
    }];
    
    UILabel *leftlabel=[[UILabel alloc] init];
    [_upView addSubview:leftlabel];
    leftlabel.textColor=[UIColor grayColor];
    leftlabel.textAlignment=0;
    leftlabel.font=[regular getFont:12.0f];
    leftlabel.text=@"已选款式";
    
    _numLabel=[[UILabel alloc] init];
    [_upView addSubview:_numLabel];
    _numLabel.textColor=[UIColor grayColor];
    _numLabel.textAlignment=2;
    _numLabel.font=[regular getFont:12.0f];
    _numLabel.text=[[NSString alloc] initWithFormat:@"还可选择%ld款",_num-_circleModel.chooseItem.count];
    
    [leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(@150);
        make.height.mas_equalTo(@20);
    }];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(leftlabel);
        make.height.mas_equalTo(leftlabel);
    }];
}
-(void)UpdateImgView
{
    for (UIButton *btn in btnArr) {
        [btn removeFromSuperview];
    }
    [self CreateImgView];
    _numLabel.text=[[NSString alloc] initWithFormat:@"还可选择%ld款",_num-_circleModel.chooseItem.count];
}
-(void)CreateImgView
{
    
    NSInteger _count=_circleModel.chooseItem.count;
    CGFloat _h=0;
    if(_circleModel.chooseItem.count)
    {
        _h=(_width+10)*(((_count-1)/4)+1)+20;
    }else
    {
        _h=40;
    }
    [_upView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_h);
    }];
    
    // 创建一个空view 代表上一个view
    __block UIView *lastView = nil;
    // 间距为10
    int intes = 10;
    // 每行4个
    int num = 4;
    // 循环创建view
    
    for (int i = 0; i < _circleModel.chooseItem.count; i++) {
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.tag=100+i;
        [_upView addSubview:view];
        
        
        DD_CricleChooseItemModel *item=[_circleModel.chooseItem objectAtIndex:i];
        [view sd_setImageWithURL:[NSURL URLWithString:[regular getImgUrl:item.pic WithSize:200]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headImg_login1"]];

        [view addTarget:self action:@selector(delectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //        view.backgroundColor = [UIColor colorWithHue:(arc4random() % 256 / 256.0 ) saturation:( arc4random() % 128 / 256.0 ) + 0.5
        //                                          brightness:( arc4random() % 128 / 256.0 ) + 0.5 alpha:0.2];
        
        // 添加约束
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            // 给个高度约束
            make.height.and.width.mas_equalTo(_width);
            // 2. 判断是否是第一列
            if (i % num == 0) {
                // 一：是第一列时 添加左侧与父视图左侧约束
                make.left.mas_equalTo(view.superview).offset(intes);
            } else {
                // 二： 不是第一列时 添加左侧与上个view左侧约束
                make.left.mas_equalTo(lastView.mas_right).offset(intes);
            }
            // 3. 判断是否是最后一列 给最后一列添加与父视图右边约束
            if (i % num == (num - 1)) {
                make.right.mas_equalTo(view.superview).offset(-intes);
            }
            // 4. 判断是否为第一列
            if (i / num == 0) {
                // 第一列添加顶部约束
                make.top.mas_equalTo(view.superview).offset(20);
            } else {
                // 其余添加顶部约束 intes*10 是我留出的距顶部高度
                make.top.mas_equalTo(20 + ( i / num )* (_width + intes));
            }
        }];
        // 每次循环结束 此次的View为下次约束的基准
        lastView = view;
        [btnArr addObject:view];
    }
    if(lastView)
    {
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
        }];
    }
}

-(void)CreateDownView
{
    [self initDownView];
    [self CreateTableView];
    [self MJRefresh];
}
-(void)initDownView
{
    _downView=[[UIView alloc] init];
    [self.view addSubview:_downView];
    _downView.backgroundColor=[UIColor whiteColor];
    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(ScreenWidth);
        make.top.mas_equalTo(_upView.mas_bottom).with.offset(20);
        make.bottom.mas_equalTo(self.view).with.mas_equalTo(-20);
    }];
    
    _screeningBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_downView addSubview:_screeningBtn];
    [_screeningBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if([categoryCode isEqualToString:@""])
    {
        [_screeningBtn setTitle:@"所有的" forState:UIControlStateNormal];
    }
    [_screeningBtn addTarget:self action:@selector(screenAction) forControlEvents:UIControlEventTouchUpInside];
    _screeningBtn.titleLabel.font=[regular getFont:13.0f];
    [_screeningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.mas_equalTo(0);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@100);
    }];
}

-(void)CreateChooseTableView
{
    _isShow=YES;
    _chooseTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_downView addSubview:_chooseTableView];
    //    消除分割线
        _tableView.backgroundColor=_define_backview_color;
    _chooseTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _chooseTableView.delegate=self;
    _chooseTableView.dataSource=self;
    
    [_chooseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_screeningBtn.mas_bottom).with.offset(0);
        if((_categoryArr.count)*32<200)
        {
            make.height.mas_equalTo(@((_categoryArr.count)*32));
        }else
        {
            make.height.mas_equalTo(@200);
        }
        
        make.width.mas_equalTo(_screeningBtn);
        make.right.mas_equalTo(0);
    }];
    
}
-(void)CreateTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_downView addSubview:_tableView];
    //    消除分割线
    _tableView.backgroundColor=_define_backview_color;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_screeningBtn.mas_bottom).with.offset(10);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
    }];
}

#pragma mark - RequestData
-(void)RequestData
{

    NSDictionary *_parameters=@{@"itemName":itemName,@"categoryCode":categoryCode,@"page":[NSNumber numberWithLong:_page],@"token":[DD_UserModel getToken]};
    [[JX_AFNetworking alloc] GET:@"share/queryShareItems.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            if(_page==1)
            {
                [_dataArr removeAllObjects];//删除所有数据
            }
            NSArray *getarr=[DD_CricleChooseItemModel getItemsModelArr:[data objectForKey:@"items"] WithDetail:_circleModel.chooseItem];
            [_dataArr addObjectsFromArray:getarr];
            [_tableView reloadData];
        }else
        {
            if(_page==1)
            {
                [_dataArr removeAllObjects];//删除所有数据
            }
            [_tableView reloadData];
            [self presentViewController:successAlert animated:YES completion:nil];
        }
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}
#pragma mark - SomeAction
-(void)MJRefresh
{
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _page=1;
        [self RequestData];
    }];
    
    _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _page+=1;
        [self RequestData];
    }];
    
    [_tableView.header beginRefreshing];
}
/**
 * 删除已选款式
 */
-(void)delectAction:(UIButton *)btn
{
    _block(@"delete_choose_item",btn.tag-100);
    [self UpdateImgView];
    [_tableView reloadData];
}
/**
 * 选择款式
 */
-(void)screenAction
{
    if(_isShow)
    {
        [_chooseTableView removeFromSuperview];
        [_categoryArr removeAllObjects];
        _page=1;
        _isShow=NO;
    }else
    {
        [[JX_AFNetworking alloc] GET:@"share/queryCategory.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                [_categoryArr addObjectsFromArray:[DD_CricleCategoryModel getCricleCategoryModelArr:[data objectForKey:@"category"]]];
                DD_CricleCategoryModel *_categoryModel=[DD_CricleCategoryModel getInitModel];
                [_categoryArr insertObject:_categoryModel atIndex:0];
                [self CreateChooseTableView];
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }
    
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_tableView)
    {
        return 80;
    }
    return 30;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==_tableView)
    {
        return _dataArr.count;
    }
    return _categoryArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(tableView==_tableView)
    {
        //    数据还未获取时候
        if(_dataArr.count==indexPath.section)
        {
            static NSString *cellid=@"cellid";
            UITableViewCell *cell=[_tableView dequeueReusableCellWithIdentifier:cellid];
            if(!cell)
            {
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        static NSString *CellIdentifier = @"cell_dday";
        BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([DD_CricleChooseCell class]) bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
            nibsRegistered = YES;
        }
        DD_CricleChooseCell *cell = (DD_CricleChooseCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.block=cellblock;
        
        DD_CricleChooseItemModel *itemModel=[_dataArr objectAtIndex:indexPath.section];
        cell.itemModel=itemModel;
        cell.index=indexPath.section;
        return cell;
    }
    
    //    数据还未获取时候
    if(_categoryArr.count==indexPath.section)
    {
        static NSString *cellid=@"cellid";
        UITableViewCell *cell=[_tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    static NSString *cellid=@"cellCricle";
    UITableViewCell *cell=[_tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    DD_CricleCategoryModel *_categoryModel=[_categoryArr objectAtIndex:indexPath.section];
    cell.textLabel.text=_categoryModel.name;
    cell.textLabel.textAlignment=1;
    cell.textLabel.font=[regular getFont:13.0f];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_tableView)
    {
        DD_CricleChooseItemModel *_itemModel=[_dataArr objectAtIndex:indexPath.section];
        DD_ItemsModel *_item=[[DD_ItemsModel alloc] init];
        _item.g_id=_itemModel.g_id;
        _item.colorId=_itemModel.colorId;
        DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:_item WithBlock:^(DD_ItemsModel *model, NSString *type) {
            //        if(type)
        }];
        [self.navigationController pushViewController:_GoodsDetail animated:YES];
    }else
    {
        _page=1;
        _isShow=NO;
        DD_CricleCategoryModel *_categoryModel=[_categoryArr objectAtIndex:indexPath.section];
        categoryCode=_categoryModel.code;
        [_screeningBtn setTitle:_categoryModel.name forState:UIControlStateNormal];
        [_tableView.header beginRefreshing];
        [_chooseTableView removeFromSuperview];
        [_categoryArr removeAllObjects];
    }
    
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 1;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] init];
    if(tableView==_tableView)
    {
        view.frame=CGRectMake(0, 0, ScreenWidth, 1);
    }else
    {
        view.frame=CGRectMake(0, 0, 100, 1);
    }
    view.backgroundColor = _define_backview_color;
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;//section头部高度
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    if(tableView==_tableView)
    {
        view.frame=CGRectMake(0, 0, ScreenWidth, 1);
    }else
    {
        view.frame=CGRectMake(0, 0, 100, 1);
    }
    view.backgroundColor = _define_backview_color;
    return view;
}

#pragma mark - Others
-(void)viewWillDisappear:(BOOL)animated
{
    _block(@"choose_item",0);
    [super viewWillDisappear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
