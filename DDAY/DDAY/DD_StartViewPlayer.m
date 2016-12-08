//
//  DD_StartViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/9/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_StartViewPlayer.h"

#import <AVFoundation/AVFoundation.h>

#import "DD_CustomViewController.h"

#import "DD_StartView.h"


@interface DD_StartViewPlayer ()

@property(nonatomic,strong)AVPlayer *player;

@end

@implementation DD_StartViewPlayer

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=_define_white_color;
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.view.bounds;   // CGRectMake(0, 0, 100, 100);//
    [self.view.layer addSublayer:playerLayer];  //addsublayer /addsubView
    [_player play];
}
-(AVPlayer *)player{
    if (!_player) {
        
        NSString*thePath=[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"mp4"];
        NSURL*url=[NSURL fileURLWithPath:thePath];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlayEndAction) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
    }
    return _player;
}


-(void)PlayEndAction
{
    [self presentViewController:[DD_CustomViewController sharedManager] animated:YES completion:nil];
}

-(void)dealloc{
    [_player.currentItem removeObserver:self forKeyPath:@"status"];
    [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)pushMainView
{
    if(!((DD_CustomViewController *)[DD_CustomViewController sharedManager]).isVisible)
    {
        [self presentViewController:[DD_CustomViewController sharedManager] animated:YES completion:nil];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    _player = nil;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
