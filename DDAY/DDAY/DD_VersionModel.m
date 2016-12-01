//
//  DD_VersionModel.m
//  YCOSPACE
//
//  Created by yyj on 2016/12/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_VersionModel.h"

@implementation DD_VersionModel

+(DD_VersionModel *)getVersionModel:(NSDictionary *)dict
{
    DD_VersionModel *_Viersion=[DD_VersionModel mj_objectWithKeyValues:dict];
    if(!_Viersion.updateInfo)
    {
        _Viersion.updateInfo=@"";
    }
    return _Viersion;
}

@end
