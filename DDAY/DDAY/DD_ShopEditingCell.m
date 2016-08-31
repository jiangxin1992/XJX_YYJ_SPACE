//
//  DD_ShopEditingCell.m
//  DDAY
//
//  Created by yyj on 16/5/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShopEditingCell.h"

#import "DD_ShopTool.h"

@implementation DD_ShopEditingCell
{
    NSInteger _cell_num;
    UIButton *selectBtn;
    UIImageView *itemImg;
    UIView *backView;
    UIButton *sizeNameBtn;
    UILabel *priceLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellForRowAtIndexPath:(NSIndexPath *)indexPath WithBlock:(void(^)(NSString *type,NSIndexPath *indexPath,DD_ShopModel *shopModel))block
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _indexPath=indexPath;
        _clickblock=block;
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
-(void)PrepareData{}
-(void)PrepareUI{}
#pragma mark - UIConfig
-(void)UIConfig
{
    
    backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 138)];
    [self.contentView addSubview:backView];
    backView.backgroundColor=[UIColor whiteColor];
    
    //    勾选框
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:selectBtn];
    selectBtn.frame=CGRectMake(0, 0, 70, 138);
    [selectBtn addTarget:self action:@selector(chooseAction) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.titleLabel.font=[regular getFont:14.0f];
    [selectBtn setTitle:@"未选中" forState:UIControlStateNormal];
    [selectBtn setTitle:@"选中" forState:UIControlStateSelected];
    [selectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    //    款式照片
    itemImg=[[UIImageView alloc] initWithFrame:CGRectMake(80, 9, 120, 120)];
    [backView addSubview:itemImg];
    itemImg.contentMode=2;
    [regular setZeroBorder:itemImg];
    
    sizeNameBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:sizeNameBtn];
    [sizeNameBtn addTarget:self action:@selector(chooseSize) forControlEvents:UIControlEventTouchUpInside];
    sizeNameBtn.frame=CGRectMake(210, 9, ScreenWidth-220, 30);
    [sizeNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sizeNameBtn.backgroundColor=_define_backview_color;
    [regular setBorder:sizeNameBtn];
    
    CGFloat _x_p=210;
    for (int i=0; i<3; i++) {
        CGFloat _width=i==1?CGRectGetWidth(sizeNameBtn.frame)-30*2-10:30;
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(_x_p, CGRectGetMaxY(sizeNameBtn.frame)+15, _width, 30);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _x_p+=_width+5;
        if(i==1)
        {
            btn.backgroundColor=[UIColor whiteColor];
            [regular setBorder:btn];
            btn.tag=100;
        }else
        {
            [btn setTitle:i==0?@"-":@"+" forState:UIControlStateNormal];
            btn.backgroundColor=_define_backview_color;
            if(i==0)
            {
                [btn addTarget:self action:@selector(cutAction) forControlEvents:UIControlEventTouchUpInside];
            }else
            {
                [btn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        [backView addSubview:btn];
    }
    
    priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(210, 9+30*2+15*2, ScreenWidth-220, 30)];
    [backView addSubview:priceLabel];
    priceLabel.textAlignment=0;
    priceLabel.textColor=[UIColor blackColor];
}
#pragma mark - setter
-(void)setItemModel:(DD_ShopItemModel *)ItemModel
{
    _ItemModel=ItemModel;
    _cell_num=[_ItemModel.number integerValue];
    selectBtn.selected=_ItemModel.is_select;
    
    if(_ItemModel.pics.count)
    {
        [itemImg JX_ScaleAspectFill_loadImageUrlStr:[_ItemModel.pics objectAtIndex:0] WithSize:800 placeHolderImageName:nil radius:0];
    }
    
    if(_ItemModel.saleEndTime>[regular date])
    {
        priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@ 原价￥%@",_ItemModel.price,_ItemModel.originalPrice];
    }else
    {
        if(ItemModel.discountEnable)
        {
            priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@ 原价￥%@",_ItemModel.price,_ItemModel.originalPrice];
            
        }else
        {
            priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@",_ItemModel.originalPrice];
        }
        
    }
    
    [sizeNameBtn setTitle:_ItemModel.sizeName forState:UIControlStateNormal];
    
    UIButton *num_btn=[backView viewWithTag:100];
    [num_btn setTitle:_ItemModel.number forState:UIControlStateNormal];
}
#pragma mark - SomeActions
//选择尺寸
-(void)chooseSize
{
    _clickblock(@"choose_size",_indexPath,_shopModel);
}
//加
-(void)addAction
{
    _cell_num++;
    UIButton *num_btn=[backView viewWithTag:100];
    [num_btn setTitle:[[NSString alloc] initWithFormat:@"%ld",_cell_num] forState:UIControlStateNormal];
    _ItemModel.number=[[NSString alloc] initWithFormat:@"%ld",_cell_num];
    [DD_ShopTool setItemModelWithIndexPath:_indexPath WithModel:_shopModel WithItemModel:_ItemModel];
    _clickblock(@"add",_indexPath,_shopModel);
}
//减
-(void)cutAction
{
    if(_cell_num==1)
    {
        _clickblock(@"cut_no",_indexPath,_shopModel);
    }else
    {
        _cell_num--;
        UIButton *num_btn=[backView viewWithTag:100];
        [num_btn setTitle:[[NSString alloc] initWithFormat:@"%ld",_cell_num] forState:UIControlStateNormal];
        _ItemModel.number=[[NSString alloc] initWithFormat:@"%ld",_cell_num];
        [DD_ShopTool setItemModelWithIndexPath:_indexPath WithModel:_shopModel WithItemModel:_ItemModel];
        _clickblock(@"cut",_indexPath,_shopModel);
    }
}
/**
 * 选择取消
 */
-(void)chooseAction
{
    if(selectBtn.selected)
    {
        selectBtn.selected=NO;
        _clickblock(@"cancel",_indexPath,_shopModel);
    }else
    {
        selectBtn.selected=YES;
        _clickblock(@"select",_indexPath,_shopModel);
    }
}
#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
