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

@implementation DD_StartViewPlayer{
    NSInteger _repeatAction;
    NSTimer *timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [NSThread sleepForTimeInterval:1];
    
    _repeatAction=0;
    
    self.view.backgroundColor=_define_white_color;
    
    NSString *thePath=[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"mp4"];
    
    //判断本地路径是否为空
    if([NSString isNilOrEmpty:thePath])
    {
        [self pushMainView];
    }else
    {
        NSURL *url=[NSURL fileURLWithPath:thePath];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
        
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMainView) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
        
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        
        playerLayer.frame = self.view.bounds;   // CGRectMake(0, 0, 100, 100);//
        
        [self.view.layer addSublayer:playerLayer];  //addsublayer /addsubView
        
        timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(RepeactCheckAction) userInfo:nil repeats:YES];
    }
}

// 实现Observer的回调方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    // 如果改变的属性是"name"
    if ([keyPath isEqualToString:@"status"]) {
        NSLog(@"_player.status=%ld",(long)_player.status);
        if(_player.status==AVPlayerStatusReadyToPlay)
        {
            if(_player)
            {
                [_player play];
            }else
            {
                [self pushMainView];
            }
        }
    }
}

-(void)RepeactCheckAction
{
    _repeatAction++;
    if(_repeatAction>=2)
    {
        [self pushMainView];
    }
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
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _player = nil;
    [timer invalidate];
    timer=nil;
    [_player.currentItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
