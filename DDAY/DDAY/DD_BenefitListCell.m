//
//  DD_BenefitListCell.m
//  YCO SPACE
//
//  Created by yyj on 2016/10/31.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BenefitListCell.h"

#import "DD_ImageModel.h"
#import "DD_BenefitInfoModel.h"

#define BenefitListCellRedColor [UIColor colorWithHexString:@"#cd0303"]
#define BenefitListCellGrayColor [UIColor colorWithHexString:@"#afafaf"]

@implementation DD_BenefitListCell
{
    UIView *_backView;
    UILabel *_benefitTitleLabel;
    UILabel *_isFitLabel;
    UILabel *_validityLabel;
    
    UIImageView *_benefitImg;
    UILabel *_benefitAmountLabel;
    UILabel *_isEffectLabel;
    UILabel *_benefitDesLabel;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
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
    _backView=[UIView getCustomViewWithColor:nil];
    [self.contentView addSubview:_backView];
    _backView.layer.masksToBounds=YES;
    _backView.layer.cornerRadius=10;
    _backView.layer.borderColor=[BenefitListCellGrayColor CGColor];
    _backView.layer.borderWidth=2;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
    }];

    _benefitImg=[UIImageView getImgWithImageStr:@"User_BenefitList_Gray"];
    [_backView addSubview:_benefitImg];
    _benefitImg.contentMode=UIViewContentModeScaleToFill;
    [_benefitImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-16);
        make.width.mas_equalTo(60);
    }];
    
    _isEffectLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:12.0f WithTextColor:_define_white_color WithSpacing:0];
    [_benefitImg addSubview:_isEffectLabel];
    
    _benefitAmountLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:33.0f WithTextColor:_define_white_color WithSpacing:0];
    [_benefitImg addSubview:_benefitAmountLabel];
    _benefitAmountLabel.font=[UIFont fontWithName:@"DIN-Medium" size:33.0f];
    
    _benefitDesLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:9.0f WithTextColor:_define_white_color WithSpacing:0];
    [_benefitImg addSubview:_benefitDesLabel];
    
    _benefitTitleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:16.0f WithTextColor:BenefitListCellGrayColor WithSpacing:0];
    [_backView addSubview:_benefitTitleLabel];
    _benefitTitleLabel.font=[regular getSemiboldFont:16.0f];
    [_benefitTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(19);
        make.right.mas_equalTo(_benefitImg.mas_left).with.offset(0);
    }];
    
    _isFitLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:BenefitListCellGrayColor WithSpacing:0];
    [_backView addSubview:_isFitLabel];
    [_isFitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(_benefitTitleLabel.mas_bottom).with.offset(11);
        make.right.mas_equalTo(_benefitImg.mas_left).with.offset(0);
    }];
    
    _validityLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:BenefitListCellGrayColor WithSpacing:0];
    [_backView addSubview:_validityLabel];
    [_validityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(_isFitLabel.mas_bottom).with.offset(4);
        make.right.mas_equalTo(_benefitImg.mas_left).with.offset(0);
    }];
    
}

-(void)setBenefitInfoModel:(DD_BenefitInfoModel *)benefitInfoModel
{
    _benefitInfoModel=benefitInfoModel;
    BOOL _is_effect=YES;
    if(_benefitInfoModel.effectEndTime<[NSDate nowTime])
    {
        _is_effect=NO;
    }
    
    if(_is_effect)
    {
        //有效地
        _backView.layer.borderColor=[BenefitListCellRedColor CGColor];
        _benefitTitleLabel.textColor=BenefitListCellRedColor;
        _benefitImg.image=[UIImage imageNamed:@"User_BenefitList_Red"];
        _isEffectLabel.text=@"";
        if([NSString isNilOrEmpty:_benefitInfoModel.lowLimitDesc])
        {
            _benefitDesLabel.text=@"";
        }else
        {
            _benefitDesLabel.text=_benefitInfoModel.lowLimitDesc;
        }

        [_benefitAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo((84-[regular getHeightWithWidth:9999 WithContent:@"50" WithFont:[regular get_en_Font:33.0f]])/2.0f);
        }];
        
        [_benefitDesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_benefitAmountLabel.mas_bottom).with.offset(2);
            make.left.right.mas_equalTo(0);
        }];
        
    }else
    {
        //无效的
        _backView.layer.borderColor=[BenefitListCellGrayColor CGColor];
        _benefitTitleLabel.textColor=BenefitListCellGrayColor;
        _benefitImg.image=[UIImage imageNamed:@"User_BenefitList_Gray"];
        _isEffectLabel.text=@"已失效";
        [_isEffectLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.right.mas_equalTo(0);
        }];
        if([NSString isNilOrEmpty:_benefitInfoModel.lowLimitDesc])
        {
            //没有
            [_benefitAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo((84-[regular getHeightWithWidth:9999 WithContent:@"50" WithFont:[regular get_en_Font:33.0f]])/2.0f);
            }];
            _benefitDesLabel.text=@"";
        }else
        {
            //有
            [_benefitAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo((84-[regular getHeightWithWidth:9999 WithContent:@"50" WithFont:[regular get_en_Font:33.0f]])/2.0f);
            }];
            _benefitDesLabel.text=_benefitInfoModel.lowLimitDesc;
            
        }
        [_benefitDesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_benefitAmountLabel.mas_bottom).with.offset(2);
            make.left.right.mas_equalTo(0);
        }];
    }
    _benefitTitleLabel.text=_benefitInfoModel.name;
    _isFitLabel.text=@"所有品牌适用";
    _validityLabel.text=[[NSString alloc] initWithFormat:@"使用期限：%@-%@",[regular getTimeStr:_benefitInfoModel.effectStartTime WithFormatter:@"YYYY.MM.dd"],[regular getTimeStr:_benefitInfoModel.effectEndTime WithFormatter:@"YYYY.MM.dd"]];
    _benefitAmountLabel.text=[[NSString alloc] initWithFormat:@"%ld",_benefitInfoModel.amount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
