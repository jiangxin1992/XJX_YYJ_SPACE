//
//  DD_ShopHeaderView.m
//  DDAY
//
//  Created by yyj on 16/5/30.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShopHeaderView.h"

#import "DD_ShopTool.h"

@implementation DD_ShopHeaderView
{
    UIButton *selectBtn;
    UILabel *serieslabel;
    UILabel *timeLabel;
}

-(instancetype)initWithFrame:(CGRect)frame WithSection:(NSInteger)section WithShopModel:(DD_ShopModel *)shopModel WithBlock:(void (^)(NSString *type,NSInteger section))block
{
    self=[super initWithFrame:frame];
    if(self)
    {
        _section=section;
        _shopModel=shopModel;
        _block=block;
        [self SomePrepare];
        [self UIConfig];
        [self SetState];
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
-(void)PrepareUI{}
-(void)setShopModel:(DD_ShopModel *)shopModel
{
    _shopModel=shopModel;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    self.backgroundColor = [UIColor clearColor];
    UIView *backview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 38)];
    [self addSubview:backview];
    backview.backgroundColor=[UIColor whiteColor];
    
    serieslabel=[[UILabel alloc] initWithFrame:CGRectMake(80,0, (ScreenWidth-80)/2.0f, 38)];
    [backview addSubview:serieslabel];
    serieslabel.textAlignment=0;
    
    timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(serieslabel.frame),0, (ScreenWidth-80)/2.0f, 38)];
    [backview addSubview:timeLabel];
    timeLabel.textAlignment=0;
    timeLabel.textColor=[UIColor blueColor];
    timeLabel.font=[regular get_en_Font:11.f];
    
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backview addSubview:selectBtn];
    selectBtn.frame=CGRectMake(0, 0, 70, 38);
    [selectBtn addTarget:self action:@selector(chooseAction) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.titleLabel.font=[regular getFont:13.0f];
    [selectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [selectBtn setTitle:@"取消全选" forState:UIControlStateSelected];
    [selectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
}
#pragma mark - SetState
-(void)SetState
{
    DD_ShopSeriesModel *_seriesModel = [DD_ShopTool getNumberSection:_section WithModel:_shopModel];
    [regular dispatch_cancel:_seriesModel.timer];
    BOOL _isselect=[DD_ShopTool selectAllWithModel:_shopModel WithSection:_section];
    selectBtn.selected=_isselect;
    
    if(![DD_ShopTool isInvalidWithSection:_section WithModel:_shopModel])
    {
        serieslabel.textColor=[UIColor blackColor];
    }else
    {
        serieslabel.textColor=[UIColor lightGrayColor];
    }
    serieslabel.text=[[NSString alloc] initWithFormat:@"系列：%@",_seriesModel.seriesName];
    if([regular date]<_seriesModel.saleEndTime&&[regular date]>=_seriesModel.saleStartTime)
    {
        [self startTime];
    }
    
}
#pragma mark - SomeAction
-(void)chooseAction
{
    if(![DD_ShopTool isInvalidWithSection:_section WithModel:_shopModel])
    {
        if(selectBtn.selected)
        {
            selectBtn.selected=NO;
            _block(@"cancel_all",_section);
        }else
        {
            selectBtn.selected=YES;
            _block(@"select_all",_section);
        }
    }
}
-(void)startTime{
    DD_ShopSeriesModel *_seriesModel = [DD_ShopTool getNumberSection:_section WithModel:_shopModel];
    __block long timeout=_seriesModel.saleEndTime-[regular date]; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _seriesModel.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_seriesModel.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_seriesModel.timer, ^{
        if(timeout==0){ //倒计时结束，关闭
            dispatch_source_cancel(_seriesModel.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                timeLabel.text=@"";
                _block(@"refresh",_section);
            });
        }else{
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
                    timeLabel.text=@"";
                    _block(@"refresh",_section);
                }else
                {
                    timeLabel.text=[[NSString alloc] initWithFormat:@"%ld天%ld时%ld分%ld秒",[d day],[d hour],[d minute],[d second]];
                }
                timeout--;
            });
        }
    });
    dispatch_resume(_seriesModel.timer);
}

@end
