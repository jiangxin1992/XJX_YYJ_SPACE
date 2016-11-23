//
//  DD_CircleApplyInfoView.m
//  DDAY
//
//  Created by yyj on 16/6/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//


#import "DD_CircleApplyInfoView.h"

#import "DD_CircleChooseStyleView.h"
#import "DD_CircleInfoSuggestView.h"
#import "DD_CircleInfoImgView.h"
#import "DD_CirlcleApplyDesignerChooseView.h"
#import "DD_CircleTagsView.h"
#import "DD_CircleFitPersonView.h"
#import "DD_CircleInfoSuggestSimpleView.h"

#import "DD_CircleModel.h"
#import "DD_CircleFavouriteDesignerModel.h"

@interface DD_CircleApplyInfoView ()<UIWebViewDelegate>

@end

@implementation DD_CircleApplyInfoView

#pragma mark - 初始化
/**
 * 初始化
 */
-(instancetype)initWithCircleModel:(DD_CircleModel *)CircleModel WithBlock:(void (^)(NSString *type,long index))block
{
    self=[super init];
    if(self)
    {
        _CircleModel=CircleModel;
        _block=block;
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{
}
-(void)PrepareUI
{
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateFavouriteDesignerView];
    [self CreateLikeReasonView];
    [self CreateInfoImgView];
    [self CreateRemarksView];
    [self CreateChooseStyleView];
    [self CreateTagsView];
    [self CreateFitPersonView];
//    [self CreatePreviewBtn];
//    [self CreateSuggestTitleView];
//    [self CreateChooseStyleView];
//    [self CreateInfoImgView];
//    [self CreateRemarksView];
//    [self CreateTagsView];
//    [self CreateFitPersonView];
//    [self CreateSubmitBtn];
}
/**
 * 最喜欢的设计师
 */
-(void)CreateFavouriteDesignerView
{
    UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"填写一份搭配建议" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(0);
    }];
    
    _designerView=[[DD_CircleInfoSuggestSimpleView alloc] initWithPlaceHoldStr:@"*你最喜欢的独立设计师" WithBlockType:@"like_reason_remarks" WithLimitNum:50 Block:^(NSString *type, NSString *content) {
        _CircleModel.designerModel.likeDesignerName=content;
    }];
    [self addSubview:_designerView];
    
    [_designerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(10);
        make.left.and.right.mas_equalTo(0);
    }];
}
-(void)CreateLikeReasonView
{
//    DD_CircleInfoSuggestSimpleView
    _likeReasonView=[[DD_CircleInfoSuggestSimpleView alloc] initWithPlaceHoldStr:@"你喜欢ta的原因" WithBlockType:@"like_reason_remarks" WithLimitNum:300 Block:^(NSString *type, NSString *content) {
//        _block(type,content);
        _CircleModel.designerModel.likeReason=content;
    }];
    [self addSubview:_likeReasonView];
    [_likeReasonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_designerView.mas_bottom).with.offset(18);
        make.left.and.right.mas_equalTo(0);
    }];
}
/**
 * 搭配图视图创建
 */
-(void)CreateInfoImgView
{
    _imgView=[[DD_CircleInfoImgView alloc] initWithCircleModel:_CircleModel WithBlock:^(NSString *type,NSInteger index) {
        _block(type,index);
    }];
    [self addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_likeReasonView.mas_bottom).with.offset(10);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(IsPhone6_gt?260:220);
    }];
}
/**
 * 创建备注视图
 */
-(void)CreateRemarksView
{
    
    _commentview=[[DD_CircleInfoSuggestView alloc] initWithPlaceHoldStr:@"写下你的搭配建议" WithBlockType:@"suggest_remarks" WithLimitNum:200 Block:^(NSString *type, NSString *content) {
        if([type isEqualToString:@"num_limit"])
        {
            _block(type,0);
        }else
        {
            _CircleModel.remark=content;
        }
        
    }];
    [self addSubview:_commentview];
    [_commentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imgView.mas_bottom).with.offset(0);
        make.left.and.right.mas_equalTo(0);
    }];
}
/**
 * 款式选择视图创建
 */
-(void)CreateChooseStyleView
{
    _chooseStyleView=[[DD_CircleChooseStyleView alloc] initWithCircleModel:_CircleModel WithBlock:^(NSString *type,NSInteger index) {
        _block(type,index);
    }];
    [self addSubview:_chooseStyleView];
    [_chooseStyleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_commentview.mas_bottom).with.offset(10);
        make.left.and.right.mas_equalTo(0);
    }];
    
}

/**
 * 标签视图创建
 */
-(void)CreateTagsView
{
    _tagsView=[[DD_CircleTagsView alloc] initWithCircleModel:_CircleModel WithBlock:^(NSString *type,long index) {
        _block(type,index);
    }];
    [self addSubview:_tagsView];
    [_tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_chooseStyleView.mas_bottom).with.offset(10);
        make.left.and.right.mas_equalTo(0);
    }];
}
/**
 * 创建适合人群视图
 */
