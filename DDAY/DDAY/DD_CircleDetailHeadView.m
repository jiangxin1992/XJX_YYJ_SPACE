//
//  DD_CircleDetailHeadView.m
//  DDAY
//
//  Created by yyj on 16/6/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleDetailHeadView.h"

#import "DD_CircleDetailImgView.h"
#import "DD_CircleTagView.h"

@implementation DD_CircleDetailHeadView
{

    DD_CircleDetailImgView *_imgView;
    UIImageView *userHeadImg;
    UILabel *userNameLabel;
    UILabel *userCareerLabel;
    UILabel *_conentLabel;
    
    UIScrollView *_item_scrollview;
    
    NSMutableArray *goodsImgArr;
    NSMutableArray *userBtnArr;
    
    UIButton *moreBtn;
}

#pragma mark - 初始化
-(instancetype)initWithCircleListModel:(DD_CircleListModel *)model IsHomePage:(BOOL )isHomePage WithBlock:(void (^)(NSString *type,NSInteger index,DD_OrderItemModel *item))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _listModel=model;
        _isHomePage=isHomePage;
        
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
    goodsImgArr=[[NSMutableArray alloc] init];
    userBtnArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
    self.backgroundColor=_define_white_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    _contentView=[UIView getCustomViewWithColor:nil];
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    userHeadImg=[UIImageView getCornerRadiusImg];
    [_contentView addSubview:userHeadImg];
    userHeadImg.contentMode=2;
    [regular setZeroBorder:userHeadImg];
    userHeadImg.userInteractionEnabled=YES;
    [userHeadImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
    [userHeadImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(9);
        make.width.height.mas_equalTo(44);
//        make.left.mas_equalTo(IsPhone6_gt?34:15);
    }];
    
    userNameLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:IsPhone6_gt?15.0f:14.0f WithTextColor:nil WithSpacing:0];
    [_contentView addSubview:userNameLabel];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userHeadImg);
        make.height.mas_equalTo(44/2.0f);
        make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);
    }];
    [userNameLabel sizeToFit];
    
    
    userCareerLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [_contentView addSubview:userCareerLabel];
    [userCareerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userNameLabel.mas_bottom).with.offset(0);
        make.height.mas_equalTo(44/2.0f);
        make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);
    }];
    [userCareerLabel sizeToFit];
    
    
    _imgView=[[DD_CircleDetailImgView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type,NSInteger index) {
        _block(type,index,nil);
    }];
    [_contentView addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userHeadImg);
        make.top.mas_equalTo(userHeadImg.mas_bottom).with.offset(19);
        if(IsPhone6_gt)
        {
            make.width.mas_equalTo(IsPhone6_gt?234:190);
        }else
        {
            make.right.mas_equalTo(-kEdge);
        }
        make.height.mas_equalTo(300);
    }];

    if(IsPhone6_gt)
    {
        UIView *lastView=nil;
        for (int i=0; i<3; i++) {
            UIImageView *goods=[UIImageView getCustomImg];
            [_contentView addSubview:goods];
            goods.contentMode=2;
            [regular setZeroBorder:goods];
            goods.userInteractionEnabled=YES;
            goods.tag=100+i;
            [goods addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)]];
            [goods mas_makeConstraints:^(MASConstraintMaker *make) {
                //            make.right.mas_equalTo(-(IsPhone6_gt?34:15));
                make.right.mas_equalTo(-kEdge);
                make.width.height.mas_equalTo(66);
                if(lastView)
                {
                    make.bottom.mas_equalTo(lastView.mas_top).with.offset(-24);
                }else
                {
                    make.bottom.mas_equalTo(_imgView.mas_bottom).with.offset(0);
                }
            }];
            lastView=goods;
            [goodsImgArr addObject:goods];
            
            UIButton *pricebtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_white_color WithSelectedTitle:@"" WithSelectedColor:nil];
            [goods addSubview:pricebtn];
            pricebtn.titleLabel.font=[regular getSemiboldFont:12.0f];
            pricebtn.userInteractionEnabled=NO;
            pricebtn.tag=150+i;
            [pricebtn setBackgroundImage:[UIImage imageNamed:@"Circle_PriceFrame"] forState:UIControlStateNormal];
            [pricebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(18);
            }];
            if(i==2)
            {
                moreBtn=[UIButton getCustomImgBtnWithImageStr:@"Circle_More" WithSelectedImageStr:nil];
                [_contentView addSubview:moreBtn];
                //            25 25
                [moreBtn setImageEdgeInsets:UIEdgeInsetsMake((300-66*3-24*2-25)/2.0f, (66-25)/2.0f, (300-66*3-24*2-25)/2.0f, (66-25)/2.0f)];
                [moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
                [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(lastView.mas_top).with.offset(0);
                    make.right.mas_equalTo(lastView);
                    make.left.mas_equalTo(lastView);
                    make.top.mas_equalTo(_imgView);
                }];
            }
        }
    }else
    {
        _item_scrollview=[[UIScrollView alloc] init];
        [_contentView addSubview:_item_scrollview];
        [_item_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            make.right.mas_equalTo(-kEdge);
            make.height.mas_equalTo(66);
            make.top.mas_equalTo(_imgView.mas_bottom).with.offset(20);
        }];
    }
    
    
    _conentLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [_contentView addSubview:_conentLabel];
    _conentLabel.numberOfLines=0;
    [_conentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if(IsPhone6_gt)
        {
            make.top.mas_equalTo(_imgView.mas_bottom).with.offset(19);
        }else
        {
            make.top.mas_equalTo(_item_scrollview.mas_bottom).with.offset(20);
        }
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
//        make.left.mas_equalTo(IsPhone6_gt?34:15);
//        make.right.mas_equalTo(-(IsPhone6_gt?34:15));
    }];
    [_conentLabel sizeToFit];
    
    DD_CircleTagView *_CircleTagView=[[DD_CircleTagView alloc] initWithTagArr:[_listModel getTagArr]];
    [_contentView addSubview:_CircleTagView];
    CGFloat _height=[DD_CircleTagView GetHeightWithTagArr:[_listModel getTagArr]];
    [_CircleTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(_conentLabel.mas_bottom).with.offset(8.5f);
        make.height.mas_equalTo(_height);
    }];
    
    
    UIView *_lastView_state=nil;
    UIView *_last_count_view=nil;
    NSArray *imgArr_normal=nil;
    NSArray *imgArr_select=nil;
    if(_isHomePage)
    {
        imgArr_normal=@[@"System_NoGood",@"System_Comment",@"System_Notcollection",@"System_Dustbin"];
        imgArr_select=@[@"System_Good",@"System_Comment",@"System_Collection",@"System_Dustbin"];
    }else
    {
        imgArr_normal=@[@"System_NoGood",@"System_Comment",@"System_Notcollection",@"System_Dustbin"];
        imgArr_select=@[@"System_Good",@"System_Comment",@"System_Collection",@"System_Dustbin"];
    }
    //    删除 评论 收藏 点赞
    for (int i=0; i<imgArr_normal.count; i++) {
        UIButton *btn=[UIButton getCustomImgBtnWithImageStr:[imgArr_normal objectAtIndex:i] WithSelectedImageStr:[imgArr_select objectAtIndex:i]];
        [_contentView addSubview:btn];
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
//            25.5 23
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
//                make.right.mas_equalTo(-47);
                make.right.mas_equalTo(-kEdge);
                make.width.mas_equalTo(25);
                make.height.mas_equalTo(44);
                if([_listModel getTagArr].count)
                {
                    make.top.mas_equalTo(_CircleTagView.mas_bottom).with.offset(8);
                }else
                {
                    make.top.mas_equalTo(_CircleTagView.mas_bottom).with.offset(0);
                }
                
            }
        }];
        [userBtnArr addObject:btn];
        
        UILabel *label=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
        [self.contentView addSubview:label];
        label.font=[regular get_en_Font:12.0f];
        label.tag=300+i;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(btn);
            if(_last_count_view)
            {
                make.top.mas_equalTo(_last_count_view);
            }else
            {
                make.top.mas_equalTo(btn.mas_bottom).with.offset(0);
            }
        }];
        
        _last_count_view=label;
        _lastView_state=btn;
    }
    
    _timeLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [_contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(IsPhone6_gt?34:15);
        make.left.mas_equalTo(kEdge);
        make.centerY.mas_equalTo(_lastView_state);
        make.width.mas_equalTo(100);
    }];
    [_timeLabel sizeToFit];
    
    [_last_count_view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
    }];
    
    JXLOG(@"%@",_listModel);
    JXLOG(@"111");
    
    
}
#pragma mark - setter
-(void)setListModel:(DD_CircleListModel *)listModel
{
    _listModel=listModel;
    [self setState];
}

