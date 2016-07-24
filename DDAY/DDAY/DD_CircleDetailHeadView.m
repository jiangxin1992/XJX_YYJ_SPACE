//
//  DD_CircleDetailHeadView.m
//  DDAY
//
//  Created by yyj on 16/6/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleDetailImgView.h"
#import "DD_CircleListSuggestView.h"
#import "DD_CircleListUserView.h"
#import "DD_CircleListInteractionView.h"

#import "DD_CircleDetailHeadView.h"

@implementation DD_CircleDetailHeadView
{
    DD_CircleListSuggestView *_suggestView;
    DD_CircleDetailImgView *_imgView;
    DD_CircleListUserView *_userView;
    DD_CircleListInteractionView *_interactionView;
}

#pragma mark - 初始化
-(instancetype)initWithCircleListModel:(DD_CircleListModel *)model WithBlock:(void (^)(NSString *,NSInteger index))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _listModel=model;
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
-(void)PrepareData{}
-(void)PrepareUI
{
    self.backgroundColor=_define_backview_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateUserView];
    [self CreateImgView];
    [self CreateSuggestView];
    [self CreateInteractionView];
}
-(void)CreateUserView
{
    _userView=[[DD_CircleListUserView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type) {
        _block(type,0);
    }];
    [self addSubview:_userView];
    [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.mas_equalTo(0);
    }];
}
-(void)CreateImgView
{
    _imgView=[[DD_CircleDetailImgView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type,NSInteger index) {
        _block(type,index);
    }];
    [self addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(_userView.mas_bottom).with.offset(0);
    }];
}
-(void)CreateSuggestView
{
    _suggestView=[[DD_CircleListSuggestView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type) {
        _block(type,0);
    }];
    [self addSubview:_suggestView];
    [_suggestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(_imgView.mas_bottom).with.offset(0);
    }];
}
-(void)CreateInteractionView
{
    _interactionView=[[DD_CircleListInteractionView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type) {
        _block(type,0);
    }];
    [self addSubview:_interactionView];
    [_interactionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(_suggestView.mas_bottom).with.offset(2);
    }];
}
#pragma mark - setter
-(void)setListModel:(DD_CircleListModel *)listModel
{
    _listModel=listModel;
    [self setState];

}

#pragma mark - SomeAction
/**
 * 更新
 */
-(void)setState
{
    _suggestView.detailModel=_listModel;
    _imgView.detailModel=_listModel;
    _userView.detailModel=_listModel;
    _interactionView.detailModel=_listModel;
}
-(void)update
{
    _interactionView.detailModel=_listModel;
}

@end
