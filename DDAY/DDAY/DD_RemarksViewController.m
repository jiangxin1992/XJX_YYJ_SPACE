//
//  DD_RemarksViewController.m
//  DDAY
//
//  Created by yyj on 16/5/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_RemarksViewController.h"

@interface DD_RemarksViewController ()<UITextViewDelegate>

@end

@implementation DD_RemarksViewController
{
    UITextView *textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - 初始化
-(instancetype)initWithRemarks:(NSString *)Remarks WithLimit:(long)limitNum WithTitle:(NSString *)title WithBlock:(void(^)(NSString *type,NSString *content))doneBlcok
{
    self=[super init];
    if(self)
    {
        _v_title=title;
        _Remarks=Remarks;
        _doneBlcok=doneBlcok;
        _limitNum=limitNum;
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
    
    DD_NavBtn *confirmBtn=[DD_NavBtn getNavBtnIsLeft:NO WithSize:CGSizeMake(24, 24) WithImgeStr:@"System_Confirm"];
    [confirmBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    
    
    self.navigationItem.titleView=[regular returnNavView:_v_title withmaxwidth:180];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    textView = [[UITextView alloc] init] ; //初始化大小并自动释放
    [self.view addSubview: textView];//加入到整个页面中
    textView.textColor = _define_black_color;//设置textview里面的字体颜色
    
    textView.font = [regular getFont:13.0f];//设置字体名字和字体大小
    
    textView.delegate = self;//设置它的委托方法
    textView.textAlignment=0;
    textView.backgroundColor =  _define_clear_color;//设置它的背景颜色
    
    textView.returnKeyType = UIReturnKeyDone;//返回键的类型
    
    textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    textView.text = nil;
    textView.text=_Remarks;
    [regular setBorder:textView];
    
    [textView becomeFirstResponder];
 
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(kNavHeight+15);
        make.height.mas_equalTo(100);
    }];
}
#pragma mark - SomeAction
/**
 * 完成
 */
-(void)doneAction
{
    if([NSString isNilOrEmpty:textView.text])
    {
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"content_empty", @"")] animated:YES completion:nil];
    }else
    {
        [regular dismissKeyborad];
//        判断是否有字数限制
        if(_limitNum)
        {
            if(textView.text.length<=_limitNum)
            {
                _doneBlcok(@"done",textView.text);
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [self presentViewController:[regular alertTitle_Simple:@"已超出字数限制"] animated:YES completion:nil];
            }
        }else
        {
            _doneBlcok(@"done",textView.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
/**
 * 键盘消失
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [regular dismissKeyborad];
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [regular dismissKeyborad];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self doneAction];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}
#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_RemarksViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_RemarksViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
