//
//  DD_CircleShowDetailImgViewController.m
//  DDAY
//
//  Created by yyj on 16/6/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleShowDetailImgViewController.h"

#import "DD_ImageModel.h"

@interface DD_CircleShowDetailImgViewController ()<UIGestureRecognizerDelegate>

@end

@implementation DD_CircleShowDetailImgViewController
{
    UIImageView *_pho;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(instancetype)initWithCircleArr:(NSArray *)picArrs WithType:(NSString *)type WithIndex:(NSInteger )index WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _type=type;
        _picArrs=picArrs;
        _index=index;
        _block=block;
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
    self.view.backgroundColor=[UIColor blackColor];
    self.navigationItem.titleView=[regular returnNavView:[[NSString alloc] initWithFormat:@"%ld/%ld",_index+1,_picArrs.count] withmaxwidth:200];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    _pho=[UIImageView getCustomImg];
    [self.view addSubview:_pho];
    if([_type isEqualToString:@"data"])
    {
        
        [_pho setImage:[_picArrs objectAtIndex:_index]];
    }else if([_type isEqualToString:@"model"])
    {
        DD_ImageModel *imgModel=[_picArrs objectAtIndex:_index];
        [_pho JX_loadImageUrlStr:imgModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    }
    _pho.userInteractionEnabled=YES;
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [_pho addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [_pho addGestureRecognizer:pinchGestureRecognizer];
    
    [_pho mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(300);
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
#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DD_CircleShowDetailImgViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _pho.hidden=YES;
    [MobClick endLogPageView:@"DD_CircleShowDetailImgViewController"];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
