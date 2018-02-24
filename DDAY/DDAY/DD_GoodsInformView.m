//
//  DD_GoodInformView.m
//  DDAY
//
//  Created by yyj on 16/5/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsInformView.h"

#import <WebKit/WebKit.h>

#import "UIButton+WebCache.h"

#import "DD_ColorsModel.h"
#import "DD_GoodsItemModel.h"
#import "DD_GoodsDesignerModel.h"
#import "DD_GoodsDetailModel.h"
#import "DD_GoodSeriesModel.h"

#define ver_edge 16

@interface DD_GoodsInformView()<WKNavigationDelegate>

@end

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
    BOOL _is_discount=NO;
    long _nowTime=[NSDate nowTime];
    if(_nowTime>=_detailModel.item.saleEndTime)
    {
        //        已经结束
        if(_detailModel.item.discountEnable)
        {
            _is_discount=YES;
        }
    }else
    {
        //        发布中
        if([_detailModel.item.discount integerValue])
        {
            _is_discount=YES;
        }
    }
    
    collect_btn=[UIButton getCustomImgBtnWithImageStr:@"System_Notcollection" WithSelectedImageStr:@"System_Collection"];
    [upview addSubview:collect_btn];
    [collect_btn addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
    [collect_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(upview).with.offset(-(18+kEdge));
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(23);
        make.top.mas_equalTo(upview).with.offset(25);
    }];
    [collect_btn setEnlargeEdge:20];
    
    NSArray *titleArr=@[_detailModel.designer.brandName,_detailModel.item.itemName,[_detailModel getDiscountPriceStr]];
    
    [titleArr enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label=[UILabel getLabelWithAlignment:0 WithTitle:title WithFont:15.0f WithTextColor:nil WithSpacing:0];
        [upview addSubview:label];
        if(idx==2)
        {
            label.font=[regular getSemiboldFont:15.0f];
        }
        label.tag=100+idx;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            
            if(titleLastView){
                if(idx==1)
                {
                    make.top.mas_equalTo(titleLastView.mas_bottom).with.mas_equalTo(10);
                }else
                {
                    make.top.mas_equalTo(titleLastView.mas_bottom).with.mas_equalTo(22);
                }
                
            }else{
                make.right.mas_equalTo(collect_btn.mas_left).with.offset(0);
                make.centerY.mas_equalTo(collect_btn);
            }
        }];
        if(idx==1)
        {
            if(_is_discount)
            {
                UIButton *discountLabel=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0f WithSpacing:0 WithNormalTitle:[[NSString alloc] initWithFormat:@"%@折",[regular getRoundNum:[_detailModel.item.discount floatValue]]] WithNormalColor:[UIColor colorWithHexString:_detailModel.item.series.seriesColor] WithSelectedTitle:nil WithSelectedColor:nil];
                [upview addSubview:discountLabel];
                discountLabel.backgroundColor=[UIColor colorWithHexString:_detailModel.item.series.seriesColor];
                discountLabel.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
                [discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(label.mas_right).with.offset(11);
                    make.centerY.mas_equalTo(label);
                    make.width.mas_equalTo(40);
                    make.height.mas_equalTo(25);
                }];
                [discountLabel setBackgroundImage:[UIImage imageNamed:@"DDAY_Discountframe"] forState:UIControlStateNormal];
            }
        }
        titleLastView=label;
    }];
    
    
    
    if(_is_discount)
    {
        UILabel *originalLabel=[UILabel getLabelWithAlignment:0 WithTitle:[_detailModel getOriginalPriceStr] WithFont:13.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
        [upview addSubview:originalLabel];
        [originalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLastView.mas_right).with.offset(5);
            make.centerY.mas_equalTo(titleLastView);
        }];
        
        UIView *middleLine=[UIView getCustomViewWithColor:_define_light_gray_color1];
        [originalLabel addSubview:middleLine];
        [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(originalLabel);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
    }

}
/**
 * 创建颜色视图
 */
