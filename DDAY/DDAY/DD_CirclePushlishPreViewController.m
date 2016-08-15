//
//  DD_CirclePushlishPreViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/8/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CirclePushlishPreViewController.h"

#import "DD_CircleDetailImgView.h"

@interface DD_CirclePushlishPreViewController ()

@end

@implementation DD_CirclePushlishPreViewController
{
    DD_CircleDetailImgView *_imgView;
    UIImageView *userHeadImg;
    UILabel *userNameLabel;
    UILabel *userCareerLabel;
    UIImageView *goodImgView;
    UILabel *conentLabel;
    UILabel *timeLabel;
    NSMutableArray *goodsImgArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    userHeadImg=[UIImageView getCustomImg];
//    [self.view addSubview:userHeadImg];
//    userHeadImg.userInteractionEnabled=YES;
//    [userHeadImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
//    [userHeadImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(IsPhone6_gt?34:15);
//        make.top.mas_equalTo(9);
//        make.width.height.mas_equalTo(43);
//    }];
//    
//    userNameLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:15.0f WithTextColor:nil WithSpacing:0];
//    [self.view addSubview:userNameLabel];
//    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(userHeadImg);
//        make.height.mas_equalTo(43/2.0f);
//        make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);
//    }];
//    [userNameLabel sizeToFit];
//    
//    
//    userCareerLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
//    [self.view addSubview:userCareerLabel];
//    [userCareerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(userNameLabel.mas_bottom).with.offset(0);
//        make.height.mas_equalTo(43/2.0f);
//        make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);
//    }];
//    [userCareerLabel sizeToFit];
//    
//    
//    _imgView=[[DD_CircleDetailImgView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type,NSInteger index) {
//        _block(type,0,nil);
//    }];
//    [self.view addSubview:_imgView];
//    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(userHeadImg);
//        make.top.mas_equalTo(userHeadImg.mas_bottom).with.offset(19);
//        make.width.mas_equalTo(210);
//        make.height.mas_equalTo(300);
//    }];
//    
//    
//    UIView *lastView=nil;
//    for (int i=0; i<3; i++) {
//        UIImageView *goods=[UIImageView getCustomImg];
//        [self.view addSubview:goods];
//        goods.userInteractionEnabled=YES;
//        goods.tag=100+i;
//        [goods addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)]];
//        [goods mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-(IsPhone6_gt?34:15));
//            make.width.height.mas_equalTo(66);
//            if(lastView)
//            {
//                make.bottom.mas_equalTo(lastView.mas_top).with.offset(-24);
//            }else
//            {
//                make.bottom.mas_equalTo(_imgView.mas_bottom).with.offset(0);
//            }
//        }];
//        lastView=goods;
//        [goodsImgArr addObject:goods];
//        
//        UIButton *pricebtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_white_color WithSelectedTitle:@"" WithSelectedColor:nil];
//        [goods addSubview:pricebtn];
//        pricebtn.userInteractionEnabled=NO;
//        pricebtn.tag=150+i;
//        [pricebtn setBackgroundImage:[UIImage imageNamed:@"Circle_PriceFrame"] forState:UIControlStateNormal];
//        [pricebtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.mas_equalTo(0);
//            make.height.mas_equalTo(16);
//        }];
//        
//    }
//    
//    conentLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:nil WithSpacing:0];
//    [self.view addSubview:conentLabel];
//    conentLabel.numberOfLines=0;
//    [conentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_imgView.mas_bottom).with.offset(19);
//        make.left.mas_equalTo(IsPhone6_gt?34:15);
//        make.right.mas_equalTo(-(IsPhone6_gt?34:15));
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
