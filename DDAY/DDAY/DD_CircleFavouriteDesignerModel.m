//
//  DD_CircleFavouriteDesignerModel.m
//  DDAY
//
//  Created by yyj on 16/6/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleFavouriteDesignerModel.h"

@implementation DD_CircleFavouriteDesignerModel
+(DD_CircleFavouriteDesignerModel *)initDesignerModel
{
    DD_CircleFavouriteDesignerModel *model=[[DD_CircleFavouriteDesignerModel alloc] init];
    model.likeReason=@"";
    model.likeDesignerId=@"";
    model.likeDesignerName=@"";
    return model;
}
@end
