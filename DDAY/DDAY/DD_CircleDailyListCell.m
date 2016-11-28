//
//  DD_CircleDailyListCell.m
//  YCO SPACE
//
//  Created by yyj on 16/9/13.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleDailyListCell.h"

#import "DD_ImageModel.h"
#import "DD_OrderItemModel.h"
#import "DD_CircleListModel.h"

@implementation DD_CircleDailyListCell
{
    UIImageView *userHeadImg;
    UILabel *userNameLabel;
    UILabel *userCareerLabel;
    UIImageView *goodImgView;
    UILabel *conentLabel;
    UILabel *timeLabel;
    
    UIImageView *goods1;
    UIImageView *goods2;
    UIImageView *goods3;
    UIButton *pricebtn1;
    UIButton *pricebtn2;
    UIButton *pricebtn3;
    
    UIButton *praiseBtn;
    UIButton *commentBtn;
    UIButton *collectBtn;
    
    UILabel *praiseLabel;
    UILabel *commentLabel;
    UILabel *collectLabel;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
#pragma mark - 初始化
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier IsUserHomePage:(BOOL )isUserHomePage
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _isUserHomePage=isUserHomePage;
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
    _isNameCenterFit=NO;
    
    goods1=[UIImageView getCustomImg];
    goods2=[UIImageView getCustomImg];
    goods3=[UIImageView getCustomImg];
    
    pricebtn1=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_white_color WithSelectedTitle:@"" WithSelectedColor:nil];
    pricebtn2=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_white_color WithSelectedTitle:@"" WithSelectedColor:nil];
    pricebtn3=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_white_color WithSelectedTitle:@"" WithSelectedColor:nil];
    
    praiseBtn=[UIButton getCustomBtn];
    commentBtn=[UIButton getCustomBtn];
    collectBtn=[UIButton getCustomBtn];
    
    praiseLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    commentLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    collectLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
}
-(void)PrepareUI
{
    self.contentView.backgroundColor=_define_white_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    if(!_isUserHomePage)
    {
        userHeadImg=[UIImageView getCornerRadiusImg];
        [self.contentView addSubview:userHeadImg];
        userHeadImg.contentMode=2;
        [regular setZeroBorder:userHeadImg];
        userHeadImg.userInteractionEnabled=YES;
        [userHeadImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
        //        userHeadImg.frame=CGRectMake(kEdge, 9, 44, 44);
        [userHeadImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            make.top.mas_equalTo(9);
            make.width.height.mas_equalTo(44);
        }];
        
        userNameLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:IsPhone6_gt?15.0f:14.0f WithTextColor:nil WithSpacing:0];
        [self.contentView addSubview:userNameLabel];
        //        userNameLabel.frame=CGRectMake(CGRectGetMaxX(userHeadImg.frame)+6, CGRectGetMinY(userHeadImg.frame), 100, 22);
        [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(userHeadImg);
            make.height.mas_equalTo(44/2.0f);
            make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);
        }];
        [userNameLabel sizeToFit];
        
        
        userCareerLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
        [self.contentView addSubview:userCareerLabel];
        //        userCareerLabel.frame=CGRectMake(CGRectGetMaxX(userHeadImg.frame)+6, CGRectGetMaxY(userNameLabel.frame), 100, 22);
        [userCareerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(userNameLabel.mas_bottom).with.offset(0);
            make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);
        }];
        [userCareerLabel sizeToFit];
    }
    
    
    goodImgView=[UIImageView getCustomImg];
    [self.contentView addSubview:goodImgView];
    goodImgView.contentMode=2;
    [regular setZeroBorder:goodImgView];
    [goodImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        if(!_isUserHomePage)
        {
            make.top.mas_equalTo(userHeadImg.mas_bottom).with.offset(19);
        }else
        {
            make.top.mas_equalTo(19);
        }
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(300);
    }];
    
    conentLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:conentLabel];
    conentLabel.numberOfLines=0;
    //    conentLabel.frame=CGRectMake(kEdge, CGRectGetMaxY(goodImgView.frame)+19, ScreenWidth-2*kEdge, 0);
    [conentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(goodImgView.mas_bottom).with.offset(19);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(0);
    }];
    
    UIButton *_lastView_state=nil;
    _last_count_view=nil;
    //    点赞 评论 收藏
    
    for (int i=0; i<3; i++) {
        UIButton *btn=i==0?praiseBtn:i==1?commentBtn:collectBtn;
        [btn setImage:[UIImage imageNamed:i==0?@"System_NoGood":i==1?@"System_Comment":@"System_Notcollection"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:i==0?@"System_Good":i==1?@"System_Comment":@"System_Collection"] forState:UIControlStateSelected];
        [self.contentView addSubview:btn];
        if(i==0)
        {
            [btn setEnlargeEdgeWithTop:0 right:15 bottom:0 left:15];
        }else
        {
            [btn setEnlargeEdge:15];
        }
        btn.tag=200+i;
        [btn addTarget:self action:@selector(userAction:) forControlEvents:UIControlEventTouchUpInside];
        //        btn.frame=CGRectMake(ScreenWidth-kEdge-25, CGRectGetMaxY(conentLabel.frame)+8, 25, 23);
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if(_lastView_state)
            {
                make.right.mas_equalTo(_lastView_state.mas_left).with.offset(-20);
                make.centerY.mas_equalTo(_lastView_state);
                if(i==2)
                {
                    make.width.mas_equalTo(25);
                    make.height.mas_equalTo(23);
                }else
                {
                    make.height.width.mas_equalTo(25);
                }
                
            }else
            {
                make.right.mas_equalTo(-kEdge);
                make.width.mas_equalTo(25);
                make.height.mas_equalTo(44);
                make.top.mas_equalTo(conentLabel.mas_bottom).with.offset(8);
            }
        }];
        
        
        UILabel *label=i==0?praiseLabel:i==1?commentLabel:collectLabel;
        [self.contentView addSubview:label];
        label.font=[regular get_en_Font:12.0f];
        //        label.frame=CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMinY(btn.frame), CGRectGetWidth(btn.frame), 20);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(btn);
            if(_last_count_view)
            {
                make.top.mas_equalTo(_last_count_view);
            }else
            {
                make.top.mas_equalTo(btn.mas_bottom).with.offset(0);
            }
            make.height.mas_equalTo(20);
        }];
        _lastView_state=btn;
        _last_count_view=label;
    }
    
    timeLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [self.contentView addSubview:timeLabel];
    //    timeLabel.frame=CGRectMake(kEdge, CGRectGetMinY(_lastView_state.frame), 100, 30);
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.centerY.mas_equalTo(_lastView_state.mas_centerY);
    }];
    [timeLabel sizeToFit];
    
}


