//
//  DD_DDAYCell.m
//  DDAY
//
//  Created by yyj on 16/6/1.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DDAYCell.h"

#import "DD_DDAYTool.h"
#import "DD_DDAYModel.h"

@implementation DD_DDAYCell
{
    dispatch_source_t _timer;
    
    UIImageView *_backImg;
    UIView *backview;
    UIView *backcolorview;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_stateLabel;
    
//    UIButton *_discountButton;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _backImg=[UIImageView getCustomImg];
        [self.contentView addSubview:_backImg];
        _backImg.userInteractionEnabled=NO;
        _backImg.contentMode=2;
        [regular setZeroBorder:_backImg];
        [_backImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        backview=[UIView getCustomViewWithColor:nil];
        [_backImg addSubview:backview];
        backview.backgroundColor=_define_white_color;
        backview.alpha=0.9;
        [backview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(IsPhone6_gt?37:kEdge);
            make.right.mas_equalTo(IsPhone6_gt?-37:-kEdge);
            make.bottom.mas_equalTo(-50);
        }];
        
        backcolorview=[UIView getCustomViewWithColor:nil];
        [backview addSubview:backcolorview];
        backcolorview.backgroundColor=_define_white_color;
        [backcolorview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
        }];
        
        _nameLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:18 WithTextColor:_define_white_color WithSpacing:0];
        [backcolorview addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.centerX.mas_equalTo(backcolorview);
        }];
        
//        _discountButton=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:13.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
//        [backcolorview addSubview:_discountButton];
//        _discountButton.contentEdgeInsets= UIEdgeInsetsMake( 0, 5, 0, 0);
//        [_discountButton setBackgroundImage:[UIImage imageNamed:@"DDAY_Discountframe_Cell"] forState:UIControlStateNormal];
//        [_discountButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(_nameLabel.mas_right).with.offset(5);
//            make.centerY.mas_equalTo(_nameLabel);
//            make.width.mas_equalTo(40);
//            make.height.mas_equalTo(22);
//        }];
        
        
        _timeLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:15 WithTextColor:_define_white_color WithSpacing:0];
        [backcolorview addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.mas_bottom).with.offset(0);
            make.height.mas_equalTo(25);
            make.bottom.left.right.mas_equalTo(0);
        }];
        
        _stateLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:15 WithTextColor:nil WithSpacing:0];
        [backview addSubview:_stateLabel];
        [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(backcolorview.mas_bottom).with.offset(0);
            make.height.mas_equalTo(25);
            make.bottom.left.right.mas_equalTo(0);
        }];
        
    }
    return self;
}
#pragma mark - SomeState

//发布会开始之前
-(void)BeforeSaleStart
{
    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
    }];
    _timeLabel.text=_DDAYModel.saleTimeStr;
    _stateLabel.text=@"发布会即将开始";
    [self startTimeWithType:@"BeforeSaleStart"];
}
//发布会结束之前
-(void)BeforeSaleEnd
{
    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
    }];
    _timeLabel.text=_DDAYModel.saleTimeStr;
    _stateLabel.text=@"发布会进行中";
    [self startTimeWithType:@"BeforeSaleEnd"];
}
//发布会结束之后
-(void)AfterSaleEnd
{
//    _timeLabel.text=[DD_DDAYTool getTimeStrWithTime:_DDAYModel.saleStartTime];
    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    _timeLabel.text=@"";
    _stateLabel.text=_DDAYModel.seriesTips;
}
#pragma mark - GetState
/**
 * 获取状态
 */
-(NSString *)getState
{
    
    long nowTime=[NSDate nowTime];
//    if(nowTime<_DDAYModel.signStartTime)
//    {
//        //        报名开始之前
//        return @"beforeSignStart";
//    }else if(nowTime<_DDAYModel.signEndTime)
//    {
//        //        报名结束之前
//        return @"beforeSignEnd";
//    }else
    if(nowTime<_DDAYModel.saleStartTime)
    {
        //        发布会开始之前
        return @"beforeSaleStart";
    }else if(nowTime<_DDAYModel.saleEndTime)
    {
        //         发布中
        //        距结束倒计时
        return @"beforeSaleEnd";
    }else if(nowTime>=_DDAYModel.saleEndTime)
    {
        //        发布会结束
        return @"afterSaleEnd";
    }
    return @"";
}

