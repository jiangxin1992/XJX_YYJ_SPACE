//
//  DD_DDAYDetailView.m
//  DDAY
//
//  Created by yyj on 16/6/2.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DDAYDetailView.h"

@implementation DD_DDAYDetailView
{
    UILabel *leftLabel;
    UIButton *rightBtn;
    dispatch_source_t _timer;
    BOOL _is_back;
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
-(void)PrepareUI
{
    self.backgroundColor=_define_backview_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [self addSubview:view];
    view.backgroundColor=[UIColor blackColor];
    
    leftLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth/2.0f, ktabbarHeight-1)];
    [self addSubview:leftLabel];
    leftLabel.textAlignment=1;
    leftLabel.textColor=[UIColor blackColor];
    leftLabel.font=[regular getFont:11.0f];
    
    rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:rightBtn];
    rightBtn.frame=CGRectMake(ScreenWidth/2.0f, 1, ScreenWidth/2.0f, ktabbarHeight-1);
    rightBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [rightBtn setAdjustsImageWhenHighlighted:NO];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - SetState
-(void)setState
{
    [regular dispatch_cancel:_timer];
    if([[self getState] isEqualToString:@"beforeSignStart"])
    {
        //        报名开始之前
        [self BeforeSignStart];
        [self timerCountStartWithTime:_detailModel.signStartTime-[regular date] WithType:@"beforeSignStart"];
        
    }else if([[self getState] isEqualToString:@"beforeSignEnd"])
    {
        //        报名结束之前
        [self BeforeSignEnd];
        [self timerCountStartWithTime:_detailModel.signEndTime-[regular date] WithType:@"beforeSignEnd"];
        
    }else if([[self getState] isEqualToString:@"beforeSaleStart"])
    {
        //        发布会开始之前
        [self BeforeSaleStart];
        [self timerCountStartWithTime:_detailModel.saleStartTime-[regular date] WithType:@"beforeSaleStart"];
        
    }else if([[self getState] isEqualToString:@"beforeSaleEnd"])
    {
        //         发布中
        //        距结束倒计时
        [self BeforeSaleEnd];
        [self timerCountStartWithTime:_detailModel.saleEndTime-[regular date] WithType:@"beforeSaleEnd"];
        
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
    [self startTimeWithType:@"beforeSignStart"];
    //    倒计时
    rightBtn.selected=YES;
    [rightBtn setTitle:@"报名还没开始" forState:UIControlStateSelected];
}
//报名结束前
-(void)BeforeSignEnd
{
    if(_detailModel.isQuotaLimt)
    {
        leftLabel.text=[[NSString alloc] initWithFormat:@"剩余%ld个名额",_detailModel.leftQuota];
    }else
    {
        leftLabel.text=@"没有名额限制";
    }
    
    
    rightBtn.selected=NO;
    if(_detailModel.isJoin)
    {
        [rightBtn setTitle:@"成功报名发布会" forState:UIControlStateNormal];
    }else
    {
        [rightBtn setTitle:@"报名线上发布会" forState:UIControlStateNormal];
    }
    
}
//发布会开始之前
-(void)BeforeSaleStart
{
    leftLabel.text=@"报名已结束";
    
    rightBtn.selected=YES;
    [rightBtn setTitle:@"报名已结束" forState:UIControlStateSelected];
}
//发布会结束之前
-(void)BeforeSaleEnd
{
    [self startTimeWithType:@"beforeSaleEnd"];
    //    倒计时
    if(_detailModel.isJoin)
    {
        rightBtn.selected=NO;
        [rightBtn setTitle:@"进入发布会" forState:UIControlStateNormal];
    }else
    {
        rightBtn.selected=YES;
        [rightBtn setTitle:@"啊哦，错过了报名" forState:UIControlStateSelected];
    }
}
//发布会结束之后
-(void)AfterSaleEnd
{
    leftLabel.text=@"发布会已结束";
    if(_detailModel.isJoin)
    {
        rightBtn.selected=NO;
        [rightBtn setTitle:@"查看发布品" forState:UIControlStateNormal];
    }else
    {
        rightBtn.selected=YES;
        [rightBtn setTitle:@"啊哦，错过了报名" forState:UIControlStateSelected];
    }
    
}
#pragma mark - getState
/**
 * 获取状态
 */
-(NSString *)getState
{
    long nowTime=[regular date];
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
-(void)rightBtnAction
{
    
    if([[self getState] isEqualToString:@"beforeSignEnd"])
    {
        //        报名结束之前
        //        报名
        if(_detailModel.isJoin)
        {
            _block(@"cancel");
        }else
        {
            _block(@"join");
        }
        
    }else if([[self getState] isEqualToString:@"beforeSaleEnd"])
    {
        if(_detailModel.isJoin)
        {
            _block(@"enter_meet");
        }
    }else if([[self getState] isEqualToString:@"afterSaleEnd"])
    {
        if(_detailModel.isJoin)
        {
            _block(@"check_good");
        }
        
    }
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
 * 倒计时
 * 1s调用一次
 */
-(void)startTimeWithType:(NSString *)type
{
    //    beforeSignStart
    //    beforeSaleEnd
    __block long timeout=0; //倒计时时间
    if([type isEqualToString:@"beforeSignStart"])
    {
        timeout=_detailModel.signStartTime-[regular date];
    }else if([type isEqualToString:@"beforeSaleEnd"])
    {
        timeout=_detailModel.saleEndTime-[regular date];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout==0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                if([type isEqualToString:@"beforeSignStart"])
                {
                    [self BeforeSignEnd];
                }else if([type isEqualToString:@"beforeSaleEnd"])
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
                NSLog(@"____%@",strTime);
                NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
                //用来得到具体的时差
                unsigned int unitFlags =  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
                NSDateComponents *d = [cal components:unitFlags fromDate:[NSDate date] toDate:[NSDate dateWithTimeIntervalSince1970:[regular date]+timeout] options:0];
                
                if([d day]<0||[d hour]<0||[d minute]<0||[d second]<0)
                {
                    dispatch_source_cancel(_timer);
                    if([type isEqualToString:@"beforeSignStart"])
                    {
                        [self BeforeSignEnd];
                    }else if([type isEqualToString:@"beforeSaleEnd"])
                    {
                        [self AfterSaleEnd];
                    }
                }else
                {
                    leftLabel.text=[[NSString alloc] initWithFormat:@"%ld天%ld时%ld分%ld秒",[d day],[d hour],[d minute],[d second]];
                }
                timeout--;
            });
        }
    });
    dispatch_resume(_timer);
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
                [self timerCountStartWithTime:_detailModel.signEndTime-[regular date] WithType:@"beforeSignEnd"];
                
            }else if([type isEqualToString:@"beforeSignEnd"])
            {
                //        报名结束之前
                [self BeforeSaleStart];
                [self timerCountStartWithTime:_detailModel.saleStartTime-[regular date] WithType:@"beforeSaleStart"];
                
            }else if([type isEqualToString:@"beforeSaleStart"])
            {
                //        发布会开始之前
                [self BeforeSaleEnd];
                [self timerCountStartWithTime:_detailModel.saleEndTime-[regular date] WithType:@"beforeSaleEnd"];
                
                
            }else if([type isEqualToString:@"beforeSaleEnd"])
            {
                //         发布中
                //        距结束倒计时
                [self AfterSaleEnd];
            }
        }
        
    });
}


@end
