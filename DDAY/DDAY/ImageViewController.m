//
//  ImageViewController.m
//  AdminMeetimeApp
//
//  Created by 谢江新 on 14-12-5.
//  Copyright (c) 2014年 谢江新. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()
{
    UIImageView *_imgv;
}
@end

@implementation ImageViewController
-(instancetype)initWithHeight:(CGFloat )height WithBlock:(void(^)(NSString *type,NSInteger index))block
{
    self=[super init];
    if(self)
    {
        _height=height;
        _block=block;
    }
    return self;
}
-(void)loadView
{
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, _height)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imgv = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_imgv];
    _imgv.userInteractionEnabled=YES;
    [_imgv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction)]];
    _imgv.backgroundColor=[UIColor clearColor];
   
    _imgv.hidden=YES;

}
-(void)touchAction
{
    _block(@"show_img",_currentPage);
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    if (currentPage<0) {
        currentPage = _maxPage;
    }
    if (currentPage > _maxPage) {
        currentPage = 0;
    }
    _currentPage = currentPage;
    _imgv.hidden=NO;

    [_imgv JX_loadImageUrlStr:[_array objectAtIndex:_currentPage] WithSize:800 placeHolderImageName:nil radius:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
