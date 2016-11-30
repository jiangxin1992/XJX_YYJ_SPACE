//
//  DD_DesignerModel.h
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_DesignerModel : NSObject

+(DD_DesignerModel *)getDesignerModel:(NSDictionary *)dict;

+(NSArray *)getDesignerModelArr:(NSArray *)arr;

/** 设计师ID*/
__string(designerId);

/** 分享网页*/
__string(appUrl);

/** App Store下载地址*/
__string(downLoadUrl);

/** 用户是否已关注*/
__bool(guanzhu);

/** 设计师头像*/
__string(head);

/** 设计师名*/
__string(name);

/** 设计师的代表性单品数组*/
__array(items);

/** 品牌icon*/
__string(brandIcon);

/** 品牌名称*/
__string(brandName);

/** 用户类型 2设计师 3普通用户 4达人*/
__string(userType);

@end
