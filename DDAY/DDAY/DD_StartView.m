//
//  DD_StartView.m
//  YCO SPACE
//
//  Created by yyj on 16/9/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_StartView.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@implementation DD_StartView

-(instancetype)initWithBlock:(void (^)(NSString *))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        NSURL *urlMovie1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loading for Space" ofType:@"mp4"]];
        AVURLAsset *asset1 = [AVURLAsset URLAssetWithURL:urlMovie1 options:nil];
        AVPlayerItem *playerItem1 = [AVPlayerItem playerItemWithAsset:asset1];
        AVPlayer *avPlayer1 = [AVPlayer playerWithPlayerItem: playerItem1];
        AVPlayerLayer *avlayer1 = [AVPlayerLayer playerLayerWithPlayer:avPlayer1];
        avlayer1.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        avlayer1.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer addSublayer:avlayer1];
        [avPlayer1 play];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlayEndAction) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}
-(void)PlayEndAction
{
    _block(@"remove");
}
@end
