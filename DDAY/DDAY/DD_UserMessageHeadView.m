//
//  DD_UserMessageHeadView.m
//  YCO SPACE
//
//  Created by yyj on 16/9/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_UserMessageHeadView.h"

@implementation DD_UserMessageHeadView
{
    UILabel *title;
    UIImageView *redCircle;
}

-(instancetype)initWithFrame:(CGRect)frame WithUserMessageModel:(DD_UserMessageModel *)messageModel WithSection:(NSInteger )section  WithBlock:(void(^)(NSString *type,NSInteger section))block
{
    self=[super initWithFrame:frame];
    if(self)
    {
        _messageModel=messageModel;
        _block=block;
        _section=section;
        self.backgroundColor=_define_white_color;
        self.userInteractionEnabled=YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)]];
        title=[UILabel getLabelWithAlignment:0 WithTitle:_messageModel.messageCategory WithFont:13.0f WithTextColor:nil WithSpacing:0];
        [self addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            make.centerY.mas_equalTo(self);
        }];
        
        redCircle=[UIImageView getCustomImg];
        [self addSubview:redCircle];
        redCircle.layer.masksToBounds=YES;
        redCircle.layer.cornerRadius=3;
        redCircle.backgroundColor=_define_light_red_color;
        if(_messageModel.readStatus)
        {
            redCircle.hidden=YES;
        }else
        {
            redCircle.hidden=NO;
        }
        [redCircle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(title.mas_right).with.offset(7);
            make.bottom.mas_equalTo(title.mas_top).with.offset(0);
            make.width.height.mas_equalTo(6);
        }];
    }
    return self;
}
-(void)clickAction:(UIGestureRecognizer *)ges
{
    _block(@"click",_section);
}
@end
