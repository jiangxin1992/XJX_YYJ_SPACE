//
//  DD_OrderLogisticsHeadView.m
//  YCO SPACE
//
//  Created by yyj on 16/8/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderLogisticsHeadView.h"

@implementation DD_OrderLogisticsHeadView{
    UILabel *log_name;
    UILabel *log_order;
    UILabel *state;
}
-(instancetype)initWithCircleListModel:(DD_OrderLogisticsManageModel *)model WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _LogisticsManageModel=model;
        [self UIConfig];
        [self setState];
    }
    return self;
}
-(void)UIConfig
{
    _head=[UIImageView getCustomImg];
    [self addSubview:_head];
    _head.contentMode=2;
    [regular setZeroBorder:_head];
    [_head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(20);
        make.height.width.mas_equalTo(50);
    }];
    
    log_name=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:log_name];
//    log_name.backgroundColor=[UIColor redColor];
    [log_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_head.mas_centerY).with.offset(-2);
        make.left.mas_equalTo(_head.mas_right).with.offset(10);
    }];
    
    log_order=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:log_order];
//    log_order.backgroundColor=[UIColor redColor];
    [log_order mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_head.mas_centerY).with.offset(2);
        make.left.mas_equalTo(_head.mas_right).with.offset(10);
    }];
    
    state=[UILabel getLabelWithAlignment:2 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:state];
    [state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_head.mas_centerY).with.offset(0);
        make.right.mas_equalTo(-38);
    }];

    
}
+ (CGFloat)heightWithModel:(DD_OrderLogisticsManageModel *)model
{
    DD_OrderLogisticsHeadView *headView=[[DD_OrderLogisticsHeadView alloc] initWithCircleListModel:model WithBlock:^(NSString *type) {
        
    }];
    [headView layoutIfNeeded];
    CGRect frame =  headView.head.frame;
    return frame.origin.y + frame.size.height+30;
}

-(void)setState
{
    [_head JX_ScaleAspectFill_loadImageUrlStr:_LogisticsManageModel.logo WithSize:400 placeHolderImageName:nil radius:0];
    log_name.text=_LogisticsManageModel.deliver;
    log_order.text=[[NSString alloc] initWithFormat:@"物流号：%@",_LogisticsManageModel.LogisticCode];
    state.text=_LogisticsManageModel.State_Str;
}

@end
