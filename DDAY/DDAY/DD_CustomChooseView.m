//
//  DD_CustomChooseView.m
//  YCOSPACE
//
//  Created by yyj on 2016/12/20.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CustomChooseView.h"

@implementation DD_CustomChooseView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)canceltitle otherButtonTitles:(NSString *)othertitle WithBlock:(void (^)(NSString *))block
{
    self=[super init];
    if(self)
    {
        _title=title;
        _message=message;
        _canceltitle=canceltitle;
        _othertitle=othertitle;
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
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=11;
    self.backgroundColor=_define_white_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    
    UILabel *titleLabel=[UILabel getLabelWithAlignment:1 WithTitle:_title WithFont:18.0f WithTextColor:_define_black_color WithSpacing:0];
    [self addSubview:titleLabel];
    titleLabel.font=[regular getSemiboldFont:18.0f];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(23);
        make.left.right.mas_equalTo(0);
    }];
    
    
    UILabel *messageLabel=[UILabel getLabelWithAlignment:0 WithTitle:_message WithFont:13.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [self addSubview:messageLabel];
    if([regular getWidthWithHeight:999999 WithContent:_message WithFont:[regular getFont:13.0f]]>(295-(kEdge)*2))
    {
        messageLabel.textAlignment=0;
    }else
    {
        messageLabel.textAlignment=1;
    }
    messageLabel.numberOfLines=0;
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(22);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
    }];
    
    UIButton *cancelButton=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:_canceltitle WithNormalColor:_define_light_orange_color WithSelectedTitle:nil WithSelectedColor:nil];
    cancelButton.layer.masksToBounds=YES;
    cancelButton.layer.borderColor=[_define_light_orange_color CGColor];
    cancelButton.layer.borderWidth=1;
    [self addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(messageLabel.mas_bottom).with.offset(23);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(116);
        make.left.mas_equalTo(21);
        make.bottom.mas_equalTo(-25);
    }];
    
    UIButton *otherButton=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:_othertitle WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:otherButton];
    [otherButton addTarget:self action:@selector(otherAction) forControlEvents:UIControlEventTouchUpInside];
    otherButton.backgroundColor=_define_light_orange_color;
    [otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cancelButton);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(116);
        make.right.mas_equalTo(-21);
    }];
}

-(void)cancelAction
{
    _block(@"cancel");
}
-(void)otherAction
{
    _block(@"other");
}
@end
