//
//  DD_VersionModel.h
//  YCOSPACE
//
//  Created by yyj on 2016/12/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_baseModel.h"

@interface DD_VersionModel : DD_baseModel

/**
 * 获取版本model
 */
+(DD_VersionModel *)getVersionModel:(NSDictionary *)dict;

/** 标题*/
__string(title);

/** 版本号*/
__string(appVersion);

/** 更新内容*/
__string(updateInfo);

/** App Store下载地址*/
__string(downLoadUrl);

/** APP构建版本*/
__string(appBundleVersion);

@end
