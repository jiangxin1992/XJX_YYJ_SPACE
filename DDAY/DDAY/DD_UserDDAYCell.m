//
//  DD_UserDDAYCell.m
//  YCO SPACE
//
//  Created by yyj on 16/8/8.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserDDAYCell.h"

@implementation DD_UserDDAYCell
{
    UIImageView *imageView;
    UILabel *startLabel;
    UILabel *endLabel;
    UILabel *titlelabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
//        290
        UIView *line=[UIView getCustomViewWithColor:_define_black_color];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(37);
            make.top.mas_equalTo(11);
            make.bottom.mas_equalTo(-11);
            make.width.mas_equalTo(3);
        }];
        
        UIView *backimg=[UIView getCustomViewWithColor:nil];
        [self.contentView addSubview:backimg];
        [regular setBorder:backimg];
        [backimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(line.mas_right).with.offset(29);
            make.centerY.mas_equalTo(self.contentView);
            make.height.width.mas_equalTo(122);
        }];
        
        imageView=[UIImageView getCustomImg];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(backimg);
            make.width.height.mas_equalTo(109);
        }];
//        12 6 6
        titlelabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:18.0f WithTextColor:nil WithSpacing:0];
        [self.contentView addSubview:titlelabel];
        titlelabel.numberOfLines=2;
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backimg.mas_right).with.offset(29);
            make.right.mas_equalTo(-kEdge);
            make.top.mas_equalTo(11);
        }];
        [titlelabel sizeToFit];
        
        startLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:nil WithSpacing:0];
        [self.contentView addSubview:startLabel];
        [startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titlelabel);
            make.right.mas_equalTo(-kEdge);
            make.top.mas_equalTo(titlelabel.mas_bottom).with.offset(12);
        }];
        [startLabel sizeToFit];
        
        UIView *middleline=[UIView getCustomViewWithColor:_define_black_color];
        [self.contentView addSubview:middleline];
        [middleline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titlelabel);
            make.top.mas_equalTo(startLabel.mas_bottom).with.offset(6);
            make.height.mas_equalTo(3);
            make.width.mas_equalTo(16);
        }];
        
        endLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:nil WithSpacing:0];
        [self.contentView addSubview:endLabel];
        [endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titlelabel);
            make.right.mas_equalTo(-kEdge);
            make.top.mas_equalTo(middleline.mas_bottom).with.offset(6);
        }];
        [endLabel sizeToFit];
        
    }
    return self;
}
-(void)setDDAYModel:(DD_DDAYModel *)DDAYModel
{
    _DDAYModel=DDAYModel;
    [imageView JX_loadImageUrlStr:DDAYModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    titlelabel.text=DDAYModel.name;
    NSLog(@"start=%@,end=%@",[regular getTimeStr:DDAYModel.saleStartTime WithFormatter:@"YYYY-MM-dd HH:mm"],[regular getTimeStr:DDAYModel.saleEndTime WithFormatter:@"YYYY-MM-dd HH:mm"]);
    startLabel.text=[regular getTimeStr:DDAYModel.saleStartTime WithFormatter:@"YYYY-MM-dd HH:mm"];
    endLabel.text=[regular getTimeStr:DDAYModel.saleEndTime WithFormatter:@"YYYY-MM-dd HH:mm"];
}
@end
