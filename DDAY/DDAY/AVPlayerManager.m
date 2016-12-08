//
//  AVPlayerManager.m
//  YCOSPACE
//
//  Created by yyj on 2016/12/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "AVPlayerManager.h"
#import <AVFoundation/AVFoundation.h>
@interface AVPlayerManager(){
    BOOL isPlaying;//是否正在播放
    BOOL isPrepare;//资源是否准备完毕
}
@property (nonatomic, strong) AVPlayer *player;//播放器
@end
@implementation AVPlayerManager

//单例
+ (instancetype)shareManager{
    static AVPlayerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AVPlayerManager new];
    });
    return manager;
}

//播放音频的方法(下面会在控制器调用)
- (void)musicPlayerWithURL:(NSURL *)playerItemURL{
    //创建要播放的资源
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:playerItemURL];
    //添加观察者
    //当资源的status发生改变时就会触发观察者事件
    [playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
    //播放当前资源
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    
}


//播放
- (void)play{
    if (!isPrepare) {
        return;
    }
    [self.player play];
    isPlaying = YES;
}
//暂停
- (void)pause{
    if (!isPlaying) {
        return;
    }
    [self.player pause];
    isPlaying = NO;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItemStatus status = [change[@"new"] integerValue];
    switch (status) {
        case AVPlayerItemStatusReadyToPlay:
            isPrepare = YES;
            [self play];
            break;
        case AVPlayerItemStatusFailed:
            NSLog(@"加载失败");
            break;
        case AVPlayerItemStatusUnknown:
            NSLog(@"未知资源");
            break;
        default:
            break;
    }
}

//播放器懒加载
-(AVPlayer *)player{
    if (!_player) {
        _player = [AVPlayer new];
    }
    return _player;
}

@end
