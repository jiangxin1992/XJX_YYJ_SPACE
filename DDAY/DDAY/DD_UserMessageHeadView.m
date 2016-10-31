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
    UILabel *_title;
    UIImageView *_redCircle;
    UILabel *_notNumLabel;
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
        _title=[UILabel getLabelWithAlignment:0 WithTitle:_messageModel.messageCategory WithFont:15.0f WithTextColor:nil WithSpacing:0];
        [self addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            make.centerY.mas_equalTo(self);
        }];
        
        if(_messageModel.isNotice)
        {
            
            if(!_notNumLabel)
            {
                _notNumLabel=[UILabel getLabelWithAlignment:1 WithTitle:[[NSString alloc] initWithFormat:@"%ld",_messageModel.unReadMessageNumber] WithFont:13.0f WithTextColor:_define_white_color WithSpacing:0];
            }else
            {
                _notNumLabel.text=[[NSString alloc] initWithFormat:@"%ld",_messageModel.unReadMessageNumber];
            }
            [self addSubview:_notNumLabel];
            _notNumLabel.textColor=_define_white_color;
            _notNumLabel.backgroundColor=_define_light_red_color;
            [_notNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_title.mas_right).with.offset(0);
                make.centerY.mas_equalTo(_title.mas_top);
                make.height.mas_equalTo(20);
                make.width.mas_equalTo(20);
            }];
            _notNumLabel.layer.masksToBounds=YES;
            _notNumLabel.layer.cornerRadius=10;
            if(_messageModel.unReadMessageNumber)
            {
                _notNumLabel.hidden=NO;
            }else
            {
                _notNumLabel.hidden=YES;
            }
        }else
        {
            _redCircle=[UIImageView getCustomImg];
            [self addSubview:_redCircle];
            _redCircle.layer.masksToBounds=YES;
            _redCircle.layer.cornerRadius=3;
            _redCircle.backgroundColor=_define_light_red_color;
            if(_messageModel.readStatus)
            {
                _redCircle.hidden=YES;
            }else
            {
                _redCircle.hidden=NO;
            }
            [_redCircle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_title.mas_right).with.offset(7);
                make.bottom.mas_equalTo(_title.mas_top).with.offset(0);
                make.width.height.mas_equalTo(6);
            }];
        }
        
        
    }
    return self;
}
-(void)clickAction:(UIGestureRecognizer *)ges
{
    _block(@"click",_section);
}
@end
