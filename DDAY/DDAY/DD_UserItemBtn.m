//
//  DD_UserItemBtn.m
//  YCO SPACE
//
//  Created by yyj on 16/8/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserItemBtn.h"

@implementation DD_UserItemBtn
+(DD_UserItemBtn *)getUserItemBtnWithFrame:(CGRect )frame WithImgSize:(CGSize )size WithImgeStr:(NSString *)imgStr WithTitle:(NSString *)title
{
    DD_UserItemBtn *shopBtn=[DD_UserItemBtn buttonWithType:UIButtonTypeCustom];
    if(shopBtn)
    {
        shopBtn.frame=frame;
        shopBtn.kframe=frame;
        shopBtn.size=size;
//        shopBtn.titleLabel.font=[regular getFont:15.0f];
//        shopBtn.titleLabel.textAlignment = 0;
//        [shopBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
//        [shopBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
//        [shopBtn setTitle:title forState:UIControlStateNormal];
        UIImageView *img=[UIImageView getImgWithImageStr:imgStr];
        [shopBtn addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(shopBtn);
            make.width.mas_equalTo(21);
            make.height.mas_equalTo((size.height/size.width)*21);
        }];
        
        UILabel *titleL_label=[UILabel getLabelWithAlignment:0 WithTitle:title WithFont:15.0f WithTextColor:nil WithSpacing:0];
        [shopBtn addSubview:titleL_label];
        [titleL_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(img.mas_right).with.offset(12);
            make.centerY.mas_equalTo(shopBtn);
        }];
        
        shopBtn.rewardPoints_label=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
        [shopBtn addSubview:shopBtn.rewardPoints_label];
        shopBtn.rewardPoints_label.font=[regular get_en_Font:12.0f];
        [shopBtn.rewardPoints_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(shopBtn);
            make.left.mas_equalTo(titleL_label.mas_right).with.offset(3);
        }];

    }
    return shopBtn;
}

//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(33, 0, _kframe.size.width-33, _kframe.size.height);
//}
//-(CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(0, (_kframe.size.height-(_size.height/_size.width)*21)/2.0f, 21, (_size.height/_size.width)*21);
//}

@end
