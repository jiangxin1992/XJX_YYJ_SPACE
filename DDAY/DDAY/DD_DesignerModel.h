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

__string(brandName);
__string(designerId);
__bool(guanzhu);
__string(head);
__string(name);
__array(items);
__string(brandIcon);

@end
