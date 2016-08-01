//
//  DD_GoodInformView.m
//  DDAY
//
//  Created by yyj on 16/5/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//
#define hor_edge 26
#define ver_edge 22

#import "DD_GoodsInformView.h"

#import "UIButton+WebCache.h"
#import "DD_ColorsModel.h"
#import "DD_ColorBtn.h"
@implementation DD_GoodsInformView
{
    UIView *downView;//下部视图
    UIView *upview;//上部视图
    
    dispatch_source_t _timer;//计时线程/页面退出时销毁
    NSMutableArray *_imageArr;//存放颜色按钮的数组
    UIButton *collect_btn;//收藏按钮

    UIView *titleLastView;//最后一个标题
    UILabel *_type_label;//款式信息label
}
#pragma mark - 初始化
-(instancetype)initWithGoodsDetailModel:(DD_GoodsDetailModel *)model WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
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
    _imageArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI{}
#pragma mark - SetState
/**
 * UI创建完之后设置状态
 */
-(void)setState
{
    collect_btn.selected=_detailModel.item.isCollect;
//    [self setItemTimeStr];
    [self setColorState];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateInformView];
    [self CreateIntroduceView];
}
#pragma mark - UpView
-(void)CreateInformView
{
    [self CreateUpView];
    [self CreateTitle];
    [self CreateImagePic];
//    [self CreateBuyShopBtn];
}
-(void)CreateUpView
{
    upview=[UIView getCustomViewWithColor:nil];
    [self addSubview:upview];
    [upview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.mas_equalTo(0);
    }];
    
    UIView *view=[UIView getCustomViewWithColor:_define_black_color];
    [upview addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.and.right.mas_equalTo(view.superview).with.offset(0);
        make.bottom.mas_equalTo(view.superview).with.offset(-1);
    }];
    
}
/**
 * 创建标题视图
 */
-(void)CreateTitle
{
    
    collect_btn=[UIButton getCustomImgBtnWithImageStr:@"System_Circle_Normal" WithSelectedImageStr:@"System_Circle_Select"];
    [upview addSubview:collect_btn];
    [collect_btn addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
    [collect_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(upview).with.offset(-(10+hor_edge));
        make.width.and.height.mas_equalTo(45);
        make.top.mas_equalTo(upview).with.offset(20);
    }];
    
    NSArray *titleArr=@[_detailModel.item.itemName,_detailModel.item.itemName,[_detailModel getPriceStr]];
    for (int i=0; i<titleArr.count; i++) {
        UILabel *label=[UILabel getLabelWithAlignment:0 WithTitle:titleArr[i] WithFont:15.0f WithTextColor:i==2?_define_light_red_color:_define_black_color WithSpacing:0];
        [upview addSubview:label];
        label.tag=100+i;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(hor_edge);
            make.right.mas_equalTo(collect_btn.mas_left).with.offset(0);
            make.height.mas_equalTo(ver_edge);
            if(titleLastView){
                make.top.mas_equalTo(titleLastView.mas_bottom).with.mas_equalTo(6);
            }else{
                make.top.mas_equalTo(upview).with.offset(12);
            }
        }];
        titleLastView=label;
    }
}
/**
 * 创建颜色视图
 */
