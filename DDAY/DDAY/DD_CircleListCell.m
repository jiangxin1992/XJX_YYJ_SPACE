//
//  DD_CircleListCell.m
//  DDAY
//
//  Created by yyj on 16/6/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleListCell.h"

#import "DD_ImageModel.h"

@implementation DD_CircleListCell
{
    UIImageView *userHeadImg;
    UILabel *userNameLabel;
    UILabel *userCareerLabel;
    UIImageView *goodImgView;
    UILabel *conentLabel;
    UILabel *timeLabel;
    
    NSMutableArray *goodsImgArr;
    NSMutableArray *userBtnArr;
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
-(void)PrepareData
{
    goodsImgArr=[[NSMutableArray alloc] init];
    userBtnArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
    self.contentView.backgroundColor=_define_backview_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    userHeadImg=[UIImageView getCustomImg];
    [self.contentView addSubview:userHeadImg];
    userHeadImg.userInteractionEnabled=YES;
    [userHeadImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
    [userHeadImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(IsPhone6_gt?34:15);
        make.top.mas_equalTo(9);
        make.width.height.mas_equalTo(43);
    }];
    
    userNameLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:userNameLabel];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userHeadImg);
        make.height.mas_equalTo(43/2.0f);
        make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);
    }];
    [userNameLabel sizeToFit];
    
    
    userCareerLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [self.contentView addSubview:userCareerLabel];
    [userCareerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userNameLabel.mas_bottom).with.offset(0);
        make.height.mas_equalTo(43/2.0f);
        make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);
    }];
    [userCareerLabel sizeToFit];
    
    goodImgView=[UIImageView getCustomImg];
    [self.contentView addSubview:goodImgView];
    [regular setBorder:goodImgView];
    [goodImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userHeadImg);
        make.top.mas_equalTo(userHeadImg.mas_bottom).with.offset(19);
        make.width.mas_equalTo(210);
        make.height.mas_equalTo(300);
    }];
    
    UIView *lastView=nil;
    for (int i=0; i<3; i++) {
        UIImageView *goods=[UIImageView getCustomImg];
        [self.contentView addSubview:goods];
        goods.userInteractionEnabled=YES;
        goods.tag=100+i;
        [goods addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)]];
        [goods mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-(IsPhone6_gt?34:15));
            make.width.height.mas_equalTo(66);
            if(lastView)
            {
                make.bottom.mas_equalTo(lastView.mas_top).with.offset(-24);
            }else
            {
                make.bottom.mas_equalTo(goodImgView.mas_bottom).with.offset(0);
            }
        }];
        lastView=goods;
        [goodsImgArr addObject:goods];
        
        UIButton *pricebtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_white_color WithSelectedTitle:@"" WithSelectedColor:nil];
        [goods addSubview:pricebtn];
        pricebtn.userInteractionEnabled=NO;
        pricebtn.tag=150+i;
        [pricebtn setBackgroundImage:[UIImage imageNamed:@"Circle_PriceFrame"] forState:UIControlStateNormal];
        [pricebtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(16);
        }];
        
    }
    
    conentLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:conentLabel];
    conentLabel.numberOfLines=0;
    [conentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(goodImgView.mas_bottom).with.offset(19);
        make.left.mas_equalTo(IsPhone6_gt?34:15);
        make.right.mas_equalTo(-(IsPhone6_gt?34:15));
    }];
    
    _lastView_state=nil;
//    删除 评论 收藏 点赞
    for (int i=0; i<3; i++) {
        UIButton *btn=[UIButton getCustomImgBtnWithImageStr:i==0?@"System_NoGood":i==1?@"System_Comment":@"System_Notcollection" WithSelectedImageStr:i==0?@"System_Good":i==1?@"System_Comment":@"System_Collection"];
        [self.contentView addSubview:btn];
        btn.tag=200+i;
        if(i==0)
        {
            [btn setEnlargeEdgeWithTop:0 right:15 bottom:0 left:15];
        }else
        {
            [btn setEnlargeEdge:15];
        }
        [btn addTarget:self action:@selector(userAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if(_lastView_state)
            {
                make.right.mas_equalTo(_lastView_state.mas_left).with.offset(-20);
                make.height.width.mas_equalTo(22);
                make.centerY.mas_equalTo(_lastView_state);
            }else
            {
                make.right.mas_equalTo(-(IsPhone6_gt?34:15));
                make.width.mas_equalTo(22);
                make.height.mas_equalTo(39);
                make.top.mas_equalTo(conentLabel.mas_bottom).with.offset(8.5f);
            }
        }];
        [userBtnArr addObject:btn];
        _lastView_state=btn;
    }
    
    timeLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(IsPhone6_gt?34:15);
        make.centerY.mas_equalTo(_lastView_state.mas_centerY);
    }];
    [timeLabel sizeToFit];
    
}


