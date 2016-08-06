//
//  DD_GoodsListBtn.m
//  YCO SPACE
//
//  Created by yyj on 16/8/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsListBtn.h"

@implementation DD_GoodsListBtn
{
    UIView *view;
}

-(void)setFrame:(CGRect)frame WithIndex:(NSInteger )index WithCategoryModel:(DD_GoodsCategoryModel *)categoryMode WithBlock:(void (^)(NSString *type,NSInteger index))block
{
    self.frame=frame;
    self.categoryMode=categoryMode;
    self.block=block;
    self.index=index;
    
    [self setTitleColor:_define_black_color forState:UIControlStateNormal];
    [self setTitleColor:_define_black_color forState:UIControlStateSelected];
    [self setTitle:_categoryMode.catOneName forState:UIControlStateNormal];
    [self setTitle:_categoryMode.catOneName forState:UIControlStateSelected];
    self.titleLabel.font=[regular getFont:13.0f];
    self.titleLabel.textAlignment = 0;
    [self addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    view=[UIView getCustomViewWithColor:_define_black_color];
    [self addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(5);
        make.left.mas_equalTo(kEdge);
        make.height.mas_equalTo(28);
        make.centerY.mas_equalTo(self);
    }];
    
    if(self.categoryMode.catTwoList.count)
    {
        UIButton *btn=[UIButton getCustomBtn];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(ClickAddAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"System_Add"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"System_Subtract"] forState:UIControlStateSelected];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kEdge);
            make.height.width.mas_equalTo(18);
            make.centerY.mas_equalTo(self);
        }];
        [btn setEnlargeEdge:20];
    }
}
-(void)BtnClick
{
    if(_categoryMode.isAll)
    {
        _block(@"all",_index);
    }else
    {
        _block(@"click",_index);
    }
}

-(void)ClickAddAction:(UIButton *)btn
{
    if(btn.selected)
    {
        btn.selected=NO;
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(5);
            make.left.mas_equalTo(kEdge);
            make.height.mas_equalTo(28);
            make.centerY.mas_equalTo(self);
        }];
        _block(@"fade",_index);
    }else
    {
        btn.selected=YES;
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(5);
            make.left.mas_equalTo(kEdge);
            make.height.mas_equalTo(self);
            make.centerY.mas_equalTo(self);
        }];
        _block(@"show",_index);
    }
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(53, 0 , 200, 50);
}

@end
