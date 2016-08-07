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
-(instancetype)initWithSize:(CGSize )size WithBlock:(void(^)(NSString *type,NSInteger index))block{
    self=[super init];
    if(self)
    {
        _size=size;
        _block=block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imgv = [UIImageView getCustomImg];
    [self.view addSubview:_imgv];
    CGFloat _w=IsPhone6_gt?20:16;
    [_imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(_w);
        make.bottom.mas_equalTo(-_w);
        make.right.mas_equalTo(-_w-(IsPhone6_gt?60:49));
    }];
    [_imgv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction)]];
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
