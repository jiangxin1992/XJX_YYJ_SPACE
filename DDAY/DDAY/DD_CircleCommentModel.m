//
//  DD_CircleCommentModel.m
//  DDAY
//
//  Created by yyj on 16/6/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleCommentModel.h"

@implementation DD_CircleCommentModel
+(DD_CircleCommentModel *)getCircleCommentModel:(NSDictionary *)dict
{
    DD_CircleCommentModel *_tagModel=[DD_CircleCommentModel mj_objectWithKeyValues:dict];
    _tagModel.createTime=[[dict objectForKey:@"createTime"] longLongValue]/1000;
//    _tagModel.createTime=_tagModel.createTime/1000;
    [_tagModel IntegrationComment];
    _tagModel.commHeight=[regular getHeightWithContent:_tagModel.comment WithWidth:ScreenWidth-120 WithFont:13.0f];
    
    return _tagModel;
}
+(NSMutableArray *)getCircleCommentModelArr:(NSArray *)arr
{
    NSMutableArray *TagsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        [TagsArr addObject:[self getCircleCommentModel:dict]];
    }
    return TagsArr;
}
/**
 * 整合评论内容
 * 两种情况 1、回复 2、评论
 */
-(void )IntegrationComment
{
    if(self.commToId)
    {
        self.comment=[[NSString alloc] initWithFormat:@"回复@%@:%@",self.commToName,self.comment];
    }
}
@end
