//
//  DD_VersionView.h
//  YCOSPACE
//
//  Created by yyj on 2016/12/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"
#import "DD_VersionModel.h"

@interface DD_VersionView : DD_BaseView

/**
 * 创建单例
 */
+(id)sharedManagerWithModel:(DD_VersionModel *)versionModel WithBlock:(void (^)(NSString *type))block;

@property (nonatomic,strong)DD_VersionModel *versionModel;

__block_type(block, type);

@end
