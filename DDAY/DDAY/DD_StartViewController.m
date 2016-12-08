//
//  DD_StartViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/9/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_StartViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "DD_CustomViewController.h"

#import "DD_StartView.h"

@interface DD_StartViewController ()

@property(nonatomic,strong)MPMoviePlayerController *moviePlayer;//视频播放器
@property(nonatomic,strong)UIView *mengbanView;

@end

@implementation DD_StartViewController
//{
//    DD_StartView *_StartView;
//}

//static DD_StartViewController *startController = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=_define_white_color;
    [self doSomeThing];
}
-(void)doSomeThing
{
    //    3. 获取文件存放的路径
    NSString*thePath=[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"mp4"];
    NSURL*theurl=[NSURL fileURLWithPath:thePath];
    //    4. 用该路径初始化moviePlayer
    _moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:theurl];
    _moviePlayer.view.backgroundColor=_define_white_color;
    [_moviePlayer.view setFrame:self.view.bounds];
    [self.view addSubview:_moviePlayer.view];
    _moviePlayer.shouldAutoplay = NO;  //是否自动播放
    [_moviePlayer prepareToPlay];
    [_moviePlayer setControlStyle:MPMovieControlStyleNone];//设置不需要进度条
    [_moviePlayer setFullscreen:YES];   //是否填充屏幕
    [_moviePlayer setRepeatMode:MPMovieRepeatModeNone];     //是否重复播放
    [_moviePlayer play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinishNotification:) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer]; // 当视频播放结束时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingMovieDidChangeNotification:) name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:_moviePlayer]; // 当视频播放结束时
    
    _mengbanView=[UIView getCustomViewWithColor:_define_white_color];
    [self.view addSubview:_mengbanView];
    _mengbanView.frame=self.view.bounds;
    
}
-(void)playingMovieDidChangeNotification:(NSNotification*)notify
{
    [_moviePlayer loadState];
    _mengbanView.hidden=YES;
    JXLOG(@"[_moviePlayer loadState]=%lu",(unsigned long)[_moviePlayer loadState]);
    JXLOG(@"111");
}
-(void)playbackDidFinishNotification:(NSNotification*)notify
{
    
    // 2.销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
    
    // 播放结束移除视频对象（非arc记得release！！）
    
    [_moviePlayer.view removeFromSuperview];
    
    _moviePlayer=nil;
    
    [self presentViewController:[DD_CustomViewController sharedManager] animated:YES completion:nil];
    
}

-(void)pushMainView
{
    if(_moviePlayer)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
        
        [_moviePlayer stop];
        
        [_moviePlayer.view removeFromSuperview];
        
        _moviePlayer=nil;
        
        [self presentViewController:[DD_CustomViewController sharedManager] animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 创建单例
//+(id)sharedManager
//{
//    //    创建CustomTabbarController的单例，并通过此方法调用
//    //    互斥锁，确保单例只能被创建一次
//    @synchronized(self)
//    {
//        if (!startController) {
//            startController = [[DD_StartViewController alloc]init];
//        }else
//        {
//            [startController doSomeThing];
//        }
//    }
//    return startController;
//}
//-(void)doSomeThing
//{
//    self.view.backgroundColor=_define_white_color;
//    _StartView=[[DD_StartView alloc] initWithBlock:^(NSString *type) {
//        if([type isEqualToString:@"remove"])
//        {
//            [_StartView removeFromSuperview];
//            _StartView=nil;
//            [self presentViewController:[DD_CustomViewController sharedManager] animated:YES completion:nil];
//        }
//    }];
//    [self.view addSubview:_StartView];
//    _StartView.frame=[UIScreen mainScreen].bounds;
//
//}

@end
