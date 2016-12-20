//
//  DD_DDAYOfflineDetailBar.m
//  YCOSPACE
//
//  Created by yyj on 2016/12/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DDAYOfflineDetailBar.h"

#import "DD_CustomBtn.h"

@implementation DD_DDAYOfflineDetailBar
{
    dispatch_source_t _timer;
    BOOL _is_back;
    
    UILabel *leftLabel;
    
    DD_CustomBtn *rightBtn;
    DD_CustomBtn *backBtn;
    
}
#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame WithGoodsDetailModel:(DD_DDayDetailModel *)model WithBlock:(void (^)(NSString *type))block
{
    self=[super initWithFrame:frame];
    if(self)
    {
        _detailModel=model;
        _block=block;
        [self SomePrepare];
        [self UIConfig];
        [self setState];
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData
{
    _is_back=NO;
}
-(void)PrepareUI{}
#pragma mark - UIConfig
-(void)UIConfig
{
    backBtn=[DD_CustomBtn getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_white_color WithSelectedTitle:@"" WithSelectedColor:_define_white_color];
    [self addSubview:backBtn];
    backBtn.frame=CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [backBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [regular setBorder:backBtn WithColor:[UIColor colorWithHexString:_detailModel.seriesColor] WithWidth:1];
    
    leftLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:18.0f WithTextColor:[UIColor colorWithHexString:_detailModel.seriesColor] WithSpacing:0];
    [backBtn addSubview:leftLabel];
    leftLabel.backgroundColor=_define_white_color;
    leftLabel.frame=CGRectMake(0, 1, ScreenWidth-150, ktabbarHeight-1);
    [regular setBorder:leftLabel WithColor:[UIColor colorWithHexString:_detailModel.seriesColor] WithWidth:1];
    
    
    rightBtn=[DD_CustomBtn getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_white_color WithSelectedTitle:@"" WithSelectedColor:_define_white_color];
    [backBtn addSubview:rightBtn];
    rightBtn.backgroundColor=[UIColor colorWithHexString:_detailModel.seriesColor];
    rightBtn.frame=CGRectMake(ScreenWidth-150, 1, 150, ktabbarHeight-1);
    [rightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - SetState
-(void)setState
{
    [regular dispatch_cancel:_timer];
    if([[self getState] isEqualToString:@"beforeSignStart"])
    {
        //        报名开始之前
        [self BeforeSignStart];
        [self timerCountStartWithTime:_detailModel.signStartTime-[NSDate nowTime] WithType:@"beforeSignStart"];
        
    }else if([[self getState] isEqualToString:@"beforeSignEnd"])
    {
        //        报名结束之前
        [self BeforeSignEnd];
        [self timerCountStartWithTime:_detailModel.signEndTime-[NSDate nowTime] WithType:@"beforeSignEnd"];
        
    }else if([[self getState] isEqualToString:@"beforeSaleStart"])
    {
        //        发布会开始之前
        [self BeforeSaleStart];
        [self timerCountStartWithTime:_detailModel.saleStartTime-[NSDate nowTime] WithType:@"beforeSaleStart"];
        
    }else if([[self getState] isEqualToString:@"beforeSaleEnd"])
    {
        //         发布中
        //        距结束倒计时
        [self BeforeSaleEnd];
        [self timerCountStartWithTime:_detailModel.saleEndTime-[NSDate nowTime] WithType:@"beforeSaleEnd"];
        
    }else if([[self getState] isEqualToString:@"afterSaleEnd"])
    {
        //        发布会结束
        [self AfterSaleEnd];
    }
}

#pragma mark - SomeState
//报名开始前
-(void)BeforeSignStart
{
    
    [self backBtnSubViewHide:YES];
    
    backBtn.selected=YES;
    backBtn.type=@"";
    [backBtn setTitle:_detailModel.signStartTimeStr forState:UIControlStateSelected];
    [backBtn setTitle:_detailModel.signStartTimeStr forState:UIControlStateSelected];
    [backBtn setTitleColor:[UIColor colorWithHexString:_detailModel.seriesColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor colorWithHexString:_detailModel.seriesColor] forState:UIControlStateSelected];
    backBtn.backgroundColor=_define_white_color;
}
//报名结束前
-(void)BeforeSignEnd
{
    //是否报名
    if(_detailModel.isJoin)
    {
        
        [self backBtnSubViewHide:YES];
        backBtn.selected=YES;
        [backBtn setTitleColor:[UIColor colorWithHexString:_detailModel.seriesColor] forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor colorWithHexString:_detailModel.seriesColor] forState:UIControlStateSelected];
        backBtn.backgroundColor=_define_white_color;
        [backBtn setTitle:@"已报名" forState:UIControlStateNormal];
        [backBtn setTitle:@"已报名" forState:UIControlStateSelected];
        backBtn.type=@"";
        
    }else
    {
        //是否有限制
        if(_detailModel.isQuotaLimt)
        {
            //还有没有名额
            if(_detailModel.leftQuota)
            {
                [self backBtnSubViewHide:NO];
                
                rightBtn.selected=NO;
                rightBtn.type=@"apply";
                [rightBtn setTitle:@"报名" forState:UIControlStateNormal];
                leftLabel.text=[[NSString alloc] initWithFormat:@"剩余名额%ld个",_detailModel.leftQuota];
                
            }else
            {
                [self backBtnSubViewHide:YES];
                backBtn.selected=YES;
                [backBtn setTitleColor:[UIColor colorWithHexString:_detailModel.seriesColor] forState:UIControlStateNormal];
                [backBtn setTitleColor:[UIColor colorWithHexString:_detailModel.seriesColor] forState:UIControlStateSelected];
                backBtn.backgroundColor=_define_white_color;
                [backBtn setTitle:@"名额已满，请关注下次活动" forState:UIControlStateNormal];
                [backBtn setTitle:@"名额已满，请关注下次活动" forState:UIControlStateSelected];
                backBtn.type=@"";
            }
        }else
        {
            [self backBtnSubViewHide:YES];
            backBtn.selected=NO;
            [backBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
            [backBtn setTitleColor:_define_white_color forState:UIControlStateSelected];
            backBtn.backgroundColor=[UIColor colorWithHexString:_detailModel.seriesColor];
            [backBtn setTitle:@"报名" forState:UIControlStateNormal];
            [backBtn setTitle:@"报名" forState:UIControlStateSelected];
            backBtn.type=@"apply";
        }
    }
}
//发布会开始之前
-(void)BeforeSaleStart
{
    [self backBtnSubViewHide:YES];
    //    倒计时
    backBtn.selected=YES;
    backBtn.type=@"";
    [backBtn setTitleColor:[UIColor colorWithHexString:_detailModel.seriesColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor colorWithHexString:_detailModel.seriesColor] forState:UIControlStateSelected];
    backBtn.backgroundColor=_define_white_color;
    [backBtn setTitle:_detailModel.isJoin?@"已报名":@"啊哦，错过了报名" forState:UIControlStateSelected];
    [backBtn setTitle:_detailModel.isJoin?@"已报名":@"啊哦，错过了报名" forState:UIControlStateNormal];
}
//发布会结束之前
-(void)BeforeSaleEnd
{
    [self backBtnSubViewHide:YES];
    //    倒计时
    backBtn.selected=YES;
    backBtn.type=@"";
    [backBtn setTitleColor:[UIColor colorWithHexString:_detailModel.seriesColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor colorWithHexString:_detailModel.seriesColor] forState:UIControlStateSelected];
    backBtn.backgroundColor=_define_white_color;
    [backBtn setTitle:_detailModel.isJoin?@"活动已经开始，请及时参加":@"啊哦，错过了报名" forState:UIControlStateSelected];
    [backBtn setTitle:_detailModel.isJoin?@"活动已经开始，请及时参加":@"啊哦，错过了报名" forState:UIControlStateNormal];
}
//发布会结束之后
-(void)AfterSaleEnd
{
    [self backBtnSubViewHide:YES];
    //    倒计时
    backBtn.selected=YES;
    backBtn.type=@"";
    [backBtn setTitleColor:[UIColor colorWithHexString:_detailModel.seriesColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor colorWithHexString:_detailModel.seriesColor] forState:UIControlStateSelected];
    backBtn.backgroundColor=_define_white_color;
    [backBtn setTitle:@"活动已结束" forState:UIControlStateSelected];
    [backBtn setTitle:@"活动已结束" forState:UIControlStateNormal];
}
#pragma mark - getState
/**
 * 获取状态
 */
-(NSString *)getState
{
    long nowTime=[NSDate nowTime];
    if(nowTime<_detailModel.signStartTime)
    {
        //        报名开始之前
        return @"beforeSignStart";
    }else if(nowTime<_detailModel.signEndTime)
    {
        //        报名结束之前
        return @"beforeSignEnd";
    }else if(nowTime<_detailModel.saleStartTime)
    {
        //        发布会开始之前
        return @"beforeSaleStart";
    }else if(nowTime<_detailModel.saleEndTime)
    {
        //         发布中
        //        距结束倒计时
        return @"beforeSaleEnd";
    }else if(nowTime>=_detailModel.saleEndTime)
    {
        //        发布会结束
        return @"afterSaleEnd";
    }
    return @"";
}
#pragma mark - SomeAction
-(void)backBtnSubViewHide:(BOOL)hide
{
    leftLabel.hidden=hide;
    rightBtn.hidden=hide;
}
-(void)btnAction:(DD_CustomBtn *)btn
{
    if([btn.type isEqualToString:@"apply"])
    {
        _block(@"join");
    }else if([btn.type isEqualToString:@"cancel"])
    {
        _block(@"cancel");
    }
//    else if([btn.type isEqualToString:@"check_good"])
//    {
//        _block(@"check_good");
//    }else if([btn.type isEqualToString:@"enter_meet"])
//    {
//        _block(@"enter_meet");
//    }
}
/**
 * 取消当前线程
 * 视图退出时候
 */
-(void)cancelTime
{
    _is_back=YES;
    [regular dispatch_cancel:_timer];
}

/**
 * 定时器
 */
-(void)timerCountStartWithTime:(long )time WithType:(NSString *)type
{
    double delayInSeconds = time;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(!_is_back)
        {
            //执行事件
            if([type isEqualToString:@"beforeSignStart"])
            {
                //        报名开始之前
                [self BeforeSignEnd];
                [self timerCountStartWithTime:_detailModel.signEndTime-[NSDate nowTime] WithType:@"beforeSignEnd"];
                
            }else if([type isEqualToString:@"beforeSignEnd"])
            {
                //        报名结束之前
                [self BeforeSaleStart];
                [self timerCountStartWithTime:_detailModel.saleStartTime-[NSDate nowTime] WithType:@"beforeSaleStart"];
                
            }else if([type isEqualToString:@"beforeSaleStart"])
            {
                //        发布会开始之前
                [self BeforeSaleEnd];
                [self timerCountStartWithTime:_detailModel.saleEndTime-[NSDate nowTime] WithType:@"beforeSaleEnd"];
                
            }else if([type isEqualToString:@"beforeSaleEnd"])
            {
                //         发布中
                //        距结束倒计时
                [self AfterSaleEnd];
            }
        }
        
    });
}
/**
 * 倒计时
 * 1s调用一次
 */
//-(void)startTimeWithType:(NSString *)type
//{
//    //    beforeSignStart
//    //    beforeSaleEnd
//    __block long timeout=0; //倒计时时间
//    if([type isEqualToString:@"beforeSignStart"])
//    {
//        timeout=_detailModel.signStartTime-[NSDate nowTime];
//    }else if([type isEqualToString:@"beforeSaleStart"])
//    {
//        timeout=_detailModel.saleStartTime-[NSDate nowTime];
//    }
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        if(timeout==0){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                if([type isEqualToString:@"beforeSignStart"])
//                {
//                    [self BeforeSignEnd];
//                }else if([type isEqualToString:@"beforeSaleStart"])
//                {
//                    [self BeforeSaleEnd];
//                }
//                
//            });
//        }else{
//            //            int minutes = timeout / 60;
//            int seconds = timeout % 60;
//            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                //设置界面的按钮显示 根据自己需求设置
//                JXLOG(@"____%@",strTime);
//                NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
//                //用来得到具体的时差
//                unsigned int unitFlags =  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//                NSDateComponents *d = [cal components:unitFlags fromDate:[NSDate nowDate] toDate:[NSDate dateWithTimeIntervalSince1970:[NSDate nowTime]+timeout] options:0];
//                
//                if([d day]<0||[d hour]<0||[d minute]<0||[d second]<0)
//                {
//                    dispatch_source_cancel(_timer);
//                    if([type isEqualToString:@"beforeSignStart"])
//                    {
//                        [self BeforeSignEnd];
//                    }else if([type isEqualToString:@"beforeSaleEnd"])
//                    {
//                        [self BeforeSaleEnd];
//                    }
//                }else
//                {
//                    leftLabel.text=[[NSString alloc] initWithFormat:@"%ld 天 %ld : %ld : %ld",[d day],[d hour],[d minute],[d second]];
//                }
//                timeout--;
//            });
//        }
//    });
//    dispatch_resume(_timer);
//}
//#pragma mark - SomeState
////报名开始前
//-(void)BeforeSignStart
//{
//    
//    [self backBtnSubViewHide:NO];
//    
//    leftLabel.textColor=[UIColor colorWithHexString:_detailModel.seriesColor];
//    
//    rightBtn.selected=YES;
//    [rightBtn setTitle:@"报名线上发布会" forState:UIControlStateSelected];
//    rightBtn.type=@"";
//    rightBtn.backgroundColor=[UIColor colorWithHexString:_detailModel.seriesColor];
//    
//    [self startTimeWithType:@"beforeSignStart"];
//}
////报名结束前
//-(void)BeforeSignEnd
//{
//    if(_detailModel.isQuotaLimt)
//    {
//        [self backBtnSubViewHide:NO];
//        if(_detailModel.isJoin)
//        {
//            
//            leftLabel.textColor=[UIColor colorWithHexString:_detailModel.seriesColor];
//            rightBtn.selected=NO;
//            rightBtn.backgroundColor=[UIColor colorWithHexString:_detailModel.seriesColor];
//            rightBtn.type=@"cancel";
//            [rightBtn setTitle:@"取消报名" forState:UIControlStateNormal];
//        }else
//        {
//            if(_detailModel.leftQuota)
//            {
//                leftLabel.textColor=[UIColor colorWithHexString:_detailModel.seriesColor];
//                rightBtn.selected=NO;
//                rightBtn.backgroundColor=[UIColor colorWithHexString:_detailModel.seriesColor];
//                rightBtn.type=@"apply";
//                [rightBtn setTitle:@"报名线上发布会" forState:UIControlStateNormal];
//            }else
//            {
//                leftLabel.textColor=[UIColor colorWithHexString:_detailModel.seriesColor];
//                rightBtn.selected=YES;
//                rightBtn.backgroundColor=[UIColor colorWithHexString:_detailModel.seriesColor];
//                rightBtn.type=@"";
//                [rightBtn setTitle:@"报名线上发布会" forState:UIControlStateSelected];
//            }
//        }
//        leftLabel.text=[[NSString alloc] initWithFormat:@"剩余%ld个名额",_detailModel.leftQuota];
//        
//    }else
//    {
//        [self backBtnSubViewHide:YES];
//        
//        NSString *title=nil;
//        NSString *type_str=nil;
//        if(_detailModel.isJoin)
//        {
//            title=@"取消报名";
//            type_str=@"cancel";
//        }else
//        {
//            title=@"报名线上发布会";
//            type_str=@"apply";
//        }
//        backBtn.selected=NO;
//        backBtn.backgroundColor=[UIColor colorWithHexString:_detailModel.seriesColor];
//        backBtn.type=type_str;
//        [backBtn setTitle:title forState:UIControlStateNormal];
//    }
//    
//}
////发布会开始之前
//-(void)BeforeSaleStart
//{
//    //    倒计时
//    if(_detailModel.isJoin)
//    {
//        [self backBtnSubViewHide:NO];
//        leftLabel.textColor=[UIColor colorWithHexString:_detailModel.seriesColor];
//        
//        rightBtn.selected=YES;
//        rightBtn.type=@"";
//        rightBtn.backgroundColor=[UIColor colorWithHexString:_detailModel.seriesColor];
//        [rightBtn setTitle:@"已报名" forState:UIControlStateSelected];
//        [self startTimeWithType:@"beforeSaleStart"];
//    }else
//    {
//        [self backBtnSubViewHide:YES];
//        backBtn.selected=YES;
//        backBtn.type=@"";
//        backBtn.backgroundColor=[UIColor colorWithHexString:_detailModel.seriesColor];
//        [backBtn setTitle:@"啊哦，错过了报名" forState:UIControlStateSelected];
//    }
//}
////发布会结束之前
//-(void)BeforeSaleEnd
//{
//    [self backBtnSubViewHide:YES];
//    //    倒计时
//    if(_detailModel.isJoin)
//    {
//        backBtn.selected=NO;
//        backBtn.type=@"enter_meet";
//        backBtn.backgroundColor=[UIColor colorWithHexString:_detailModel.seriesColor];
//        [backBtn setTitle:@"进入发布会" forState:UIControlStateNormal];
//    }else
//    {
//        backBtn.selected=YES;
//        backBtn.type=@"";
//        backBtn.backgroundColor=[UIColor colorWithHexString:_detailModel.seriesColor];
//        [backBtn setTitle:@"啊哦，错过了报名" forState:UIControlStateSelected];
//        JXLOG(@"111");
//    }
//}
////发布会结束之后
//-(void)AfterSaleEnd
//{
//    [self backBtnSubViewHide:NO];
//    
//    leftLabel.textColor=[UIColor colorWithHexString:_detailModel.seriesColor];
//    leftLabel.text=@"发布会已结束";
//    
//    [rightBtn setTitle:@"查看发布品" forState:UIControlStateNormal];
//    rightBtn.selected=NO;
//    
//    rightBtn.backgroundColor=[UIColor colorWithHexString:_detailModel.seriesColor];
//    rightBtn.type=@"check_good";
//}
@end