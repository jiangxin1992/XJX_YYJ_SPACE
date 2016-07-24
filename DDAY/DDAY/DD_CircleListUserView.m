//
//  DD_CircleListUserView.m
//  DDAY
//
//  Created by yyj on 16/6/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleListUserView.h"

@implementation DD_CircleListUserView
{
    //    用户
    UIImageView *icon;//用户icon
    UILabel *userName;//用户名
    UILabel *career;//用户职业
    UILabel *createTime;//当前搭配创建时间
    UIButton *deleteBtn;//删除btn

}
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
    icon=[[UIImageView alloc] init];
    [self addSubview:icon];
    icon.userInteractionEnabled=YES;
    [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headAction)]];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(10);
        make.width.and.height.mas_equalTo(60);
        make.bottom.mas_equalTo(-10);
    }];
    
    userName=[[UILabel alloc] init];
    [self addSubview:userName];
    userName.textAlignment=0;
    userName.textColor=[UIColor grayColor];
    userName.font=[regular getFont:13.0f];
    
    career=[[UILabel alloc] init];
    [self addSubview:career];
    career.textAlignment=0;
    career.textColor=[UIColor lightGrayColor];
    career.font=[regular getFont:12.0f];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).with.offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
        make.top.mas_equalTo(10);
    }];
    [career mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(userName);
        make.width.mas_equalTo(userName);
        make.top.mas_equalTo(userName.mas_bottom);
        make.left.mas_equalTo(icon.mas_right).with.offset(10);
    }];
    
    deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:deleteBtn];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.hidden=YES;
    deleteBtn.titleLabel.font=[regular getFont:13.0f];
    deleteBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(userName);
        make.width.mas_equalTo(150);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-20);
    }];
    
    createTime=[[UILabel alloc] init];
    [self addSubview:createTime];
    createTime.textAlignment=2;
    createTime.textColor=[UIColor lightGrayColor];
    createTime.font=[regular getFont:12.0f];
    [createTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(userName);
        make.width.mas_equalTo(150);
        make.top.mas_equalTo(userName.mas_bottom);
        make.right.mas_equalTo(-20);
    }];
    
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
        [icon JX_loadImageUrlStr:_detailModel.userHead WithSize:400 placeHolderImageName:nil radius:30];
        
        userName.text=_detailModel.userName;
        career.text=_detailModel.career;
        createTime.text=[regular getTimeStr:_detailModel.createTime WithFormatter:@"YYYY-MM-dd HH:mm"];
        DD_UserModel *user=[DD_UserModel getLocalUserInfo];
        if([user.u_id isEqualToString:_detailModel.userId])
        {
            deleteBtn.hidden=NO;
        }else
        {
            deleteBtn.hidden=YES;
        }
    }
    
}
#pragma mark - SomeAction
/**
 * 删除
 */
-(void)deleteAction
{
    _block(@"delete");
}
/**
 * 头像点击
 */
-(void)headAction
{
    _block(@"head_click");
}
@end
