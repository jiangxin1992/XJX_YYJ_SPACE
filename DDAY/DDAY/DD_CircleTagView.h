//
//  DD_CircleTagView.h
//  YCO SPACE
//
//  Created by yyj on 16/9/5.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseView.h"

@class DD_CircleListModel;

@interface DD_CircleTagView : DD_BaseView

-(instancetype)initWithTagArr:(NSArray *)tagArr;

-(void)setState;

+(CGFloat)GetHeightWithTagArr:(NSArray *)tagArr;

/** 搭配model*/
__array(tagArr);

__label(lastView);

@end