-(void)CreateImagePic
{
    
    NSArray *_colorsArr=_detailModel.item.colors;
    UIView *lastview=nil;
    for (int i=0; i<_colorsArr.count;i++) {
        DD_ColorsModel *_colorModel=[_colorsArr objectAtIndex:i];
        DD_ColorBtn *imageBtn=[DD_ColorBtn buttonWithType:UIButtonTypeCustom];
        [upview addSubview:imageBtn];
        [imageBtn sd_setImageWithURL:[NSURL URLWithString:[regular getImgUrl:_colorModel.colorPic WithSize:800]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headImg_login1"]];
        imageBtn.tag=200+i;
        [imageBtn addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_imageArr addObject:imageBtn];
        [imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(42);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(titleLastView.mas_bottom).with.offset(hor_edge);
            if(lastview){
                make.left.mas_equalTo(lastview.mas_right).with.offset(11);
            }else{
                make.left.mas_equalTo(upview).with.offset(hor_edge);
            }
            if(i==_colorsArr.count-1)
            {
                make.bottom.mas_equalTo(upview).with.offset(-ver_edge);
            }
        }];
        lastview=imageBtn;
    }
    
}
#pragma mark - DownView
-(void)CreateIntroduceView
{
    [self CreateDownView];
    [self CreateDesView];
    [self loadWebview];
}
-(void)CreateDownView
{
    downView=[UIView getCustomViewWithColor:nil];
    [self addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(upview.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(self).with.offset(0);
    }];
    
    UIView *view=[UIView getCustomViewWithColor:_define_black_color];
    [downView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.and.right.mas_equalTo(view.superview).with.offset(0);
        make.bottom.mas_equalTo(view.superview).with.offset(-1);
    }];
}
-(void)CreateDesView
{
    _type_label=[UILabel getLabelWithAlignment:1 WithTitle:@"款式信息" WithFont:13.0f WithTextColor:_define_white_color WithSpacing:0];
    _type_label.backgroundColor=_define_black_color;
    [downView addSubview:_type_label];
    [_type_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(23);
        make.top.mas_equalTo(ver_edge);
        make.left.mas_equalTo(downView).with.offset(hor_edge);
    }];
}
-(void)loadWebview
{
    UIWebView *_web=[[UIWebView alloc] init];
    _web.delegate=self;
    NSString *font=@"12px/16px";
    [_web loadHTMLString:[NSString stringWithFormat:@"<style>body{word-wrap:break-word;margin:0;background-color:transparent;font:%@ Custom-Font-Name;align:justify;color:#000000}</style><div align='justify'>%@<div>",font,_detailModel.item.itemBrief] baseURL:nil];
    _web.opaque = NO;
    _web.dataDetectorTypes = UIDataDetectorTypeNone;
    [_web sizeToFit];
    [downView addSubview:_web];
    [_web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_type_label.mas_bottom).with.offset(11);
        make.left.mas_equalTo(hor_edge);
        make.right.mas_equalTo(-hor_edge);
        make.height.mas_equalTo(10);
        make.bottom.mas_equalTo(downView.mas_bottom).with.offset(-ver_edge);
    }];
    _web.backgroundColor=[UIColor clearColor];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView { //webview 自适应高度
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    [webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(webView.frame.size.height);
    }];
}

#pragma mark - SomeAction

/**
 * 收藏
 */
-(void)collectAction
{
    _block(@"collect");
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
    _block(@"color_select");
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


#pragma mark - 弃用代码
///**
// * 创建购物车 购买按钮
// */
//-(void)CreateBuyShopBtn
//{
//    NSArray *titleArr=@[@"立即购买",@"加入购物车"];
//    for (int i=0; i<titleArr.count; i++) {
//        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//        [upview addSubview:btn];
//        if(i==0)
//        {
//            [btn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
//        }else
//        {
//            [btn addTarget:self action:@selector(shopAction) forControlEvents:UIControlEventTouchUpInside];
//        }
//        btn.frame=CGRectMake(10, 280+60*i, ScreenWidth-20, 50);
//        btn.backgroundColor=[UIColor blackColor];
//        [btn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
//    }
//    upview.frame=CGRectMake(0,0,ScreenWidth, 410);
//}
///**
// * 购买
// */
//-(void)buyAction
//{
//    _block(@"buy");
//}
///**
// * 加入购物车
// */
//-(void)shopAction
//{
//    _block(@"shop");
//}
/**
 * 设置发布会结束单品的价格
 */
//-(void)endPriceState
//{
//    UILabel *label=[self viewWithTag:101];
//    if(_detailModel.item.discountEnable)
//    {
//        
//        label.text=[[NSString alloc] initWithFormat:@"￥%.1f 折 %@原价￥%.1f",[_detailModel.item.price floatValue],_detailModel.item.discount,[_detailModel.item.originalPrice floatValue]];
//    }else
//    {
//        label.text=[[NSString alloc] initWithFormat:@"￥%.1f",[_detailModel.item.originalPrice floatValue]];
//    }
//}
/**
 * 设置时间label状态
 */
//-(void )setItemTimeStr
//{
//    UILabel *label=[self viewWithTag:102];
//    long _nowTime=[regular date];
//    if(_nowTime>=_detailModel.item.saleEndTime)
//    {
////        已经结束
//        label.text=@"发布会已结束";
//    }else
//    {
////        发布中
//        [self startTime:_detailModel.item.saleEndTime-_nowTime];
//    }
//}
/**
 * 开始线程计时
 * time 计时时间
 */
//-(void)startTime:(long )time
//{
//    UILabel *label=[self viewWithTag:102];
//    __block long timeout=time; //倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//         NSLog(@"timeout=%ld",timeout);
//        if(timeout==0){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                label.text=@"发布会已结束";
//                [self endPriceState];
//            });
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"%@",[regular getTimeStr:timeout]);
//                //设置界面的按钮显示 根据自己需求设置
//                label.text=[regular getTimeStr:timeout];
//                timeout--;
//            });
//        }
//    });
//    dispatch_resume(_timer);
//}
/**
 * 取消当前线程
 * 视图退出时候
 */
//-(void)cancelTime
//{
//    [regular dispatch_cancel:_timer];
//}
@end