-(void)CreateImagePic
{
    
    NSArray *_colorsArr=_detailModel.item.colors;
    __block UIView *lastview=nil;
    
    [_colorsArr enumerateObjectsUsingBlock:^(DD_ColorsModel *_colorModel, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *backBtn=[UIButton getCustomBtn];
        [upview addSubview:backBtn];
        backBtn.tag=200+idx;
        [backBtn addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(42);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(titleLastView.mas_bottom).with.offset(18);
            if(lastview){
                make.left.mas_equalTo(lastview.mas_right).with.offset(11);
            }else{
                make.left.mas_equalTo(upview).with.offset(kEdge);
            }
            if(idx==_colorsArr.count-1)
            {
                make.bottom.mas_equalTo(upview).with.offset(-28);
            }
        }];
        
        UIView *colorView=[UIView getCustomViewWithColor:[UIColor colorWithHexString:_colorModel.colorCode]];
        colorView.userInteractionEnabled=NO;
        [backBtn addSubview:colorView];
        [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(backBtn).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
        
        UIView *downLine=[UIView getCustomViewWithColor:_define_black_color];
        [backBtn addSubview:downLine];
        [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        [_imageArr addObject:backBtn];
        lastview=backBtn;
    }];
    
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
        make.bottom.mas_equalTo(self).with.offset(-1);
    }];
    
    UIView *view=[UIView getCustomViewWithColor:_define_black_color];
    [downView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.and.right.mas_equalTo(self).with.offset(0);
        make.bottom.mas_equalTo(self).with.offset(0);
    }];
}
-(void)CreateDesView
{
    _type_label=[UILabel getLabelWithAlignment:0 WithTitle:@"款式信息" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [downView addSubview:_type_label];
    [_type_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ver_edge);
        make.left.mas_equalTo(downView).with.offset(kEdge);
    }];
}
-(void)loadWebview
{
    WKWebView *_web=[[WKWebView alloc] init];
    _web.navigationDelegate = self;
    [_web loadHTMLString:[regular getHTMLStringWithContent:_detailModel.item.itemBrief WithFont:@"13px/17px" WithColorCode:@"#000000"] baseURL:nil];
//    _web.opaque = NO;
    [_web sizeToFit];
    [downView addSubview:_web];
    [_web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_type_label.mas_bottom).with.offset(11);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(10);
        make.bottom.mas_equalTo(downView.mas_bottom).with.offset(-ver_edge);
    }];
    _web.backgroundColor= _define_clear_color;
}

#pragma mark - WKNavigationDelegate

//加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        CGFloat height = floor([result doubleValue])+2;
        [webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
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
    
    [_colorArr enumerateObjectsUsingBlock:^(DD_ColorsModel *_color, NSUInteger idx, BOOL * _Nonnull stop) {
        if([_color.colorId isEqualToString:_detailModel.item.colorId])
        {
            [self setSelectState:idx];
        }
    }];
}
/**
 * 颜色按钮点击动作
 */
-(void)imageBtnAction:(UIButton *)btn
{
    [self setSelectState:btn.tag-200];
    [self setCollectState];
}
/**
 * 获取颜色状态
 */
-(void)setCollectState
{
    DD_ColorsModel *colorModel=[_detailModel getColorsModel];
    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"itemId":_detailModel.item.itemId,@"colorId":_detailModel.item.colorId,@"colorCode":colorModel.colorCode};
    [[JX_AFNetworking alloc] GET:@"item/isCollectItem.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            if([_detailModel.item.colorId isEqualToString:[data objectForKey:@"colorId"]])
            {
                _detailModel.item.isCollect=[[data objectForKey:@"isCollect"] boolValue];
                collect_btn.selected=_detailModel.item.isCollect;
//                color_select
                _block(@"color_select");
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
    [_imageArr enumerateObjectsUsingBlock:^(UIButton  *imageBtn, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *_color=_detailModel.item.colors;
        if(index==idx)
        {
            imageBtn.selected=YES;
            [regular setBorder:imageBtn];
            DD_ColorsModel *_colorModel=_color[idx];
            _detailModel.item.colorId=_colorModel.colorId;
        }else
        {
            imageBtn.selected=NO;
            imageBtn.layer.borderColor=[ _define_clear_color CGColor];
            imageBtn.layer.borderWidth=0;
        }
    }];

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
//        btn.backgroundColor=_define_black_color;
//        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
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
//        label.text=[[NSString alloc] initWithFormat:@"￥%@ 折 %@原价￥%@",[regular getRoundNum:[_detailModel.item.price floatValue]],_detailModel.item.discount,[regular getRoundNum:[_detailModel.item.originalPrice floatValue]]];
//    }else
//    {
//        label.text=[[NSString alloc] initWithFormat:@"￥%@",[regular getRoundNum:[_detailModel.item.originalPrice floatValue]]];
//    }
//}
/**
 * 设置时间label状态
 */
//-(void )setItemTimeStr
//{
//    UILabel *label=[self viewWithTag:102];
//    long _nowTime=[NSDate nowTime];
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
//         JXLOG(@"timeout=%ld",timeout);
//        if(timeout==0){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                label.text=@"发布会已结束";
//                [self endPriceState];
//            });
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                JXLOG(@"%@",[regular getTimeStr:timeout]);
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
