//
//  DD_BaseViewController.h
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_BaseViewController : UIViewController

-(void )hideBackNavBtn;

-(void )pushLoginView;

-(BOOL )isVisible;

-(void )pushCleaingDoneViewWithResultDic:(NSDictionary *)resultDic WithType:(NSString *)type;

@end
