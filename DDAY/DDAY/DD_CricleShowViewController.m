//
//  DD_CricleShowViewController.m
//  DDAY
//
//  Created by yyj on 16/6/16.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CricleShowViewController.h"

#import "DD_CircleModel.h"

@interface DD_CricleShowViewController ()

@end

@implementation DD_CricleShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - 初始化
/**
 * 初始化
 */
-(instancetype)initWithCircleModel:(DD_CircleModel *)CircleModel WithIndex:(NSInteger )index WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _circleModel=CircleModel;
        _block=block;
        _index=index;
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
    self.view.backgroundColor=_define_black_color;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAction)];
    self.navigationItem.titleView=[regular returnNavView:[[NSString alloc] initWithFormat:@"%ld/%ld",_index+1,_circleModel.picArr.count] withmaxwidth:200];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    UIImage *img=[_circleModel.picArr[_index] objectForKey:@"data"];
    CGFloat _width=0;
    CGFloat _height=0;
    _width=ScreenWidth;
//    获取适应高度
    if(img.size.width<ScreenWidth)
    {
        _height=img.size.height;
    }else
    {
        _height=img.size.height*ScreenWidth/img.size.width;
    }
    UIImageView *_pho=[[UIImageView alloc] init];
    [_pho setImage:img];
    _pho.userInteractionEnabled=YES;
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [_pho addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [_pho addGestureRecognizer:pinchGestureRecognizer];
    [self.view addSubview:_pho];
    [_pho mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_width);
        make.height.mas_equalTo(_height);
        make.center.mas_equalTo(self.view);
    }];
}


#pragma mark - SomeAction
// 处理旋转手势
- (void) rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}
/**
 *  删除搭配图
 * 请求
 * 从qiniu中删除图片
 */
-(void)deleteAction
{
    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"key":[_circleModel.picArr[_index] objectForKey:@"key"]};
    [[JX_AFNetworking alloc] GET:@"file/deleteQiNiuFile.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _block(@"delete");
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
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


@end
