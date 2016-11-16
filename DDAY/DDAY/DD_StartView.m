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

@interface DD_StartView()

@property(nonatomic ,strong)AVPlayer *avPlayer1;
@property(nonatomic ,strong)AVPlayerItem *playerItem1;
@end

@implementation DD_StartView

-(instancetype)initWithBlock:(void (^)(NSString *))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        [regular getRoundNum:0];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        NSString *urlstr=[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"mp4"];
        NSURL *urlMovie1 = [NSURL fileURLWithPath:urlstr];
        AVURLAsset *asset1 = [AVURLAsset URLAssetWithURL:urlMovie1 options:nil];
        _playerItem1 = [AVPlayerItem playerItemWithAsset:asset1];
        _avPlayer1 = [AVPlayer playerWithPlayerItem: _playerItem1];
        AVPlayerLayer *avlayer1 = [AVPlayerLayer playerLayerWithPlayer:_avPlayer1];
        avlayer1.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        avlayer1.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer addSublayer:avlayer1];
        [_avPlayer1 play];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlayEndAction) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
    }
    return self;
}
-(void)PlayEndAction
{
    [_avPlayer1 replaceCurrentItemWithPlayerItem:nil];
    _block(@"remove");
}
@end
