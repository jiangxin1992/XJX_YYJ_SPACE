//
//  DD_GoodInformView.m
//  DDAY
//
//  Created by yyj on 16/5/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#import "UIButton+WebCache.h"
#import "DD_GoodInformView.h"
#import "DD_ColorsModel.h"
@implementation DD_GoodInformView
{
    UIView *downView;//下部视图
    UIView *upview;//上部视图
    dispatch_source_t _timer;//计时线程/页面退出时销毁
    NSMutableArray *_imageArr;//存放颜色按钮的数组
    CGFloat _height;//视图高度
    UIWebView *_web;
    UIButton *collect_btn;
}
#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame WithGoodsDetailModel:(DD_GoodsDetailModel *)model WithBlock:(void (^)(NSString *type,CGFloat height))block
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
    _height=0;
    _imageArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
//    self.backgroundColor=_define_backview_color;
}
#pragma mark - setState
/**
 * UI创建完之后设置状态
 */
-(void)setState
{
    collect_btn.selected=_detailModel.item.isCollect;
    [self setItemTimeStr];
    [self setColorState];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateInformView];
    [self CreateIntroduceView];
}
-(void)CreateInformView
{
    [self CreateUpView];
    [self CreateTitle];
    [self CreateImagePic];
    [self CreateBuyShopBtn];
}
-(void)CreateUpView
{
    upview=[[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 410)];
    upview.backgroundColor=[UIColor whiteColor];
    [self addSubview:upview];
}
/**
 * 创建购物车 购买按钮
 */
-(void)CreateBuyShopBtn
{
    NSArray *titleArr=@[@"立即购买",@"加入购物车"];
    for (int i=0; i<titleArr.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [upview addSubview:btn];
        if(i==0)
        {
            [btn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
        }else
        {
            [btn addTarget:self action:@selector(shopAction) forControlEvents:UIControlEventTouchUpInside];
        }
        btn.frame=CGRectMake(10, 280+60*i, ScreenWidth-20, 50);
        btn.backgroundColor=[UIColor blackColor];
        [btn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
    }
    upview.frame=CGRectMake(0,0,ScreenWidth, 410);
}
/**
 * 创建颜色视图
 */
-(void)CreateImagePic
{
    NSArray *_colorsArr=_detailModel.item.colors;
    for (int i=0; i<_colorsArr.count;i++) {
        DD_ColorsModel *_colorModel=[_colorsArr objectAtIndex:i];
        UIButton  *imageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame=CGRectMake(10+100*i, 170, 90, 90);
        [upview addSubview:imageBtn];
        [imageBtn sd_setImageWithURL:[NSURL URLWithString:[regular getImgUrl:_colorModel.colorPic WithSize:800]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headImg_login1"]];
        [imageBtn sd_setImageWithURL:[NSURL URLWithString:[regular getImgUrl:_colorModel.colorPic WithSize:800]] forState:UIControlStateSelected placeholderImage:[UIImage imageNamed:@"headImg_login1"]];
        imageBtn.tag=200+i;
        [imageBtn addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_imageArr addObject:imageBtn];
    }
}
/**
 * 创建标题视图
 */
-(void)CreateTitle
{
    NSArray *titleArr=@[_detailModel.item.itemName,[self getPriceStr],@"",@"颜色"];
    for (int i=0; i<titleArr.count; i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10,10+40*i, 250, 30)];
        [upview addSubview:label];
        label.textAlignment=0;
        label.textColor=[UIColor blackColor];
        label.font=[regular getFont:17.0f];
        label.tag=100+i;
        label.text=titleArr[i];
    }
    
    collect_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [upview addSubview:collect_btn];
    collect_btn.frame=CGRectMake(270,10, 80, 30);
    [collect_btn setTitle:@"收藏" forState:UIControlStateNormal];
    [collect_btn setTitle:@"取消收藏" forState:UIControlStateSelected];
    collect_btn.titleLabel.font=[regular getFont:13.0f];
    [collect_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [collect_btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [collect_btn addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)CreateDownView
{
    downView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upview.frame)+10, ScreenWidth, 1000)];
    [self addSubview:downView];
    downView.backgroundColor=[UIColor whiteColor];
}
-(void)CreateIntroduceView
{
    [self CreateDownView];
    [self CreateDesView];
    
}
-(void)CreateDesView
{
    UILabel *_type_label=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 40)];
    [downView addSubview:_type_label];
    _type_label.textAlignment=0;
    _type_label.textColor=[UIColor lightGrayColor];
    _type_label.text=@"款式信息";
    [self loadWebview];
    
}
-(void)loadWebview
{
    
    _web=[[UIWebView alloc] initWithFrame:CGRectMake(10, 40, ScreenWidth-20, 10)];
    _web.backgroundColor = [UIColor clearColor];
    _web.delegate=self;
    
    NSString *font=@"17px/23px";
    
    [_web loadHTMLString:[NSString stringWithFormat:@"<style>body{word-wrap:break-word;margin:0;background-color:transparent;font:%@ Custom-Font-Name;align:justify;color:#000000}</style><div align='justify'>%@<div>",font,_detailModel.item.itemBrief] baseURL:nil];
    _web.opaque = NO;
    
    _web.dataDetectorTypes = UIDataDetectorTypeNone;
    [_web sizeToFit];
    [downView addSubview:_web];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView { //webview 自适应高度
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    downView.frame=CGRectMake(0, CGRectGetMaxY(upview.frame)+10, ScreenWidth, 50+CGRectGetHeight(webView.frame));
    _block(@"height",CGRectGetMaxY(downView.frame));
}


#pragma mark - SomeAction
/**
 * 购买
 */
-(void)buyAction
{
    _block(@"buy",_height);
}
/**
 * 收藏
 */
-(void)collectAction
{
    _block(@"collect",_height);
}
/**
 * 加入购物车
 */
-(void)shopAction
{
    _block(@"shop",_height);
}
/**
 * 初始化颜色按钮的选中状态
 */
-(void)setColorState
{
    NSArray *_colorArr=_detailModel.item.colors;
    for (int i=0; i<_colorArr.count; i++) {
        DD_ColorsModel *_color=[_colorArr objectAtIndex:i];
        if([_color.colorId isEqualToString:_detailModel.item.colorId])
        {
            [self setSelectState:i];
        }
    }
}
/**
 * 颜色按钮点击动作
 */
-(void)imageBtnAction:(UIButton *)btn
{
    [self setSelectState:btn.tag-200];
    [self setCollectState];
    _block(@"color_select",_height);
}
/**
 * 获取颜色状态
 */
-(void)setCollectState
{
    [[JX_AFNetworking alloc] GET:@"item/isCollectItem.do" parameters:@{@"token":[DD_UserModel getToken],@"itemId":_detailModel.item.itemId,@"colorId":_detailModel.item.colorId} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            if([_detailModel.item.colorId isEqualToString:[data objectForKey:@"colorId"]])
            {
                _detailModel.item.isCollect=[[data objectForKey:@"isCollect"] boolValue];
                collect_btn.selected=_detailModel.item.isCollect;
            }
        }else
        {
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
    }];
}
/**
 * 遍历颜色按钮状态
 */
