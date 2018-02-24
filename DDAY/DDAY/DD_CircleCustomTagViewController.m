//
//  DD_CircleCustomTagViewController.m
//  DDAY
//
//  Created by yyj on 16/6/16.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleCustomTagViewController.h"

#import "DrawView.h"

#import "DD_CirclePublishTool.h"
#import "DD_CircleModel.h"
#import "DD_CricleTagItemModel.h"

@interface DD_CircleCustomTagViewController ()
//<UITextFieldDelegate>


@end

@implementation DD_CircleCustomTagViewController
{
    UITextField *_tagTextField;
}

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
    self.navigationItem.titleView=[regular returnNavView:@"添加标签" withmaxwidth:200];
    DD_NavBtn *confirmBtn=[DD_NavBtn getNavBtnIsLeft:NO WithSize:CGSizeMake(24, 24) WithImgeStr:@"System_Confirm"];
//    [confirmBtn addTarget:self action:@selector(DoneAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    [confirmBtn bk_addEventHandler:^(id sender) {
        [self DoneAction];
    } forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - UIConfig
-(void)UIConfig
{
    _tagTextField=[[UITextField alloc] init];
    [self.view addSubview:_tagTextField];
    _tagTextField.leftViewMode=UITextFieldViewModeAlways;
    _tagTextField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 32)];
    _tagTextField.clearButtonMode = UITextFieldViewModeAlways;
    _tagTextField.returnKeyType=UIReturnKeyDone;
    _tagTextField.borderStyle= UITextBorderStyleNone;
//    _tagTextField.delegate=self;
    __block DD_CircleCustomTagViewController *CircleVC=self;
    [_tagTextField setBk_shouldReturnBlock:^BOOL(UITextField *textfield) {
        [CircleVC DoneAction];
        return YES;
    }];
    _tagTextField.placeholder=@"添加标签";
    _tagTextField.textColor=_define_black_color;
    _tagTextField.font=[regular getFont:13.0f];
    [regular setBorder:_tagTextField];
    [_tagTextField becomeFirstResponder];
    [_tagTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(kNavHeight+15);
        make.height.mas_equalTo(32);
    }];
}

#pragma mark - doneAction
-(void)DoneAction
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [regular dismissKeyborad];
}
#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [self DoneAction];
//    return YES;
//}

@end
