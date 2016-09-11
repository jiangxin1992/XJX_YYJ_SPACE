//
//  DD_SuggestViewController.m
//  DDAY
//
//  Created by yyj on 16/5/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_SuggestViewController.h"

@interface DD_SuggestViewController ()<UITextViewDelegate>

@end

@implementation DD_SuggestViewController
{
    UITextView *textView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
/**
 * 设置标题，nav左右按钮
 */
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"user_set_suggest", @"") withmaxwidth:180];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"send", @"") style:UIBarButtonItemStylePlain target:self action:@selector(sendAction)];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTextView];
}
-(void)CreateTextView
{
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10,74, ScreenWidth-20, 200)] ; //初始化大小并自动释放
    textView.contentSize=CGSizeMake( ScreenWidth-20, 200);
    textView.textColor = _define_black_color;//设置textview里面的字体颜色
    
    textView.font = [regular getFont:14.0f];//设置字体名字和字体大小
    
    textView.delegate = self;//设置它的委托方法
    textView.textAlignment=0;
    textView.backgroundColor =  _define_clear_color;//设置它的背景颜色
    
    textView.returnKeyType = UIReturnKeySend;//返回键的类型
    
    textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    
    //    textView.scrollEnabled = YES;//是否可以拖动
    
    //    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    [self.view addSubview: textView];//加入到整个页面中
    [textView becomeFirstResponder];//设为第一响应
}
#pragma mark - SomeActions
/**
 * 提交建议
 */
-(void)sendAction
{
    if([NSString isNilOrEmpty:textView.text])
    {
//        对空判断
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"content_empty", @"")] animated:YES completion:nil];
    }else
    {
//        提交建议
        NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"advise":textView.text};
        [[JX_AFNetworking alloc] GET:@"user/commitAdvise.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
//                提交成功后
//                键盘消失/显示成功提示
                [regular dismissKeyborad];
                [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"submit_success", @"")] animated:YES completion:nil];
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }
    
}

#pragma mark - Other
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self sendAction];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [regular dismissKeyborad];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [regular dismissKeyborad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_SuggestViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_SuggestViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
