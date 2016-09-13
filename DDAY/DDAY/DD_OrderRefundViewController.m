

//
//  DD_OrderRefundViewController.m
//  DDAY
//
//  Created by yyj on 16/6/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderRefundViewController.h"

#import "DD_OrderModel.h"

@interface DD_OrderRefundViewController ()<UITextViewDelegate>

@end

@implementation DD_OrderRefundViewController
{
    UITextView *_textView;
    long _status;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}
#pragma mark - 初始化
-(instancetype)initWithModel:(DD_OrderDetailModel *)model WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _OrderModel=model;
    }
    return self;
}
#pragma mark - RequestData
-(void)RequestData
{
    if(_OrderModel.orderInfo.orderList.count)
    {
        DD_OrderModel *_order=[_OrderModel.orderInfo.orderList objectAtIndex:0];
        [[JX_AFNetworking alloc] GET:@"order/queryOrderStatus.do" parameters:@{@"token":[DD_UserModel getToken],@"orderCode":_order.subOrderCode} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            if(success)
            {
                _status=[[data objectForKey:@"status"] longValue];
                [self UIConfig];
                
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }
    
}

#pragma mark - UIConfig
-(void)UIConfig
{
    if(_status==0)
    {
        //待付款
    }else if(_status==1)
    {
        //待发货
        [self CreateTextView];
    }else if(_status==2)
    {
        //待收货
        [self CreateTextView];
    }else if(_status==3)
    {
        //交易成功
        [self CreateTextView];
    }else if(_status==4)
    {
        //申请退款
        [self CreateContentView];
    }else if(_status==5)
    {
        //退款处理中
        [self CreateContentView];
    }else if(_status==6)
    {
        //已退款
        [self CreateContentView];
    }else if(_status==7)
    {
        //拒绝退款
        [self CreateContentView];
    }
    
}
-(void)CreateContentView
{
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(100, (ScreenHeight-100)/2.0f, ScreenWidth-200, 50)];
    [self.view addSubview:label];
    label.textAlignment=1;
    label.textColor=_define_black_color;
    label.text=_status==4?@"申请退款":_status==5?@"退款处理中":_status==6?@"已退款":@"拒绝退款";
    
}
-(void)CreateTextView
{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"send", @"") style:UIBarButtonItemStylePlain target:self action:@selector(sendAction)];
    
    _textView = [[UITextView alloc] init] ; //初始化大小并自动释放
    _textView.contentSize=CGSizeMake( ScreenWidth-20, 200);
    _textView.textColor = _define_black_color;//设置textview里面的字体颜色
    
    _textView.font = [regular getFont:14.0f];//设置字体名字和字体大小
    
    _textView.delegate = self;//设置它的委托方法
    _textView.textAlignment=0;
    _textView.backgroundColor =  _define_clear_color;//设置它的背景颜色
    
    _textView.returnKeyType = UIReturnKeySend;//返回键的类型
    
    _textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    
    //    textView.scrollEnabled = YES;//是否可以拖动
    
    //    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [self.view addSubview: _textView];//加入到整个页面中
    [_textView becomeFirstResponder];//设为第一响应
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(kNavHeight+10);
        make.height.mas_equalTo(200);
    }];
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
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"order_refund_title", @"") withmaxwidth:200];//设置标题
    
}
#pragma mark - SomeActions
/**
 * 提交建议
 */
-(void)sendAction
{
    if([NSString isNilOrEmpty:_textView.text]||[_textView.text isEqualToString:@"请填写退款理由"])
    {
        //        对空判断
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"content_empty", @"")] animated:YES completion:nil];
    }else
    {
        if(_OrderModel.orderInfo.orderList.count)
        {
            DD_OrderModel *_order=[_OrderModel.orderInfo.orderList objectAtIndex:0];
            //        提交建议
            NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"reason":_textView.text,@"orderCode":_order.subOrderCode};
            [[JX_AFNetworking alloc] GET:@"order/applyCancelOrder.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
                if(success)
                {
                    
                    //                提交成功后
                    [regular dismissKeyborad];
                    _order.orderStatus=4;
                    _block(@"update");
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"submit_success", @"") preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
            
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
//在开始编辑的代理方法中进行如下操作
- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.textColor=_define_black_color;
    if ([textView.text isEqualToString:@"请填写退款理由"]) {
        
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请填写退款理由"]||[textView.text isEqualToString:@""]) {
        textView.text = @"请填写退款理由";
        textView.textColor=_define_light_gray_color1;
    }else
    {
        textView.textColor=_define_black_color;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self sendAction];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}
#pragma mark - Others
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
    [MobClick beginLogPageView:@"DD_OrderRefundViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DD_OrderRefundViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