-(void)setSelectState:(NSInteger )index
{
    for (int i=0; i<_imageArr.count; i++) {
        UIButton  *imageBtn=[_imageArr objectAtIndex:i];
        NSArray *_color=_detailModel.item.colors;
        if(index==i)
        {
            imageBtn.selected=YES;
            imageBtn.layer.borderColor=[[UIColor blackColor] CGColor];
            imageBtn.layer.borderWidth=1;
            DD_ColorsModel *_colorModel=[_color objectAtIndex:i];
            _detailModel.item.colorId=_colorModel.colorId;
            
        }else
        {
            imageBtn.selected=NO;
            imageBtn.layer.borderColor=[[UIColor clearColor] CGColor];
            imageBtn.layer.borderWidth=0;
        }
    }
    
}
/**
 * 获取当前状态商品的价格
 */
-(NSString *)getPriceStr
{
    NSString *_timestr=nil;
    long _nowTime=[regular date];
    if(_nowTime>=_detailModel.item.saleEndTime)
    {
        //        已经结束
        if(_detailModel.item.discountEnable)
        {

            _timestr=[[NSString alloc] initWithFormat:@"￥%.1f 折 %@原价￥%.1f",[_detailModel.item.price floatValue],_detailModel.item.discount,[_detailModel.item.originalPrice floatValue]];
        }else
        {
            _timestr=[[NSString alloc] initWithFormat:@"￥%.1f",[_detailModel.item.originalPrice floatValue]];
        }
        
    }else
    {
        //        发布中
        _timestr=[[NSString alloc] initWithFormat:@"￥%.1f 折 %@原价￥%.1f",[_detailModel.item.price floatValue],_detailModel.item.discount,[_detailModel.item.originalPrice floatValue]];
    }
    return _timestr;
}
/**
 * 设置发布会结束单品的价格
 */
-(void)endPriceState
{
    UILabel *label=[self viewWithTag:101];
    if(_detailModel.item.discountEnable)
    {
        
        label.text=[[NSString alloc] initWithFormat:@"￥%.1f 折 %@原价￥%.1f",[_detailModel.item.price floatValue],_detailModel.item.discount,[_detailModel.item.originalPrice floatValue]];
    }else
    {
        label.text=[[NSString alloc] initWithFormat:@"￥%.1f",[_detailModel.item.originalPrice floatValue]];
    }
}
/**
 * 设置时间label状态
 */
-(void )setItemTimeStr
{
    UILabel *label=[self viewWithTag:102];
    long _nowTime=[regular date];
    if(_nowTime>=_detailModel.item.saleEndTime)
    {
//        已经结束
        label.text=@"发布会已结束";
    }else
    {
//        发布中
        [self startTime:_detailModel.item.saleEndTime-_nowTime];
    }
}
/**
 * 开始线程计时
 * time 计时时间
 */
-(void)startTime:(long )time
{
    UILabel *label=[self viewWithTag:102];
    __block long timeout=time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
         NSLog(@"timeout=%ld",timeout);
        if(timeout==0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                label.text=@"发布会已结束";
                [self endPriceState];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",[regular getTimeStr:timeout]);
                //设置界面的按钮显示 根据自己需求设置
                label.text=[regular getTimeStr:timeout];
                timeout--;
            });
        }
    });
    dispatch_resume(_timer);
}
/**
 * 取消当前线程
 * 视图退出时候
 */
-(void)cancelTime
{
    [regular dispatch_cancel:_timer];
}
@end
