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

- (void)viewDidLoad {
    [super viewDidLoad];
    DD_StartView *_StartView=[[DD_StartView alloc] initWithBlock:^(NSString *type) {
        if([type isEqualToString:@"remove"])
        {
            [_StartView removeFromSuperview];
            [self presentViewController:[DD_CustomViewController sharedManager] animated:YES completion:nil];
        }
    }];
    [self.view addSubview:_StartView];
    [_StartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
