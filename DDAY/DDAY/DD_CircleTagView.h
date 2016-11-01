//
//  DD_CircleTagView.h
//  YCO SPACE
//
//  Created by yyj on 16/9/5.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DD_CircleListModel.h"

@interface DD_CircleTagView : UIView

-(instancetype)initWithTagArr:(NSArray *)tagArr;

-(void)setState;

+(CGFloat)GetHeightWithTagArr:(NSArray *)tagArr;

/** 搭配model*/
__array(tagArr);

__label(lastView);

@end