#pragma mark - SomeAction
-(void)moreAction
{
    _block(@"show_item_list",0,nil);
}
/**
 * 点击头像
 */
-(void)headClick
{
    _block(@"head_click",0,nil);
}
/**
 * 点赞评论...
 */
-(void)userAction:(UIButton *)btn
{
    NSInteger _btnindex=btn.tag-200;
    if(_btnindex==0){
        //        点赞
        if(btn.selected)
        {
            _block(@"praise_cancel",0,nil);
        }else
        {
            _block(@"praise",0,nil);
        }
        
        
    }else if(_btnindex==1)
    {
        //        评论
        _block(@"comment",0,nil);
        
    }else if(_btnindex==2)
    {
        //        收藏
        if(btn.selected)
        {
            _block(@"collect_cancel",0,nil);
        }else
        {
            _block(@"collect",0,nil);
        }
        
    }else if(_btnindex==3)
    {
        //        删除
        _block(@"delete",0,nil);
    }
}
/**
 * 点击单品
 */
-(void)itemAction:(UIGestureRecognizer *)ges
{
    
    DD_OrderItemModel *_item=[_listModel.items objectAtIndex:ges.view.tag-100];
    _block(@"item_click",0,_item);
}
/**
 * 计算高度
 */
+ (CGFloat)heightWithModel:(DD_CircleListModel *)model{
    DD_CircleDetailHeadView *cell = [[DD_CircleDetailHeadView alloc] initWithCircleListModel:model IsHomePage:NO WithBlock:nil];
    [cell layoutIfNeeded];
    return cell.contentView.frame.size.height;
}
/**
 * 更新
 */
