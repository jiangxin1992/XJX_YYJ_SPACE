//
//  DD_drawManageView.h
//  YCO SPACE
//
//  Created by yyj on 16/7/28.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_DrawManageView : UIView

-(instancetype)initWithImgCount:(NSInteger )imgCount;

-(void)changeSelectNum:(NSInteger )selectNum;

@property(nonatomic,assign) NSInteger imgCount;

@end
