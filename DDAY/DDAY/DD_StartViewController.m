//
//  DD_StartViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/9/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_StartViewController.h"

#import "DD_StartView.h"

@interface DD_StartViewController ()

@end

@implementation DD_StartViewController
{
    DD_StartView *_StartView;
}

static DD_StartViewController *startController = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
//    DD_DDAYModel *model=[[DD_DDAYModel alloc] init];
//    model.s_id=@"100212";
//    NSArray *arr=@[model];
//    JXLOG(@"s_id=%@",((DD_DDAYModel *)arr[0]).s_id);
    _StartView=[[DD_StartView alloc] initWithBlock:^(NSString *type) {
        if([type isEqualToString:@"remove"])
        {
            [_StartView removeFromSuperview];
            _StartView=nil;
            [self presentViewController:[DD_CustomViewController sharedManager] animated:YES completion:nil];
        }
    }];
    [self.view addSubview:_StartView];
    [_StartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - 创建单例
+(id)sharedManager
{
//    long time=[NSDate nowTime];
//    JXLOG(@"111");
    //    创建CustomTabbarController的单例，并通过此方法调用
    //    互斥锁，确保单例只能被创建一次
    @synchronized(self)
    {
        if (!startController) {
            startController = [[DD_StartViewController alloc]init];
        }
    }
    return startController;
}
-(void)pushMainView
{
    if(_StartView)
    {
        [_StartView removeFromSuperview];
        _StartView=nil;
        [self presentViewController:[DD_CustomViewController sharedManager] animated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
