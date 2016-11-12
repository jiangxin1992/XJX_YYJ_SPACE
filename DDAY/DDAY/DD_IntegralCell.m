//
//  DD_IntegralCell.m
//  YCO SPACE
//
//  Created by yyj on 2016/10/31.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_IntegralCell.h"

@implementation DD_IntegralCell{
    UILabel *_content_label;
    UILabel *_intergal_label;
    UILabel *_create_time_label;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self UIConfig];
    }
    return self;
}
-(void)UIConfig
{
    _intergal_label=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_intergal_label];
    [_intergal_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdge);
        make.bottom.mas_equalTo(self.contentView.mas_centerY).with.offset(-3);
    }];
    
    _content_label=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_content_label];
    [_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(_intergal_label.mas_right).with.offset(-5);
        make.bottom.mas_equalTo(self.contentView.mas_centerY).with.offset(-2);
    }];
    
    _create_time_label=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color WithSpacing:0];
    [self.contentView addSubview:_create_time_label];
    [_create_time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(self.contentView.mas_centerY).with.offset(3);
    }];
    
    UIView *line=[UIView getCustomViewWithColor:_define_black_color];
    [self.contentView addSubview:line];
    line.backgroundColor=_define_light_gray_color1;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.bottom).with.offset(0);

    }];
}

-(void)setIntegralModel:(DD_IntegralModel *)integralModel
{
    _integralModel=integralModel;
    if(_integralModel.type==1)
    {
        _intergal_label.textColor = _define_black_color;
        _content_label.textColor = _define_black_color;
        _create_time_label.textColor = _define_light_gray_color1;
        _intergal_label.text=_integralModel.pointStr;
        _content_label.text=_integralModel.tips;
        _create_time_label.text=_integralModel.createTime;
    }else if(_integralModel.type==2)
    {
        _intergal_label.textColor = _define_light_gray_color1;
        _content_label.textColor = _define_light_gray_color1;
        _create_time_label.textColor = _define_light_gray_color1;
        _intergal_label.text=@"";
        _content_label.text=_integralModel.tips;
        _create_time_label.text=@"";
    }else if(_integralModel.type==3)
    {
        _intergal_label.textColor = _define_light_gray_color1;
        _content_label.textColor = _define_light_gray_color1;
        _create_time_label.textColor = _define_light_gray_color1;
        _intergal_label.text=_integralModel.pointStr;
        _content_label.text=_integralModel.tips;
        _create_time_label.text=_integralModel.createTime;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
