//
//  ImageViewController.m
//  AdminMeetimeApp
//
//  Created by 谢江新 on 14-12-5.
//  Copyright (c) 2014年 谢江新. All rights reserved.
//

#import "ImageViewController.h"

#import "DD_ImageModel.h"

@interface ImageViewController ()
{
    UIImageView *_imgv;
}
@end

@implementation ImageViewController
-(instancetype)initWithSize:(CGSize )size WithType:(NSString *)type WithIsFit:(BOOL )is_fit WithContentModeIsFill:(BOOL )is_fill WithBlock:(void(^)(NSString *type,NSInteger index))block{
    self=[super init];
    if(self)
    {
        _is_fit=is_fit;
        _type=type;
        _size=size;
        _is_fill=is_fill;
        _block=block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imgv = [UIImageView getCustomImg];
    _imgv.userInteractionEnabled=YES;
    if(_is_fill)
    {
        _imgv.contentMode=UIViewContentModeScaleAspectFill;
        [regular setZeroBorder:_imgv];
    }else
    {
        _imgv.contentMode=UIViewContentModeScaleAspectFit;
    }
    [self.view addSubview:_imgv];
    [_imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        if(_is_fit)
        {
            make.edges.mas_equalTo(self.view);
        }else
        {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(IsPhone6_gt?(-60-16):(-49-16));
        }
        
    }];
    [_imgv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction)]];
    _imgv.hidden=YES;
    
}
-(void)touchAction
{
    NSLog(@"_currentPage=%ld",_currentPage);
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
    if([_type isEqualToString:@"model"])
    {
        DD_ImageModel *imgModel=[_array objectAtIndex:_currentPage];
        [_imgv JX_loadImageUrlStr:imgModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    }else if([_type isEqualToString:@"data"])
    {
        
        [_imgv setImage:[_array objectAtIndex:_currentPage]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
