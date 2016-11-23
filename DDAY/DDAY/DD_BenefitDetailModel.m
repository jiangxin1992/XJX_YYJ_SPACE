//
//  DD_BenefitDetailModel.m
//  YCO SPACE
//
//  Created by yyj on 2016/11/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BenefitDetailModel.h"

#import "DD_ImageModel.h"

@implementation DD_BenefitDetailModel

+(DD_BenefitDetailModel *)getBenefitDetailInfoModel:(NSDictionary *)dict
{
    DD_BenefitDetailModel *_BenefitInfoModel=[DD_BenefitDetailModel mj_objectWithKeyValues:dict];
    return _BenefitInfoModel;
}

@end