-(void)setState
{
    [userHeadImg JX_ScaleAspectFill_loadImageUrlStr:_listModel.userHead WithSize:400 placeHolderImageName:nil radius:44/2.0f];
    userNameLabel.text=_listModel.userName;
    if([NSString isNilOrEmpty:_listModel.career])
    {
        userCareerLabel.text=@"貌似来自火星";
    }else
    {
        userCareerLabel.text=_listModel.career;
    }
    if(IsPhone6_gt)
    {
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
                [goods JX_ScaleAspectFill_loadImageUrlStr:_order.pic WithSize:400 placeHolderImageName:nil radius:0];
                goods.hidden=NO;
                [goodsPrice setTitle:[[NSString alloc] initWithFormat:@"￥%@",_order.price] forState:UIControlStateNormal];
            }else
            {
                goods.hidden=YES;
            }
        }
        if(_listModel.items.count>3)
        {
            moreBtn.hidden=NO;
        }else
        {
            moreBtn.hidden=YES;
        }
    }else
    {
        
        _item_scrollview.contentSize=CGSizeMake(66*_listModel.items.count+20*(_listModel.items.count-1), 66);
        CGFloat _x_p=0;
        for (int i=0; i<_listModel.items.count; i++) {
            UIImageView *goods=[UIImageView getCustomImg];;
            [_item_scrollview addSubview:goods];
            goods.frame=CGRectMake(_x_p, 0, 66, 66);
            goods.contentMode=2;
            [regular setZeroBorder:goods];
            goods.userInteractionEnabled=YES;
            [goods addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)]];
            goods.tag=100+i;
            DD_OrderItemModel *_order=[_listModel.items objectAtIndex:i];
            [goods JX_ScaleAspectFill_loadImageUrlStr:_order.pic WithSize:400 placeHolderImageName:nil radius:0];
            
            
            UIButton *pricebtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_white_color WithSelectedTitle:@"" WithSelectedColor:nil];;
            [goods addSubview:pricebtn];
            pricebtn.titleLabel.font=[regular getSemiboldFont:12.0f];
            pricebtn.userInteractionEnabled=NO;
            [pricebtn setBackgroundImage:[UIImage imageNamed:@"Circle_PriceFrame"] forState:UIControlStateNormal];
            [pricebtn setTitle:[[NSString alloc] initWithFormat:@"￥%@",_order.price] forState:UIControlStateNormal];
            [pricebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(18);
            }];
            _x_p+=CGRectGetWidth(goods.frame)+20;
        }
    }
    
    _conentLabel.text=_listModel.shareAdvise;
    _timeLabel.text=[regular getSpacingTime:_listModel.createTime];
    
    UIButton *praiseBtn=[_contentView viewWithTag:200];
    praiseBtn.selected=_listModel.isLike;
    UILabel *praiseLabel=[self viewWithTag:300];
    praiseLabel.text=[[NSString alloc] initWithFormat:@"%ld",_listModel.likeTimes];
    UILabel *commentLabel=[self viewWithTag:301];
    commentLabel.text=[[NSString alloc] initWithFormat:@"%ld",_listModel.commentTimes];
   
    
    UIButton *collectBtn=[_contentView viewWithTag:202];
    collectBtn.selected=_listModel.isCollect;
    UILabel *collectLabel=[self viewWithTag:302];
    collectLabel.text=[[NSString alloc] initWithFormat:@"%ld",_listModel.collectTimes];
    
    UIButton *delectBtn=[_contentView viewWithTag:203];
    DD_UserModel *user=[DD_UserModel getLocalUserInfo];
    if([DD_UserModel isLogin] && [_listModel.userId isEqualToString:user.u_id])
    {
        delectBtn.hidden=NO;
    }else
    {
        delectBtn.hidden=YES;
    }
}
//-(void)update
//{
//    _interactionView.detailModel=_listModel;
//}
//-(void)CreateUserView
//{
//    _userView=[[DD_CircleListUserView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type) {
//        _block(type,0);
//    }];
//    [self addSubview:_userView];
//    [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.and.right.mas_equalTo(0);
//    }];
//}
//-(void)CreateImgView
//{
//    _imgView=[[DD_CircleDetailImgView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type,NSInteger index) {
//        _block(type,0,nil);
//    }];
//    [self addSubview:_imgView];
//    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.mas_equalTo(0);
//        make.top.mas_equalTo(_userView.mas_bottom).with.offset(0);
//    }];
//}
//-(void)CreateSuggestView
//{
//    _suggestView=[[DD_CircleListSuggestView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type) {
//        _block(type,0);
//    }];
//    [self addSubview:_suggestView];
//    [_suggestView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.mas_equalTo(0);
//        make.top.mas_equalTo(_imgView.mas_bottom).with.offset(0);
//    }];
//}
//-(void)CreateInteractionView
//{
//    _interactionView=[[DD_CircleListInteractionView alloc] initWithCircleListModel:_listModel WithBlock:^(NSString *type) {
//        _block(type,0);
//    }];
//    [self addSubview:_interactionView];
//    [_interactionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.mas_equalTo(0);
//        make.top.mas_equalTo(_suggestView.mas_bottom).with.offset(2);
//    }];
//}
@end
