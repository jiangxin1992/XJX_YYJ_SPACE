//
//  DD_GoodsDesignerModel.h
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_GoodsDesignerModel : NSObject
+(DD_GoodsDesignerModel *)getGoodsDesignerModel:(NSDictionary *)dict;
__string(brandIcon);
__string(brandName);
__string(designerId);
__string(designerName);
__string(head);
/**
 * 用户类型 2设计师 3普通用户 4达人
 */
__string(userType);
@end
