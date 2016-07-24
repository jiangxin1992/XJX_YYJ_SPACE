//
//  DD_ClearingTableViewCell.m
//  DDAY
//
//  Created by yyj on 16/5/18.
//  Copyright © 2016年 mike_xie. All rights reserved.
//

#import "DD_ClearingTableViewCell.h"

@implementation DD_ClearingTableViewCell
{
    UIView *__contentview;
    UIImageView *itemimg;
    UILabel *brandName;
    UILabel *itemName;
    UILabel *sizeName;
    UILabel *priceName;
    UILabel *itemNum;
}

- (void)awakeFromNib {
    // Initialization code
}
#pragma mark - 初始化
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type))block
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
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
-(void)PrepareUI
{
    self.backgroundColor=[UIColor clearColor];
    self.contentView.backgroundColor=[UIColor clearColor];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    __contentview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 138)];
    __contentview.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:__contentview];
    
    itemimg=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 120)];
    [__contentview addSubview:itemimg];
    
    brandName=[[UILabel alloc] initWithFrame:CGRectMake(140, 10, 180, 30)];
    brandName.textAlignment=0;
    brandName.textColor=[UIColor blackColor];
    [__contentview addSubview:brandName];
    
    itemName=[[UILabel alloc] initWithFrame:CGRectMake(140, 40, 180, 30)];
    itemName.textAlignment=0;
    itemName.textColor=[UIColor blackColor];
    [__contentview addSubview:itemName];
    
    sizeName=[[UILabel alloc] initWithFrame:CGRectMake(140, 70, 180, 30)];
    sizeName.textAlignment=0;
    sizeName.textColor=[UIColor blackColor];
    [__contentview addSubview:sizeName];
    
    priceName=[[UILabel alloc] initWithFrame:CGRectMake(140, 100, 180, 30)];
    priceName.textAlignment=0;
    priceName.textColor=[UIColor blackColor];
    [__contentview addSubview:priceName];
    
    
    itemNum=[[UILabel alloc] initWithFrame:CGRectMake(325, 100, 45, 30)];
    itemNum.textAlignment=0;
    itemNum.textColor=[UIColor blackColor];
    [__contentview addSubview:itemNum];
}
#pragma mark - Setter Model
-(void)setClearingModel:(DD_ClearingOrderModel *)ClearingModel
{
    _ClearingModel=ClearingModel;
    [itemimg JX_loadImageUrlStr:_ClearingModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    brandName.text=_ClearingModel.brandName;
    itemName.text=_ClearingModel.itemName;
    sizeName.text=_ClearingModel.sizeName;
//    根据传入时候的price 和 discountEnable判断当前的状态
    priceName.text=[_ClearingModel getPriceStr];
    itemNum.text=[[NSString alloc] initWithFormat:@"× %@",_ClearingModel.numbers];
}

#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
