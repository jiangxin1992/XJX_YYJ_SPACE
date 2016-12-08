//
//  AVPlayerManager.h
//  YCOSPACE
//
//  Created by yyj on 2016/12/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVPlayerManager : NSObject
+ (instancetype)shareManager;
- (void)musicPlayerWithURL:(NSURL *)playerItemURL;
- (void)pause;
@end