#pragma mark - SomeAction
//-(void)applyAction
//{
//    if([[self getState] isEqualToString:@"beforeSignEnd"])
//    {
//        //        报名结束之前
//        //        报名
//        if(_DDAYModel.isJoin)
//        {
//            _ddayblock(_index,@"cancel");
//        }else
//        {
//            _ddayblock(_index,@"join");
//        }
//    }
//}
//-(void)push_dday_detail
//{
//    _ddayblock(_index,@"push_detail");
//}
/**
 * 定时器,1s触发一次
 */
-(void)timerCountStartWithTime:(long )time WithType:(NSString *)type
{
    double delayInSeconds = time;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        //执行事件
//        if([type isEqualToString:@"beforeSignStart"])
//        {
//            //        报名开始之前
//            [self BeforeSignEnd];
//            [self timerCountStartWithTime:_DDAYModel.signEndTime-[NSDate nowTime] WithType:@"beforeSignEnd"];
//            
//        }else if([type isEqualToString:@"beforeSignEnd"])
//        {
//            //        报名结束之前
//            [self BeforeSaleStart];
//            [self timerCountStartWithTime:_DDAYModel.saleStartTime-[NSDate nowTime] WithType:@"beforeSaleStart"];
//            
//        }else
        if([type isEqualToString:@"beforeSaleStart"])
        {
            //        发布会开始之前
            [self BeforeSaleEnd];
            [self timerCountStartWithTime:_DDAYModel.saleEndTime-[NSDate nowTime] WithType:@"beforeSaleEnd"];
            
            
        }else if([type isEqualToString:@"beforeSaleEnd"])
        {
            //         发布中
            //        距结束倒计时
            [self AfterSaleEnd];
        }
    });
}
/**
 * 倒计时
 */
-(void)startTimeWithType:(NSString *)type
{
    __block long timeout=0;
    NSString *prefix_str=nil;
//    if([type isEqualToString:@"BeforeSignStart"])
//    {
//        timeout=_DDAYModel.signStartTime-[NSDate nowTime];
//        prefix_str=@"距报名开始  ";
//    }else if([type isEqualToString:@"BeforeSignEnd"])
//    {
//        timeout=_DDAYModel.signEndTime-[NSDate nowTime];
//        prefix_str=@"距报名结束  ";
//    }else
    if([type isEqualToString:@"BeforeSaleStart"])
    {
        timeout=_DDAYModel.saleStartTime-[NSDate nowTime];
        prefix_str=@"距发布会开始  ";
    }else
    {
        timeout=_DDAYModel.saleEndTime-[NSDate nowTime];
        prefix_str=@"距发布会结束  ";
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout==0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                if([type isEqualToString:@"BeforeSignStart"])
//                {
//                    [self BeforeSignEnd];
//                }else if([type isEqualToString:@"BeforeSignEnd"])
//                {
//                    [self BeforeSaleStart];
//                }else
                if([type isEqualToString:@"BeforeSaleStart"])
                {
                    [self BeforeSaleEnd];
                }else
                {
                    [self AfterSaleEnd];
                }
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                JXLOG(@"____%@",strTime);
                NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
                //用来得到具体的时差
                unsigned int unitFlags =  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
                NSDateComponents *d = [cal components:unitFlags fromDate:[NSDate nowDate] toDate:[NSDate dateWithTimeIntervalSince1970:[NSDate nowTime]+timeout] options:0];
                
                if([d day]<0||[d hour]<0||[d minute]<0||[d second]<0)
                {
                    dispatch_source_cancel(_timer);
//                    if([type isEqualToString:@"BeforeSignStart"])
//                    {
//                        [self BeforeSignEnd];
//                    }else if([type isEqualToString:@"BeforeSignEnd"])
//                    {
//                        [self BeforeSaleStart];
//                    }else
                    if([type isEqualToString:@"BeforeSaleStart"])
                    {
                        [self BeforeSaleEnd];
                    }else
                    {
                        [self AfterSaleEnd];
                    }
                }else
                {
//                    NSString *time_str=[[NSString alloc] initWithFormat:@"%ld天%ld时%ld分%ld秒",[d day],[d hour],[d minute],[d second]];;
//                    _timeLabel.text=[[NSString alloc] initWithFormat:@"%@%@",prefix_str,time_str];
                }
                timeout--;
            });
        }
    });
    dispatch_resume(_timer);
}


