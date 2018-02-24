//
//  AppDelegate.h
//  DDAY
//
//  Created by yyj on 16/5/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeTuiSdk.h"

#define kGtAppId           @"xj4QqJvMWb6XvatHms1gx2"
#define kGtAppKey          @"IgCKHHEC326WiTBEZv8Nx1"
#define kGtAppSecret       @"dk9YyBRyA0AhoSUht6QbL5"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GeTuiSdkDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

