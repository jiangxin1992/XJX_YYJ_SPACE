//
//  DD_CircleCustomTagViewController.m
//  DDAY
//
//  Created by yyj on 16/6/16.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "DD_CirclePublishTool.h"
#import "DD_CircleCustomTagViewController.h"

@interface DD_CircleCustomTagViewController ()

@end

@implementation DD_CircleCustomTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
-(instancetype)initWithCircleModel:(DD_CircleModel *)CircleModel WithBlock:(void (^)(NSString *type,DD_CricleTagItemModel *tagModel))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _CircleModel=CircleModel;
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
    
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
-(void)PrepareUI
{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    self.navigationItem.titleView=[regular returnNavView:@"添加标签" withmaxwidth:200];
}
#pragma mark - UIConfig
-(void)UIConfig{}
#pragma mark - doneAction
-(void)doneAction
{
    if([NSString isNilOrEmpty:_tagTextField.text])
    {
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"content_empty", @"")] animated:YES completion:nil];
    }else if(_tagTextField.text.length>12)
    {
        [self presentViewController:[regular alertTitle_Simple:@"标签字数不得大于12"] animated:YES completion:nil];
    }else
    {
        if([DD_CirclePublishTool isExistCustomModelWithTagName:_tagTextField.text WithCircleModel:_CircleModel])
        {
            [self presentViewController:[regular alertTitle_Simple:@"您已添加该自定义标签"] animated:YES completion:nil];
        }else
        {
            [[JX_AFNetworking alloc] GET:@"share/addCustomerTag.do" parameters:@{@"token":[DD_UserModel getToken],@"tagName":_tagTextField.text} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                if(success)
                {
                    DD_CricleTagItemModel *model=[[DD_CricleTagItemModel alloc] init];
                    model.tagName=[data objectForKey:@"tagName"];
                    model.t_id=[[NSString alloc] initWithFormat:@"%ld",[[data objectForKey:@"id"] longValue]];
                    model.createTime=[[data objectForKey:@"createTime"] longValue]/1000;
                    _block(@"add_new_tag",model);
                    [self.navigationController popViewControllerAnimated:YES];
                }else
                {
                    [self presentViewController:successAlert animated:YES completion:nil];
                }
            } failure:^(NSError *error, UIAlertController *failureAlert) {
                [self presentViewController:failureAlert animated:YES completion:nil];
            }];
        }
    }
}
#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_CircleCustomTagViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_CircleCustomTagViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end