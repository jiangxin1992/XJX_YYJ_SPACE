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
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"cancel", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"done", @"") style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    self.navigationItem.titleView=[regular returnNavView:_v_title withmaxwidth:180];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10,74, ScreenWidth-20, 200)] ; //初始化大小并自动释放
    textView.contentSize=CGSizeMake( ScreenWidth-20, 200);
    textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    
    textView.font = [regular getFont:14.0f];//设置字体名字和字体大小
    
    textView.delegate = self;//设置它的委托方法
    textView.textAlignment=0;
    textView.backgroundColor = [UIColor clearColor];//设置它的背景颜色
    
    //    self.textView.text = @"Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.";//设置它显示的内容
    
    textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    
    textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    textView.text=_Remarks;
    //    textView.scrollEnabled = YES;//是否可以拖动
    
    //    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    [self.view addSubview: textView];//加入到整个页面中
    [textView becomeFirstResponder];
    
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
 * 取消/返回
 */
-(void)cancelAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