#pragma mark - SetDDAYModel
-(void)setDDAYModel:(DD_DDAYModel *)DDAYModel
{
    [regular dispatch_cancel:_timer];
    _DDAYModel=DDAYModel;
    
    _stateLabel.textColor=[UIColor colorWithHexString:_DDAYModel.seriesColor];
    backcolorview.backgroundColor=[UIColor colorWithHexString:_DDAYModel.seriesColor];
    _nameLabel.text=[[NSString alloc] initWithFormat:@"%@",_DDAYModel.name];
//    [_discountButton setTitle:_DDAYModel.discount forState:UIControlStateNormal];
    [_backImg JX_ScaleAspectFill_loadImageUrlStr:_DDAYModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    
//    CGFloat _width=[regular getWidthWithHeight:9999999 WithContent:_DDAYModel.name WithFont:[regular getFont:18.0f]];
//    if(_width<(ScreenWidth-2*(kEdge)-60))
//    {
//        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(0);
//            make.height.mas_equalTo(30);
//            make.centerX.mas_equalTo(backcolorview);
//        }];
//        
//        [_discountButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(_nameLabel.mas_right).with.offset(5);
//            make.centerY.mas_equalTo(_nameLabel);
//            make.width.mas_equalTo(40);
//            make.height.mas_equalTo(22);
//        }];
//    }else
//    {
//        [_discountButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//            //            make.left.mas_equalTo(_nameLabel.mas_right).with.offset(0);
//            make.width.mas_equalTo(40);
//            make.height.mas_equalTo(22);
//            make.right.mas_equalTo(-5);
//            make.centerY.mas_equalTo(_nameLabel);
//        }];
//        
//        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(0);
//            make.height.mas_equalTo(30);
//            make.centerX.mas_equalTo(backcolorview);
//            make.left.mas_equalTo(50);
//            make.right.mas_equalTo(-50);
//        }];
//    }
    
    
//    if([[self getState] isEqualToString:@"beforeSignStart"])
//    {
////        报名开始之前
//        [self BeforeSignStart];
//        [self timerCountStartWithTime:_DDAYModel.signStartTime-[NSDate nowTime] WithType:@"beforeSignStart"];
//        
//    }else if([[self getState] isEqualToString:@"beforeSignEnd"])
//    {
////        报名结束之前
//        [self BeforeSignEnd];
//        [self timerCountStartWithTime:_DDAYModel.signEndTime-[NSDate nowTime] WithType:@"beforeSignEnd"];
//        
//    }else
    if([[self getState] isEqualToString:@"beforeSaleStart"])
    {
//        发布会开始之前
        [self BeforeSaleStart];
        [self timerCountStartWithTime:_DDAYModel.saleStartTime-[NSDate nowTime] WithType:@"beforeSaleStart"];
        
    }else if([[self getState] isEqualToString:@"beforeSaleEnd"])
    {
//         发布中
//        距结束倒计时
        [self BeforeSaleEnd];
        [self timerCountStartWithTime:_DDAYModel.saleEndTime-[NSDate nowTime] WithType:@"beforeSaleEnd"];
        
    }else if([[self getState] isEqualToString:@"afterSaleEnd"])
    {
//        发布会结束
        [self AfterSaleEnd];
    }
}
////报名开始前
//-(void)BeforeSignStart
//{
//    [self startTimeWithType:@"BeforeSignStart"];
//}
////报名结束前
//-(void)BeforeSignEnd
//{
//    [self startTimeWithType:@"BeforeSignEnd"];
//}
#pragma mark - Others
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
