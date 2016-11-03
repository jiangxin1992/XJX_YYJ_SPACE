//
//  DD_BenefitListCell.m
//  YCO SPACE
//
//  Created by yyj on 2016/10/31.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BenefitListCell.h"

@implementation DD_BenefitListCell
{
    UIImageView *_benefit_img;
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
    _benefit_img=[UIImageView getCustomImg];
    [self.contentView addSubview:_benefit_img];
    [_benefit_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

-(void)setBenefitInfoModel:(DD_BenefitInfoModel *)benefitInfoModel
{
    _benefitInfoModel=benefitInfoModel;
    [_benefit_img JX_ScaleToFill_loadImageUrlStr:_benefitInfoModel.picInfo.pic WithSize:800 placeHolderImageName:nil radius:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
