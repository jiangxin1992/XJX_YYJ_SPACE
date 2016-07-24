//
//  DD_ShopCell.m
//  DDAY
//
//  Created by yyj on 16/5/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShopCell.h"

@implementation DD_ShopCell
{
    UIButton *selectBtn;
    UIImageView *itemImg;
    UIView *backView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellForRowAtIndexPath:(NSIndexPath *)indexPath WithIsInvalid:(BOOL)isInvalid WithBlock:(void(^)(NSString *type,NSIndexPath *indexPath))block
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _isInvalid=isInvalid;
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
    if(_isInvalid)
    {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
        [itemImg addSubview:label];
        label.backgroundColor=[UIColor grayColor];
        label.textColor=[UIColor whiteColor];
        label.textAlignment=1;
        label.font=[regular getFont:11.0f];
        label.alpha=0.7;
        label.text=@"失效";
    }
    
//    款式信息
    CGFloat _height=30;
    for (int i=0; i<5; i++) {
        CGFloat _x_p=i==4?310:210;
        CGFloat _width=i==4?55:i==3?100:155;
        CGFloat _y_p=i==4?(9+90):9+30*i;
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(_x_p, _y_p, _width, _height)];
        label.tag=100+i;
        [backView addSubview:label];
        label.textAlignment=i==4?2:0;
        if(_isInvalid)
        {
            label.textColor=[UIColor lightGrayColor];
        }else
        {
            label.textColor=[UIColor blackColor];
        }
        
    }
}
#pragma mark - Setter
-(void)setItemModel:(DD_ShopItemModel *)ItemModel
{
    _ItemModel=ItemModel;
    
    selectBtn.selected=ItemModel.is_select;
    
    if(ItemModel.pics.count)
    {
        [itemImg JX_loadImageUrlStr:[ItemModel.pics objectAtIndex:0] WithSize:800 placeHolderImageName:nil radius:0];
    }
    UILabel *brandNameLabel=[backView viewWithTag:100];
    brandNameLabel.text=ItemModel.brandName;
    
    UILabel *itemNameLabel=[backView viewWithTag:101];
    itemNameLabel.text=ItemModel.itemName;
    
    UILabel *sizeNameLabel=[backView viewWithTag:102];
    sizeNameLabel.text=ItemModel.sizeName;
    
    UILabel *priceLabel=[backView viewWithTag:103];
    if(ItemModel.saleEndTime>[regular date])
    {
        priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@ 原价￥%@",ItemModel.price,ItemModel.originalPrice];
    }else
    {
        if(ItemModel.discountEnable)
        {
            priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@ 原价￥%@",ItemModel.price,ItemModel.originalPrice];
            
        }else
        {
            priceLabel.text=[[NSString alloc] initWithFormat:@"￥%@",ItemModel.originalPrice];
        }
        
    }
    UILabel *numLabel=[backView viewWithTag:104];
    numLabel.text=[[NSString alloc] initWithFormat:@"×%@",ItemModel.number];
    
}
#pragma mark - SomeAction
-(void)chooseAction
{
    if(!_isInvalid)
    {
        if(selectBtn.selected)
        {
            selectBtn.selected=NO;
            _clickblock(@"cancel",_indexPath);
        }else
        {
            selectBtn.selected=YES;
            _clickblock(@"select",_indexPath);
        }
    }
}
#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
