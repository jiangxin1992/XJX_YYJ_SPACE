//
//  DD_CircleFavouriteDesignerModel.h
//  DDAY
//
//  Created by yyj on 16/6/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DD_CircleFavouriteDesignerModel : NSObject

+(DD_CircleFavouriteDesignerModel *)initDesignerModel;

/** 设计师ID*/
__string(likeDesignerId);

/** 设计师用户名*/
__string(likeDesignerName);

/** 喜欢它的理由*/
__string(likeReason);

@end
