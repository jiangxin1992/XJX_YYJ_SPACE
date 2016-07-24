//
//  DD_GoodsItemModel.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsItemModel.h"

@implementation DD_GoodsItemModel
-(NSString *)getSizeNameWithID:(NSString *)sizeID
{
    DD_SizeModel *_sizeModel=[self getSizeModelWithID:sizeID];
    if(_sizeModel)
    {
        return _sizeModel.sizeName;
    }
    return @"";
}
-(DD_SizeModel *)getSizeModelWithID:(NSString *)sizeID
{
    for (DD_ColorsModel *_colorModel in self.colors) {
        if([_colorModel.colorId isEqualToString:self.colorId])
        {
            for (DD_SizeModel *_sizeModel in _colorModel.size) {
                if([_sizeModel.sizeId isEqualToString:sizeID])
                {
                    return _sizeModel;
                }
            }
        }
    }
    return nil;
}
-(NSArray *)getPicsArr
{
    for (DD_ColorsModel *_colorModel in self.colors) {
        if([_colorModel.colorId isEqualToString:self.colorId])
        {
            return _colorModel.pics;
        }
    }
    return nil;
}

+(DD_GoodsItemModel *)getGoodsItemModel:(NSDictionary *)dict
{
    DD_GoodsItemModel *_GoodsItemModel=[DD_GoodsItemModel objectWithKeyValues:dict];
    _GoodsItemModel.saleEndTime=_GoodsItemModel.saleEndTime/1000;
    _GoodsItemModel.saleStartTime=_GoodsItemModel.saleStartTime/1000;
    _GoodsItemModel.signEndTime=_GoodsItemModel.signEndTime/1000;
    _GoodsItemModel.signStartTime=_GoodsItemModel.signStartTime/1000;

    _GoodsItemModel.colors=[DD_ColorsModel getColorsModelArr:[dict objectForKey:@"colors"]];
    _GoodsItemModel.otherItems=[DD_OtherItemModel getOtherItemModelArr:[dict objectForKey:@"otherItems"]];
    
    _GoodsItemModel.series=[DD_GoodSeriesModel getGoodSeriesModel:[dict objectForKey:@"series"]];
    [self TextData:_GoodsItemModel];
    return _GoodsItemModel;
}
+(void)TextData:(DD_GoodsItemModel *)_GoodsItemModel
{
    _GoodsItemModel.itemBrief=@"改革开放，是1978年12月十一届三中全会起中国开始实行的对内改革、对外开放的政策。中国的对内改革首先从农村开始，1978年11月，安徽省凤阳县小岗村开始实行“农村家庭联产承包责任制”，拉开了中国对内改革的大幕；对外开放是中国的一项基本国策，中国的强国之路，是社会主义事业发展的强大动力。改革开放建立了社会主义市场经济体制。1992年南巡讲话发布中国改革进入了新的阶段。改革开放使中国发生了巨大的变化。1992年10月召开的党的十四大宣布新时期最鲜明特点是改革开放，中国改革进入新的改革时期。2013年中国进入全面深化改革新时期。";
//    已结束
//    _GoodsItemModel.saleEndTime=[regular date]-3;
//    _GoodsItemModel.saleStartTime=[regular date]-6;
//    发布中
//    _GoodsItemModel.saleEndTime=[regular date]+3;
//    _GoodsItemModel.saleStartTime=[regular date];
}
+(NSArray *)getGoodsItemModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [itemsArr addObject:[self getGoodsItemModel:dict]];
    }
    return itemsArr;
}
@end
