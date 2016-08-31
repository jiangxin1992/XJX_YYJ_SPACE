//
//  DD_DesignerCell.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DesignerCell.h"

#import "DD_ImageModel.h"

@implementation DD_DesignerCell
{
    UIImageView *_head;
    UIImageView *_brand;
    UIButton *_followBtn;
    UILabel *_name_label;
    UILabel *_brand_label;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self UIConfig];
    }
    return  self;
}
-(void)UIConfig
{
    _head=[UIImageView getCustomImg];
    [self.contentView addSubview:_head];
    _head.contentMode=0;
    [_head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(17);
        make.width.height.mas_equalTo(50);
    }];
    
    _brand=[UIImageView getCustomImg];
    [self.contentView addSubview:_brand];
    [_brand mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_head.mas_right).with.offset(17);
        make.top.mas_equalTo(_head);
        make.width.height.mas_equalTo(50);
    }];
    
    _followBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"关注" WithNormalColor:_define_white_color WithSelectedTitle:@"已关注" WithSelectedColor:_define_black_color];
    [self.contentView addSubview:_followBtn];
    [_followBtn addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
    [regular setBorder:_followBtn];
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(25);
        make.centerY.mas_equalTo(_brand);
    }];
    
    _name_label=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_name_label];
    [_name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_brand.mas_right).with.offset(9);
        make.top.mas_equalTo(_head);
        make.right.mas_equalTo(_followBtn.mas_left).with.offset(-9);
        make.height.mas_equalTo(25);
    }];
    
    _brand_label=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_brand_label];
    [_brand_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_brand.mas_right).with.offset(9);
        make.top.mas_equalTo(_name_label.mas_bottom).with.offset(0);
        make.right.mas_equalTo(_followBtn.mas_left).with.offset(-9);
        make.height.mas_equalTo(25);
    }];
    
    _scrollview=[[UIScrollView alloc] init];
    [self.contentView addSubview:_scrollview];
    _scrollview.alwaysBounceHorizontal=YES;
    _scrollview.alwaysBounceVertical=NO;
    _scrollview.showsHorizontalScrollIndicator=NO;
    _scrollview.scrollEnabled=YES;
    [_scrollview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)]];
    [_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(_head.mas_bottom).with.offset(17);
        make.height.mas_equalTo(236);
    }];
    
}
+ (CGFloat)heightWithModel:(DD_DesignerModel *)model{
    DD_DesignerCell *cell = [[DD_DesignerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.Designer=model;
    [cell.contentView layoutIfNeeded];
    CGRect frame =  cell.scrollview.frame;
    return frame.origin.y + frame.size.height+33;
}
-(void)setDesigner:(DD_DesignerModel *)Designer
{
    DD_UserModel *_userModel=[DD_UserModel getLocalUserInfo];
    
    if([Designer.designerId isEqualToString:_userModel.u_id])
    {
        _followBtn.hidden=YES;
    }else
    {
        _followBtn.hidden=NO;
        if(Designer.guanzhu)
        {
            _followBtn.selected=YES;
            _followBtn.backgroundColor=_define_white_color;
        }else
        {
            _followBtn.selected=NO;
            _followBtn.backgroundColor=_define_black_color;
        }
    }
    
    [_head JX_ScaleToFill_loadImageUrlStr:Designer.head WithSize:400 placeHolderImageName:nil radius:0 ];
    [_brand JX_ScaleAspectFit_loadImageUrlStr:Designer.brandIcon WithSize:400 placeHolderImageName:nil radius:0];
    
    _name_label.text=Designer.name;
    _brand_label.text=Designer.brandName;
    
    for (UIView *view in _scrollview.subviews) {
        [view removeFromSuperview];
    }
    if(Designer.items.count)
    {
        [_scrollview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(236);
        }];
        CGFloat _x_p=0;
        for (int i=0; i<Designer.items.count; i++) {
            DD_ImageModel *imgModel=[Designer.items objectAtIndex:i];
            NSString *imgStr=imgModel.pic;
            UIImageView *img=[UIImageView getCustomImg];
            [_scrollview addSubview:img];
            img.contentMode=0;
            [img JX_ScaleToFill_loadImageUrlStr:imgStr WithSize:800 placeHolderImageName:nil radius:0];
            CGFloat _width=([imgModel.width floatValue]/[imgModel.height floatValue])*236;
            img.frame=CGRectMake(_x_p, 0, _width, 236);
            if(i<Designer.items.count-1)
            {
                _x_p+=17+_width;
            }else
            {
                _x_p+=_width;
            }
        }
        _scrollview.contentSize=CGSizeMake(_x_p,CGRectGetHeight(_scrollview.frame));
        
    }else
    {
        [_scrollview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        _scrollview.contentSize=CGSizeMake(0,CGRectGetHeight(_scrollview.frame));
    }
}
-(void)clickAction
{
    _followblock(_index,@"click");
}
-(void)followAction:(UIButton *)btn
{
    if(btn.selected)
    {
        _followblock(_index,@"unfollow");
    }else
    {
        _followblock(_index,@"follow");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
