//
//  DD_DDAYOfflineCell.m
//  YCOSPACE
//
//  Created by yyj on 2016/12/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DDAYOfflineCell.h"

#import "DD_DDAYTool.h"
#import "DD_DDAYModel.h"

@implementation DD_DDAYOfflineCell
{
    dispatch_source_t _timer;
    
    UIImageView *_backImg;
    UIView *backview;
    UIView *_namebackview;
    
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_signLabel;
    
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
            make.edges.equalTo(self.contentView);
        }];
        
        backview=[UIView getCustomViewWithColor:nil];
        [_backImg addSubview:backview];
        backview.backgroundColor=_define_white_color;
        backview.alpha=0.9;
        [backview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(IsPhone6_gt?37:kEdge);
            make.right.mas_equalTo(IsPhone6_gt?-37:-kEdge);
            make.height.mas_equalTo(65);
            make.bottom.mas_equalTo(-50);
        }];
        
        _namebackview=[UIView getCustomViewWithColor:nil];
        [backview addSubview:_namebackview];
        [_namebackview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(37);
        }];
        
        _nameLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:18 WithTextColor:_define_white_color WithSpacing:0];
        [_namebackview addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(37);
            make.centerX.mas_equalTo(_namebackview);
        }];
        
        _signLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"活动" WithFont:13.0f WithTextColor:nil WithSpacing:0];
        [_namebackview addSubview:_signLabel];
        _signLabel.backgroundColor=_define_white_color;
        [_signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).with.offset(5);
            make.centerY.mas_equalTo(_nameLabel);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(17);
        }];
        _signLabel.layer.masksToBounds=YES;
        _signLabel.layer.cornerRadius=3;
        
        _timeLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:15 WithTextColor:nil WithSpacing:0];
        [backview addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(backview);
            make.centerY.mas_equalTo(backview.mas_bottom).with.offset(-14);
        }];
        
    }
    return self;
}
#pragma mark - SomeState
//活动结束之前
-(void)BeforeSaleEnd
{
    [self startTimeWithType:@"BeforeSaleEnd"];
    _timeLabel.text=[[NSString alloc] initWithFormat:@"%@ · %@",_DDAYModel.saleTimeStr,_DDAYModel.city];
}
//活动结束之后
-(void)AfterSaleEnd
{
    _timeLabel.text=@"活动已结束";
}

#pragma mark - SomeAction

/**
 * 定时器,1s触发一次
 */
-(void)timerCountStartWithTime:(long )time WithType:(NSString *)type
{
    double delayInSeconds = time;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if([type isEqualToString:@"beforeSaleEnd"])
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
    if([type isEqualToString:@"BeforeSaleEnd"])
    {
        //活动结束前
        timeout=_DDAYModel.saleEndTime-[NSDate nowTime];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout==0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                if([type isEqualToString:@"BeforeSaleEnd"])
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
                }else
                {
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
    
    _timeLabel.textColor=[UIColor colorWithHexString:_DDAYModel.seriesColor];
    _namebackview.backgroundColor=[UIColor colorWithHexString:_DDAYModel.seriesColor];
    _nameLabel.text=_DDAYModel.name;
    _signLabel.textColor=[UIColor colorWithHexString:_DDAYModel.seriesColor];
    CGFloat _width=[regular getWidthWithHeight:9999999 WithContent:_DDAYModel.name WithFont:[regular getFont:18.0f]];
    if(_width<(ScreenWidth-2*(kEdge)-60))
    {
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(37);
            make.centerX.mas_equalTo(_namebackview);
        }];
        
        [_signLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).with.offset(5);
            make.centerY.mas_equalTo(_nameLabel);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(17);
        }];
    }else
    {
        [_signLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(_nameLabel.mas_right).with.offset(0);
            make.width.mas_equalTo(30);
            make.right.mas_equalTo(-5);
            make.centerY.mas_equalTo(_nameLabel);
            make.height.mas_equalTo(17);
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(37);
            make.centerX.mas_equalTo(_namebackview);
            make.left.mas_equalTo(40);
            make.right.mas_equalTo(-40);
        }];
    }
    
    
    [_backImg JX_ScaleAspectFill_loadImageUrlStr:_DDAYModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    
    
    long nowTime=[NSDate nowTime];
    if(nowTime<_DDAYModel.saleEndTime)
    {
        //活动结束之前
        [self BeforeSaleEnd];
        [self timerCountStartWithTime:_DDAYModel.saleEndTime-[NSDate nowTime] WithType:@"beforeSaleEnd"];
    }else
    {
        //结束之后
        [self AfterSaleEnd];
    }
    
}

#pragma mark - Others
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
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
//#pragma mark - GetState
///**
// * 获取状态
// */
//-(NSString *)getState
//{
//    
//    long nowTime=[NSDate nowTime];
//    if(nowTime<_DDAYModel.saleEndTime)
//    {
//        //         发布中
//        //        距结束倒计时
//        return @"beforeSaleEnd";
//    }else
//    {
//        //        活动结束
//        return @"afterSaleEnd";
//    }
//}


@end