-(void)CreateFitPersonView
{
    _fitPersonView=[[DD_CircleFitPersonView alloc] initWithCircleModel:_CircleModel WithBlock:^(NSString *type,long index) {
        _block(type,index);
    }];
    [self addSubview:_fitPersonView];
    [_fitPersonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tagsView.mas_bottom).with.offset(10);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-30);
    }];
}
/**
 * 创建预览按钮
 */
//-(void)CreatePreviewBtn
//{
//    UIButton *_submitBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"预览" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
//    [self addSubview:_submitBtn];
//    _submitBtn.backgroundColor=_define_black_color;
//    [_submitBtn addTarget:self action:@selector(sumbitAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_fitPersonView.mas_bottom).with.offset(20);
//        make.left.mas_equalTo(kEdge);
//        make.right.mas_equalTo(-kEdge);
//        make.bottom.mas_equalTo(-30);
//    }];
//}
///**
// * 建议title
// */
//-(void)CreateSuggestTitleView
//{
//    _suggestTitle=[[UILabel alloc] init];
//    [self addSubview:_suggestTitle];
//    _suggestTitle.textColor=_define_light_gray_color1;
//    _suggestTitle.textAlignment=0;
//    _suggestTitle.font=[regular getFont:15.0f];
//    _suggestTitle.text=@"填写一份搭配建议";
//    
//    [_suggestTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_likeReasonView.mas_bottom).with.offset(10);
//        make.left.mas_equalTo(20);
//        make.width.mas_equalTo(200);
//        make.height.mas_equalTo(40);
//    }];
//}
///**
// * 款式选择视图创建
// */
//-(void)CreateChooseStyleView
//{
//    _chooseStyleView=[[DD_CircleChooseStyleView alloc] initWithCircleModel:_CircleModel WithBlock:^(NSString *type,NSInteger index) {
//        _block(type,0);
//    }];
//    [self addSubview:_chooseStyleView];
//    [_chooseStyleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_suggestTitle.mas_bottom).with.offset(10);
//        make.left.and.right.mas_equalTo(0);
//        
//    }];
//}
///**
// * 搭配图视图创建
// */
//-(void)CreateInfoImgView
//{
//    _imgView=[[DD_CircleInfoImgView alloc] initWithCircleModel:_CircleModel WithBlock:^(NSString *type,NSInteger index) {
//        _block(type,index);
//    }];
//    [self addSubview:_imgView];
//    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_chooseStyleView.mas_bottom).with.offset(10);
//        make.left.and.right.mas_equalTo(0);
//    }];
//}
///**
// * 创建备注视图
// */
//-(void)CreateRemarksView
//{
//    _remarksView=[[DD_CircleInfoSuggestView alloc] initWithPlaceHoldStr:@"*写下你的搭配建议" WithBlockType:@"suggest_remarks" WithLimitNum:200 Block:^(NSString *type, NSString *content) {
////        _block(type,num);
//        _CircleModel.remark=content;
//    }];
//    [self addSubview:_remarksView];
//    [_remarksView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_imgView.mas_bottom).with.offset(10);
//        make.left.and.right.mas_equalTo(0);
//    }];
//}
///**
// * 标签视图创建
// */
//-(void)CreateTagsView
//{
//    _tagsView=[[DD_CircleTagsView alloc] initWithCircleModel:_CircleModel WithBlock:^(NSString *type,long index) {
//        _block(type,index);
//    }];
//    [self addSubview:_tagsView];
//    [_tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_remarksView.mas_bottom).with.offset(10);
//        make.left.and.right.mas_equalTo(0);
//    }];
//}
///**
// * 创建适合人群视图
// */
//-(void)CreateFitPersonView
//{
//    _fitPersonView=[[DD_CircleFitPersonView alloc] initWithCircleModel:_CircleModel WithBlock:^(NSString *type,long index) {
//        _block(type,index);
//    }];
//    [self addSubview:_fitPersonView];
//    [_fitPersonView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_tagsView.mas_bottom).with.offset(10);
//        make.left.and.right.mas_equalTo(0);
//    }];
//}
///**
// * 创建提交按钮
// */
//-(void)CreateSubmitBtn
//{
//    UIButton *_submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:_submitBtn];
//    _submitBtn.backgroundColor=_define_black_color;
//    [_submitBtn setTitleColor:_define_white_color forState:UIControlStateNormal];
//    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
//    [_submitBtn addTarget:self action:@selector(sumbitAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_fitPersonView.mas_bottom).with.offset(20);
//        make.width.mas_equalTo(@200);
//        make.centerX.mas_equalTo(self);
//        make.bottom.mas_equalTo(0);
//    }];
//}
#pragma mark - SomeAction
/**
 * 提交
 */
//-(void)sumbitAction
//{
//    _block(@"submit",0);
//}

@end
