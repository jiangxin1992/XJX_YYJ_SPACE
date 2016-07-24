//
//  DD_CricleChooseCell.m
//  DDAY
//
//  Created by yyj on 16/6/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CricleChooseCell.h"

@implementation DD_CricleChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
#pragma mark - setter
-(void)setItemModel:(DD_CricleChooseItemModel *)itemModel
{
    _itemModel=itemModel;
    _TitleLabel.text=_itemModel.name;
    [_ImgView JX_loadImageUrlStr:_itemModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    _selectBtn.selected=_itemModel.isSelect;
}
#pragma mark - SomeAction
- (IBAction)selectAction:(id)sender {
    
    if(_selectBtn.selected)
    {
        _block(@"delItem",_index);
        _itemModel.isSelect=NO;
        _selectBtn.selected=NO;
    }else
    {
        _block(@"addItem",_index);
        _itemModel.isSelect=YES;
        _selectBtn.selected=YES;
    }
}
#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
