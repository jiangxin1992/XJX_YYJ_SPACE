//
//  WaterflowCell.h
//  瀑布流3
//
//  Created by 李保磊 on 16/3/14.
//  Copyright © 2016年 XO. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Waterflow;

@interface WaterflowCell : UIView

+ (instancetype)waterflowCellWithWaterflow:(Waterflow *)waterflow;

- (instancetype)initWithIdentifier:(NSString *)identifier;


@property (nonatomic,copy) NSString *identifier;
//@property (nonatomic,copy) NSString *index;

@end
