//
//  DD_CircleModel.m
//  DDAY
//
//  Created by yyj on 16/6/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleModel.h"

@implementation DD_CircleModel
+(DD_CircleModel *)getCircleModel;
{
    DD_CircleModel *model=[[DD_CircleModel alloc] init];
    model.picArr=[[NSMutableArray alloc] init];
    model.tagMap=[[NSMutableDictionary alloc] init];
    model.chooseItem=[[NSMutableArray alloc] init];
    model.remark=@"";
    model.designerModel=[DD_CircleFavouriteDesignerModel initDesignerModel];
    return model;
}
@end
