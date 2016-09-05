//
//  DD_CircleModel.h
//  DDAY
//
//  Created by yyj on 16/6/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DD_CircleFavouriteDesignerModel.h"

@interface DD_CircleModel : NSObject
/**
 * 获取初始化model
 */
+(DD_CircleModel *)getCircleModel;
-(NSMutableArray *)getTagArr;
/**
 * 搭配建议
 */
__string(remark);

/**
 * 已选tags map
 */
__mu_dict(tagMap);
/**
 * 搭配图
 */
__mu_array(picArr);

/**
 * 选择的款式
 */
__mu_array(chooseItem);

/**
 * 选择标签
 */
__mu_array(shareTags);
/**
 * 适合人群
 */
__array(personTags);


/**
 * 最喜爱的设计师
 */
@property (nonatomic,strong)DD_CircleFavouriteDesignerModel *designerModel;

/**
 * 当前的申请状态
 */
__int(status);
@end
