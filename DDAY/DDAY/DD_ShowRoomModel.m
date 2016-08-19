//
//  DD_ShowRoomModel.m
//  YCO SPACE
//
//  Created by yyj on 16/8/19.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShowRoomModel.h"

@implementation DD_ShowRoomModel
+(DD_ShowRoomModel *)getShowRoomModel:(NSDictionary *)dict
{
    DD_ShowRoomModel *_ShowRoomModel=[DD_ShowRoomModel objectWithKeyValues:dict];
    _ShowRoomModel.s_id=[[NSString alloc] initWithFormat:@"%ld",[[dict objectForKey:@"id"] longValue]];
//    _ShowRoomModel.pics=[DD_ImageModel getImageModelArr:[dict objectForKey:@"pics"]];
    _ShowRoomModel.pics=[DD_ImageModel getRandomImageModelArr:[dict objectForKey:@"pics"]];
    
    return _ShowRoomModel;
}
+(NSArray *)getShowRoomModelArr:(NSArray *)arr
{
    NSMutableArray *itemsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [itemsArr addObject:[self getShowRoomModel:dict]];
        
    }
    return itemsArr;
}
@end
