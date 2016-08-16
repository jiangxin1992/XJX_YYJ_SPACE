//
//  DD_CircleListInteractionView.m
//  DDAY
//
//  Created by yyj on 16/6/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleListInteractionView.h"

@implementation DD_CircleListInteractionView
{
    //    交互
    UIButton *collectBtn;//收藏
    UIButton *shareBtn;//分享
    UIButton *commentBtn;//评论按钮
    UILabel *commentLabel;//评论数量
    UIButton *praiseBtn;//点赞按钮
    UILabel *praiseLabel;//点赞数量
    
}
#pragma mark - 初始化
-(instancetype)initWithCircleListModel:(DD_CircleListModel *)model WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _detailModel=model;
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

-(void)PrepareData{}
-(void)PrepareUI
{
    self.backgroundColor=[UIColor whiteColor];
}
#pragma mark - UIConfig

-(void)UIConfig
{
    collectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:collectBtn];
    [collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [collectBtn setTitle:@"取消收藏" forState:UIControlStateSelected];
    [collectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    collectBtn.titleLabel.font=[regular getFont:13.0f];
    [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.width.mas_equalTo(@55);
        make.height.mas_equalTo(@40);
        make.left.mas_equalTo(20);
        
        make.bottom.mas_equalTo(-5);
    }];
    
    shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font=[regular getFont:13.0f];
    
    commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:commentBtn];
    [commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    commentBtn.titleLabel.font=[regular getFont:13.0f];

    commentLabel=[[UILabel alloc] init];
    [self addSubview:commentLabel];
    commentLabel.textAlignment=0;
    commentLabel.font=[regular getFont:11.0f];
    commentLabel.textColor=[UIColor lightGrayColor];
    
    praiseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:praiseBtn];
    [praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    [praiseBtn setTitle:@"点赞" forState:UIControlStateNormal];
    [praiseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [praiseBtn setTitle:@"取消点赞" forState:UIControlStateSelected];
    [praiseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    praiseBtn.titleLabel.font=[regular getFont:13.0f];
    
    praiseLabel=[[UILabel alloc] init];
    [self addSubview:praiseLabel];
    praiseLabel.textAlignment=0;
    praiseLabel.font=[regular getFont:11.0f];
    praiseLabel.textColor=[UIColor lightGrayColor];
    
//    循环约束
    NSArray *viewArr=@[praiseLabel,praiseBtn,commentLabel,commentBtn,shareBtn];
    UIView *lastView=nil;
    for (int i=0; i<viewArr.count; i++) {
        UIView *view=[viewArr objectAtIndex:i];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastView)
            {
                make.right.mas_equalTo(lastView.mas_left).with.offset(-5);
            }else
            {
                make.right.mas_equalTo(0);
            }
            
            make.height.mas_equalTo(collectBtn);
            if(i==1||i==3||i==4)
            {
                make.width.mas_equalTo(collectBtn);
            }else
            {
                make.width.mas_equalTo(@20);
            }
            make.top.mas_equalTo(5);
        }];
        lastView=view;
    }
}
-(void)setDetailModel:(DD_CircleListModel *)detailModel
{
    _detailModel=detailModel;
    [self setState];
}
#pragma mark - setState
-(void)setState
{
    if(_detailModel)
    {
        //    交互
        collectBtn.selected=_detailModel.isCollect;
        commentLabel.text=[[NSString alloc] initWithFormat:@"%ld",_detailModel.commentTimes];
        praiseBtn.selected=_detailModel.isLike;
        praiseLabel.text=[[NSString alloc] initWithFormat:@"%ld",_detailModel.likeTimes];
    }
}
#pragma mark - SomeAction
/**
 * 收藏
 * 取消收藏
 */
-(void)collectAction:(UIButton *)btn
{
    if(btn.selected)
    {
        _block(@"collect_cancel");
    }else
    {
        _block(@"collect");
    }
}
/**
 * 分享
 */
-(void)shareAction
{
    _block(@"share");
}
/**
 * 评论
 */
-(void)commentAction
{
    _block(@"comment");
}
/**
 * 点赞
 */
-(void)praiseAction:(UIButton *)btn
{
    if(btn.selected)
    {
        _block(@"praise_cancel");
    }else
    {
        _block(@"praise");
    }
}

@end