#pragma mark - SomeAction
+ (CGFloat)heightWithModel:(DD_CircleListModel *)model{
    
    DD_CircleListCell *cell = [[DD_CircleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.listModel=model;
    [cell setAction];
    [cell.contentView layoutIfNeeded];
    CGRect frame =  cell.lastView_state.frame;
    return frame.origin.y + frame.size.height+10;
}


-(void)userAction:(UIButton *)btn
{
    NSInteger _btnindex=btn.tag-200;
    if(_btnindex==0){
        //        点赞
        if(btn.selected)
        {
            _cellBlock(@"praise_cancel",_index,nil);
        }else
        {
            _cellBlock(@"praise",_index,nil);
        }
        
        
    }else if(_btnindex==1)
    {
        //        评论
        _cellBlock(@"comment",_index,nil);
        
    }else if(_btnindex==2)
    {
        //        收藏
        if(btn.selected)
        {
            _cellBlock(@"collect_cancel",_index,nil);
        }else
        {
            _cellBlock(@"collect",_index,nil);
        }
        
    }
    //    else if(_btnindex==3)
    //    {
    //        //        删除
    //        _cellBlock(@"delete",_index,nil);
    //    }
}
-(void)itemAction:(UIGestureRecognizer *)ges
{
    
    DD_OrderItemModel *_item=[_listModel.items objectAtIndex:ges.view.tag-100];
    _cellBlock(@"item_click",_index,_item);
}
/**
 * 头像点击
 */
-(void)headClick
{
    _cellBlock(@"head_click",_index,nil);
}
/**
 * 更新
 */
-(void)setAction
{
    [userHeadImg JX_loadImageUrlStr:_listModel.userHead WithSize:400 placeHolderImageName:nil radius:43/2.0f];
    userNameLabel.text=_listModel.userName;
    userCareerLabel.text=_listModel.career;
    if(_listModel.pics.count)
    {
        DD_ImageModel *imgModel=[_listModel.pics objectAtIndex:0];
        [goodImgView JX_loadImageUrlStr:imgModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    }
    
    NSInteger count_index=0;
    if(_listModel.items.count>3)
    {
        count_index=3;
    }else
    {
        count_index=_listModel.items.count;
    }
    for (int i=0; i<goodsImgArr.count; i++) {
        UIImageView *goods=[goodsImgArr objectAtIndex:i];
        UIButton *goodsPrice=(UIButton *)[self viewWithTag:150+i];
        if(i<count_index)
        {
            DD_OrderItemModel *_order=[_listModel.items objectAtIndex:i];
            [goods JX_loadImageUrlStr:_order.pic WithSize:400 placeHolderImageName:nil radius:0];
            goods.hidden=NO;
            [goodsPrice setTitle:[[NSString alloc] initWithFormat:@"￥%@",_order.price] forState:UIControlStateNormal];
        }else
        {
            goods.hidden=YES;
        }
    }
    conentLabel.text=_listModel.shareAdvise;
    timeLabel.text=[regular getSpacingTime:_listModel.createTime];

    UIButton *praiseBtn=[self viewWithTag:200];
    praiseBtn.selected=_listModel.isLike;
    
    UIButton *collectBtn=[self viewWithTag:202];
    collectBtn.selected=_listModel.isCollect;
    
    UIButton *delectBtn=[self viewWithTag:203];
    DD_UserModel *user=[DD_UserModel getLocalUserInfo];
    if([_listModel.userId isEqualToString:user.u_id])
    {
        delectBtn.hidden=NO;
    }else
    {
        delectBtn.hidden=YES;
    }
    
}
#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
#pragma mark - 弃用代码
/**
 * 更新
 */
//-(void)setAction
//{
//    _imgView.detailModel=_listModel;
//    _suggestView.detailModel=_listModel;
//    _userView.detailModel=_listModel;
//    _interactionView.detailModel=_listModel;
//}
//-(void)CreateImgView
//{
//    _imgView=[[DD_CircleListImgView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type) {
//        _cellBlock(type,_index);
//    }];
//    [self.contentView addSubview:_imgView];
//    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.and.right.mas_equalTo(0);
//    }];
//}
//-(void)CreateSuggestView
//{
//    _suggestView=[[DD_CircleListSuggestView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type) {
//        _cellBlock(type,_index);
//    }];
//    [self.contentView addSubview:_suggestView];
//    [_suggestView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.mas_equalTo(0);
//        make.top.mas_equalTo(_imgView.mas_bottom).with.offset(2);
//    }];
//}
//-(void)CreateUserView
//{
//    _userView=[[DD_CircleListUserView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type) {
//        _cellBlock(type,_index);
//    }];
//    [self.contentView addSubview:_userView];
//    [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.mas_equalTo(0);
//        make.top.mas_equalTo(_suggestView.mas_bottom).with.offset(0);
//    }];
//}
//-(void)CreateInteractionView
//{
//    _interactionView=[[DD_CircleListInteractionView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type) {
//        _cellBlock(type,_index);
//    }];
//    [self.contentView addSubview:_interactionView];
//    [_interactionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.mas_equalTo(0);
//        make.top.mas_equalTo(_userView.mas_bottom).with.offset(2);
//    }];
//}

@end
