//
//  DD_GoodsListTableView.m
//  YCO SPACE
//
//  Created by yyj on 16/8/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsListTableView.h"

#import "DD_GoodsListTableViewCell.h"
#import "DD_GoodsListBtn.h"

#import "DD_GoodsCategoryModel.h"

@interface DD_GoodsListTableView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DD_GoodsListTableView
{
    NSMutableArray *_btnArr;
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style WithBlock:(void (^)(NSString *type,NSString *categoryName,NSString *categoryID))block
{
    self=[super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.delegate=self;
        self.dataSource=self;
        self.block=block;
        _btnArr=[[NSMutableArray alloc] init];
        _categoryArr=[[NSArray alloc] init];
    }
    return self;
}
-(void)setCategoryArr:(NSArray *)categoryArr
{
    if(_categoryArr!=categoryArr)
    {
        _categoryArr=categoryArr;
        [self setupBtn];
        [self reloadData];
    }
}
-(void)setupBtn
{
    for (int i=0; i<_categoryArr.count; i++) {
        DD_GoodsCategoryModel *_categoryModel=[_categoryArr objectAtIndex:i];
        DD_GoodsListBtn *listBtn=[DD_GoodsListBtn buttonWithType:UIButtonTypeCustom];
        [listBtn setFrame:CGRectMake(0, 0, ScreenWidth, 50) WithIndex:i WithCategoryModel:_categoryModel WithBlock:^(NSString *type, NSInteger index) {
            
            if([type isEqualToString:@"show"])
            {
                [self btnIsFade:NO WithIndex:index];
                
            }else if([type isEqualToString:@"fade"])
            {
                [self btnIsFade:YES WithIndex:index];
            }else if([type isEqualToString:@"click"])
            {
                DD_GoodsCategoryModel *CategoryModel=[_categoryArr objectAtIndex:index];
                _block(type,CategoryModel.catOneName,@"");
            }else if([type isEqualToString:@"all"])
            {
                _block(type,@"",@"");
            }
            
        }];
        [_btnArr addObject:listBtn];
        listBtn.tag=200+i;
    }
 
}
-(void)btnIsFade:(BOOL )isFade WithIndex:(NSInteger )index
{
    DD_GoodsListBtn *__btn=[_btnArr objectAtIndex:index];
    if (isFade) {
        __btn.selected=NO;
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
        [self reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    }else
    {
        
        __btn.selected=YES;
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
        [self reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_categoryArr.count)
    {
        DD_GoodsListBtn *_btn=[_btnArr objectAtIndex:section];
        
        DD_GoodsCategoryModel *_categoryModel=[_categoryArr objectAtIndex:section];
        
        if(_btn.selected==NO)
        {
            return 0;
        }
        return _categoryModel.catTwoList.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    数据还未获取时候
    if(_categoryArr.count==indexPath.section)
    {
        static NSString *cellid=@"cellid";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *cellIdentifier = @"CellIdentifier";
    DD_GoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[DD_GoodsListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
    }
    DD_GoodsCategoryModel *_categoryModel=[_categoryArr objectAtIndex:indexPath.section];
    DD_GoodsCategorySubModel *_categorySubModel=[_categoryModel.catTwoList objectAtIndex:indexPath.row];
    cell.CategoryModel=_categorySubModel;    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DD_GoodsCategoryModel *_categoryModel=[_categoryArr objectAtIndex:indexPath.section];
    DD_GoodsCategorySubModel *_categorySubModel=[_categoryModel.catTwoList objectAtIndex:indexPath.row];
    _block(@"click",_categorySubModel.catTwoName,_categorySubModel.catTwoId);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(_categoryArr.count)
    {
        return [_btnArr objectAtIndex:section];
    }
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_categoryArr.count)
    {
        return _categoryArr.count;
    }
    return 0;
}


@end