#pragma mark - SomeAction
+ (CGFloat)heightWithModel:(DD_CircleListModel *)model IsUserHomePage:(BOOL )_isUserHomePage{
    
    DD_CircleDailyListCell *cell = [[DD_CircleDailyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"" IsUserHomePage:_isUserHomePage];
    [cell setListModel:model];
    [cell.contentView layoutIfNeeded];
    CGRect frame =  cell.last_count_view.frame;
    return frame.origin.y + frame.size.height+30;
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
    
    DD_OrderItemModel *_item=_listModel.items[ges.view.tag-100];
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
    if(!_isUserHomePage)
    {
        [userHeadImg JX_ScaleAspectFill_loadImageUrlStr:_listModel.userHead WithSize:400 placeHolderImageName:nil radius:44/2.0f];
        userNameLabel.text=_listModel.userName;
        if([NSString isNilOrEmpty:_listModel.career])
        {
//            userCareerLabel.text=@"貌似来自火星";
            userCareerLabel.text=@"";
            if(!_isNameCenterFit)
            {
                [userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(userHeadImg);
                    make.right.mas_equalTo(-kEdge);
                    make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);
                }];
                [userCareerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(userNameLabel.mas_bottom).with.offset(0);
                    make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);
                    make.height.mas_equalTo(0);
                }];
                _isNameCenterFit=YES;
            }
             
        }else
        {
            userCareerLabel.text=_listModel.career;
            if(_isNameCenterFit)
            {
                [userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(userHeadImg);
                    make.height.mas_equalTo(44/2.0f);
                    make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);
                }];
                [userCareerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(userNameLabel.mas_bottom).with.offset(0);
                    make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);
                }];
                
                _isNameCenterFit=NO;
            }
        }
        
    }
    
    if(_listModel.pics.count)
    {
        DD_ImageModel *imgModel=_listModel.pics[0];
        [goodImgView JX_ScaleAspectFill_loadImageUrlStr:imgModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    }
    
    
    [conentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_listModel.contentHeight);
    }];
    conentLabel.text=_listModel.shareAdvise;
    timeLabel.text=[regular getSpacingTime:_listModel.createTime];
    
    praiseBtn.selected=_listModel.isLike;
    praiseLabel.text=[[NSString alloc] initWithFormat:@"%ld",_listModel.likeTimes];
    
    commentLabel.text=[[NSString alloc] initWithFormat:@"%ld",_listModel.commentTimes];
    
    collectBtn.selected=_listModel.isCollect;
    collectLabel.text=[[NSString alloc] initWithFormat:@"%ld",_listModel.collectTimes];
    
    
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
