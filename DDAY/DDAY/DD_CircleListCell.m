//
//  DD_CircleListCell.m
//  DDAY
//
//  Created by yyj on 16/6/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleListSuggestView.h"
#import "DD_CircleListImgView.h"
#import "DD_CircleListUserView.h"
#import "DD_CircleListInteractionView.h"

#import "DD_CircleListCell.h"

@implementation DD_CircleListCell
{
    DD_CircleListImgView *_imgView;
    DD_CircleListSuggestView *_suggestView;
    DD_CircleListUserView *_userView;
    DD_CircleListInteractionView *_interactionView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
#pragma mark - 初始化
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
#pragma mark - setter
-(void)setListModel:(DD_CircleListModel *)listModel
{
    
    _listModel=listModel;
    //        更新cell
    [self setAction];
    
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
    self.contentView.backgroundColor=_define_backview_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
//    UI创建，分成三个view
    [self CreateImgView];
    [self CreateSuggestView];
    [self CreateUserView];
    [self CreateInteractionView];
}
-(void)CreateImgView
{
    _imgView=[[DD_CircleListImgView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type) {
        _cellBlock(type,_index);
    }];
    [self.contentView addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.mas_equalTo(0);
    }];
}
-(void)CreateSuggestView
{
    _suggestView=[[DD_CircleListSuggestView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type) {
        _cellBlock(type,_index);
    }];
    [self.contentView addSubview:_suggestView];
    [_suggestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(_imgView.mas_bottom).with.offset(2);
    }];
}
-(void)CreateUserView
{
    _userView=[[DD_CircleListUserView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type) {
        _cellBlock(type,_index);
    }];
    [self.contentView addSubview:_userView];
    [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(_suggestView.mas_bottom).with.offset(0);
    }];
}
-(void)CreateInteractionView
{
    _interactionView=[[DD_CircleListInteractionView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type) {
        _cellBlock(type,_index);
    }];
    [self.contentView addSubview:_interactionView];
    [_interactionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(_userView.mas_bottom).with.offset(2);
    }];
}
#pragma mark - SomeAction
/**
 * 更新
 */
-(void)setAction
{
    _imgView.detailModel=_listModel;
    _suggestView.detailModel=_listModel;
    _userView.detailModel=_listModel;
    _interactionView.detailModel=_listModel;
}
#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
