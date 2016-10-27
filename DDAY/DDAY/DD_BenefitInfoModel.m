//
//  DD_BenefitInfoModel.m
//  YCO SPACE
//
//  Created by yyj on 2016/10/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BenefitInfoModel.h"

@implementation DD_BenefitInfoModel
+(DD_BenefitInfoModel *)getBenefitInfoModel:(NSDictionary *)dict
{
    DD_BenefitInfoModel *_BenefitInfoModel=[DD_BenefitInfoModel mj_objectWithKeyValues:dict];
    return _BenefitInfoModel;
}
+(NSArray *)getBenefitInfoModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [itemsArr addObject:[self getBenefitInfoModel:dict]];
    }
    return itemsArr;
}
@end
