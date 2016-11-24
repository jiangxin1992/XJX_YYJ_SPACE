//
//  DD_BenefitInfoModel.m
//  YCO SPACE
//
//  Created by yyj on 2016/10/27.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BenefitInfoModel.h"

#import "DD_ImageModel.h"

@implementation DD_BenefitInfoModel
+(DD_BenefitInfoModel *)getBenefitInfoModel:(NSDictionary *)dict
{
    DD_BenefitInfoModel *_BenefitInfoModel=[DD_BenefitInfoModel mj_objectWithKeyValues:dict];
    _BenefitInfoModel.effectStartTime=_BenefitInfoModel.effectStartTime/1000;
    _BenefitInfoModel.effectEndTime=_BenefitInfoModel.effectEndTime/1000;
    return _BenefitInfoModel;
}
+(NSArray *)getBenefitInfoModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [itemsArr addObject:[self getBenefitInfoModel:dict]];
    }
    return itemsArr;
//    return [self testdata];
}
+(NSArray *)testdata
{
    NSMutableArray *muArr=[[NSMutableArray alloc] init];
    for (int i=0; i<50 ; i++) {
        DD_BenefitInfoModel *model=[[DD_BenefitInfoModel alloc] init];
        model.amount=arc4random()%100+10;
        model.effectEndTime=[NSDate nowTime]-50000+arc4random()%100000;
        NSInteger _yu=arc4random()%2;
        model.lowLimitDesc=_yu?[[NSString alloc] initWithFormat:@"满%u元使用",arc4random()%2000]:@"";
        model.useRange=@"所有品牌适用";
        model.effectStartTime=1477909513;
        model.name=[[NSString alloc] initWithFormat:@"这是名字 %u",arc4random()%100];
        [muArr addObject:model];
    }
    return muArr;
}
@end
