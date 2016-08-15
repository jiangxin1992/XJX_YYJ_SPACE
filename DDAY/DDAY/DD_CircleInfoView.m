//
//  DD_CircleInfoView.m
//  DDAY
//
//  Created by yyj on 16/6/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleInfoView.h"

#import "DD_CircleInfoSuggestView.h"

@implementation DD_CircleInfoView
{
    DD_CircleInfoSuggestView *_commentview;
}

#pragma mark - 初始化
/**
 * 初始化
 */
-(instancetype)initWithCircleModel:(DD_CircleModel *)model WithBlock:(void (^)(NSString *type,long index))block
{
    self=[super init];
    if(self)
    {
        _CircleModel=model;
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
    [self CreateInfoImgView];
    [self CreateRemarksView];
    [self CreateChooseStyleView];
    [self CreateTagsView];
    [self CreateFitPersonView];
    [self CreatePreviewBtn];
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
        make.top.mas_equalTo(10);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(IsPhone6_gt?240:200);
    }];
}
/**
 * 创建备注视图
 */
-(void)CreateRemarksView
{

    _commentview=[[DD_CircleInfoSuggestView alloc] initWithPlaceHoldStr:@"写下你的搭配建议" WithBlockType:@"suggest_remarks" WithLimitNum:200 Block:^(NSString *type, NSInteger num) {
        _block(type,num);
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
    }];
}
/**
 * 创建预览按钮
 */
-(void)CreatePreviewBtn
{
    UIButton *_submitBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"预览" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:_submitBtn];
    _submitBtn.backgroundColor=[UIColor blackColor];
    [_submitBtn addTarget:self action:@selector(sumbitAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_fitPersonView.mas_bottom).with.offset(20);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.bottom.mas_equalTo(-30);
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [regular dismissKeyborad];
}
#pragma mark - SomeAction
/**
 * 提交
 */
-(void)sumbitAction
{
    _block(@"submit",0);
}
@end
