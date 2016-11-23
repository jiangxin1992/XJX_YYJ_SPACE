//
//  DD_CirclePushlishPreViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/8/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CirclePushlishPreViewController.h"

#import "DD_CircleShowDetailImgViewController.h"
#import "DD_GoodsDetailViewController.h"
#import "DD_DesignerHomePageViewController.h"
#import "DD_TarentoHomePageViewController.h"
#import "DD_CircleViewController.h"

#import "DD_CircleDetailImgView.h"
#import "DD_CircleTagView.h"

#import "DD_CirclePublishTool.h"
#import "DD_CircleListModel.h"
#import "DD_ItemsModel.h"
#import "DD_CircleFavouriteDesignerModel.h"
#import "DD_ImageModel.h"
#import "DD_CricleChooseItemModel.h"
#import "DD_CircleModel.h"

@interface DD_CirclePushlishPreViewController ()

@end

@implementation DD_CirclePushlishPreViewController
{
    DD_CircleDetailImgView *_imgView;
    UIImageView *userHeadImg;
    UILabel *userNameLabel;
    UILabel *userCareerLabel;
    UIImageView *goodImgView;
    UILabel *conentLabel;
    NSMutableArray *goodsImgArr;
    DD_UserModel *_usermodel;
    UIScrollView *_scrollView;
    UIScrollView *_item_scrollview;
    UIView *container;
    DD_CircleTagView *_CircleTagView;
    
    UIButton *submit;
    BOOL _is_submit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - 初始化
-(instancetype)initWithCircleModel:(DD_CircleModel *)circleModel WithType:(NSString *)type WithBlock:(void (^)(NSString *type))block
{
    self=[super init];
    if(self)
    {
        _block=block;
        _circleModel=circleModel;
        _type=type;
        [self SomePrepare];
        [self UIConfig];
        [self RequestData];
        [self SetState];
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
    _is_submit=NO;
    goodsImgArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"circle_publish_preview", @"") withmaxwidth:200];
}
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"user/queryUserInfo.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            
            _usermodel=[DD_UserModel getUserModel:[data objectForKey:@"user"]];
            if(_usermodel)
            {
                if([_usermodel.userType integerValue]!=[DD_UserModel getUserType])
                {
                    [regular UpdateRoot];
                }
                [self SetState];
            }
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateSubmitView];
    [self CreateScrollView];
    [self CreateContentView];
    
}
-(void)CreateSubmitView
{
    submit=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:17.0f WithSpacing:0 WithNormalTitle:@"发布搭配" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self.view addSubview:submit];
    submit.backgroundColor=_define_black_color;
    if([_type isEqualToString:@"apply"])
    {
        [submit addTarget:self action:@selector(submitApplyAction) forControlEvents:UIControlEventTouchUpInside];
    }else if([_type isEqualToString:@"publish"])
    {
        [submit addTarget:self action:@selector(submitPublishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
}
-(void)CreateScrollView
{
    _scrollView=[[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    container = [UIView new];
    [_scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
}
-(void)CreateContentView
{
    userHeadImg=[UIImageView getCornerRadiusImg];
    [container addSubview:userHeadImg];
    userHeadImg.contentMode=2;
    [regular setZeroBorder:userHeadImg];
    userHeadImg.userInteractionEnabled=YES;
    [userHeadImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
    [userHeadImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(9);
        make.width.height.mas_equalTo(44);
    }];
    
    userNameLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:IsPhone6_gt?15.0f:14.0f WithTextColor:nil WithSpacing:0];
    [container addSubview:userNameLabel];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userHeadImg);
        make.height.mas_equalTo(44/2.0f);
        make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);
    }];
    [userNameLabel sizeToFit];
    
    
    userCareerLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [container addSubview:userCareerLabel];
    [userCareerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userNameLabel.mas_bottom).with.offset(0);
        make.height.mas_equalTo(44/2.0f);
        make.left.mas_equalTo(userHeadImg.mas_right).with.offset(6);
    }];
    [userCareerLabel sizeToFit];
    
    
    //    DD_CircleListModel *listmodel=[[DD_CircleListModel alloc] init];
    NSArray *picArr=[DD_CirclePublishTool getPicDataArrWithCircleModel:_circleModel];
    
    _imgView=[[DD_CircleDetailImgView alloc] initWithCirclePicArr:picArr WithBlock:^(NSString *type,NSInteger index) {
        //            显示图片
        DD_CircleShowDetailImgViewController *showView=[[DD_CircleShowDetailImgViewController alloc] initWithCircleArr:picArr WithType:@"data" WithIndex:index WithBlock:^(NSString *type) {
            
        }];
        [self.navigationController pushViewController:showView animated:YES];
    }];
    [container addSubview:_imgView];
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
            [container addSubview:goods];
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
            [pricebtn setBackgroundImage:[UIImage imageNamed:@"Item_PriceFrame"] forState:UIControlStateNormal];
            [pricebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(18);
            }];
            
        }
    }else
    {
        _item_scrollview=[[UIScrollView alloc] init];
        [container addSubview:_item_scrollview];
        [_item_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdge);
            make.right.mas_equalTo(-kEdge);
            make.height.mas_equalTo(66);
            make.top.mas_equalTo(_imgView.mas_bottom).with.offset(20);
        }];
    }
    conentLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [container addSubview:conentLabel];
    conentLabel.numberOfLines=0;
    [conentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if(IsPhone6_gt)
        {
            make.top.mas_equalTo(_imgView.mas_bottom).with.offset(19);
        }else
        {
            make.top.mas_equalTo(_item_scrollview.mas_bottom).with.offset(20);
        }
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
    }];
    
    _CircleTagView=[[DD_CircleTagView alloc] initWithTagArr:nil];
    [container addSubview:_CircleTagView];
    [_CircleTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(conentLabel.mas_bottom).with.offset(8.5f);
        make.height.mas_equalTo(_CircleTagView.height);
    }];
    
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kNavHeight);
        make.bottom.mas_equalTo(submit.mas_top).with.offset(0);
        // 让scrollview的contentSize随着内容的增多而变化
        make.bottom.mas_equalTo(_CircleTagView.mas_bottom).with.offset(20);
    }];
}
#pragma mark - SomeAction
-(void)submitApplyAction
{
    if(!_is_submit)
    {
        JXLOG(@"---is-submit---");
        _is_submit=YES;
        NSDictionary *_parameters=@{@"applyInfo":[@{
                                                    //                                                @"likeDesignerId":_circleModel.designerModel.likeDesignerId,
                                                    @"likeDesignerName":_circleModel.designerModel.likeDesignerName
                                                    ,@"likeReason":_circleModel.designerModel.likeReason
                                                    ,@"shareInfo":@{
                                                            @"shareAdvise":_circleModel.remark
                                                            ,@"items":[DD_CirclePublishTool getParameterItemArrWithCircleModel:_circleModel]
                                                            ,@"sharePics":[DD_CirclePublishTool getPicArrWithCircleModel:_circleModel]
                                                            ,@"tags":_circleModel.tagMap
                                                            }
                                                    } mj_JSONString],@"token":[DD_UserModel getToken]};
        
        [[JX_AFNetworking alloc] GET:@"share/applyToDoyen.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            _is_submit=NO;
            if(success)
            {
                _circleModel.status=[[data objectForKey:@"status"] integerValue];
                _block(@"update_status");
                [self.navigationController popViewControllerAnimated:YES];
                
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            _is_submit=NO;
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }
    
}
-(void)submitPublishAction
{
    if(!_is_submit)
    {
        JXLOG(@"---is-submit---");
        _is_submit=YES;
        NSDictionary *_parameters=@{
                                    @"shareInfo":[@{
                                                    @"shareAdvise":_circleModel.remark
                                                    ,@"items":[DD_CirclePublishTool getParameterItemArrWithCircleModel:_circleModel]
                                                    ,@"tags":_circleModel.tagMap
                                                    ,@"sharePics":[DD_CirclePublishTool getPicArrWithCircleModel:_circleModel]
                                                    } mj_JSONString]
                                    ,@"token":[DD_UserModel getToken]
                                    };
        [[JX_AFNetworking alloc] GET:@"share/saveShare.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
            _is_submit=NO;
            if(success)
            {
                //                回调、搭配列表下拉刷新数据
                _block(@"refresh");
                if([data objectForKey:@"isGetPoint"])
                {
                    if([[data objectForKey:@"isGetPoint"] boolValue])
                    {
                        [[DD_CustomViewController sharedManager] startSignInAnimationWithTitle:[[NSString alloc] initWithFormat:@"积分 +%ld",[[data objectForKey:@"points"] longValue]] WithType:@"getIntegral"];
                    }else
                    {
                        [[DD_CustomViewController sharedManager] startSignInAnimationWithTitle:[data objectForKey:@"message"] WithType:@"getIntegral"];
                    }
                }
                
                //                返回搭配列表界面
                NSArray *controllers=self.navigationController.viewControllers;
                for (int i=0; i<controllers.count; i++) {
                    id obj=controllers[i];
                    if([obj isKindOfClass:[DD_CircleViewController class]])
                    {
                        [self.navigationController popToViewController:obj animated:YES];
                    }
                }
            }else
            {
                [self presentViewController:successAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error, UIAlertController *failureAlert) {
            _is_submit=NO;
            [self presentViewController:failureAlert animated:YES completion:nil];
        }];
    }
    
}
-(void)SetState
{
    JXLOG(@"contentMode=%ld",userHeadImg.contentMode);
    [userHeadImg JX_ScaleAspectFill_loadImageUrlStr:_usermodel.head WithSize:400 placeHolderImageName:nil radius:44/2.0f];
    userNameLabel.text=_usermodel.nickName;
    if([NSString isNilOrEmpty:_usermodel.career])
    {
        userCareerLabel.text=@"貌似来自火星";
    }else
    {
        userCareerLabel.text=_usermodel.career;
    }
    
    _CircleTagView.tagArr=[_circleModel getTagArr];
    [_CircleTagView setState];
    [_CircleTagView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_CircleTagView.height);
    }];
    if(IsPhone6_gt)
    {
        NSArray *items=[DD_CirclePublishTool getParameterItemArrWithCircleModel:_circleModel];
        NSInteger count_index=0;
        if(items.count>3)
        {
            count_index=3;
        }else
        {
            count_index=items.count;
        }
        for (int i=0; i<goodsImgArr.count; i++) {
            UIImageView *goods=goodsImgArr[i];
            UIButton *goodsPrice=(UIButton *)[self.view viewWithTag:150+i];
            if(i<count_index)
            {
                DD_CricleChooseItemModel *item=_circleModel.chooseItem[i];
                [goods JX_ScaleAspectFill_loadImageUrlStr:item.pic.pic WithSize:400 placeHolderImageName:nil radius:0];
                goods.hidden=NO;
                [goodsPrice setTitle:[[NSString alloc] initWithFormat:@"￥%@",item.price] forState:UIControlStateNormal];
            }else
            {
                goods.hidden=YES;
            }
        }
    }else
    {
        
        NSArray *items=[DD_CirclePublishTool getParameterItemArrWithCircleModel:_circleModel];
        _item_scrollview.contentSize=CGSizeMake(66*items.count+20*(items.count-1), 66);
        CGFloat _x_p=0;
        for (int i=0; i<_circleModel.chooseItem.count; i++) {
            UIImageView *goods=[UIImageView getCustomImg];;
            [_item_scrollview addSubview:goods];
            goods.frame=CGRectMake(_x_p, 0, 66, 66);
            goods.contentMode=2;
            [regular setZeroBorder:goods];
            goods.userInteractionEnabled=YES;
            [goods addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)]];
            goods.tag=100+i;
            DD_CricleChooseItemModel *item=_circleModel.chooseItem[i];
            [goods JX_ScaleAspectFill_loadImageUrlStr:item.pic.pic WithSize:400 placeHolderImageName:nil radius:0];
            
            
            UIButton *pricebtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0f WithSpacing:0 WithNormalTitle:@"" WithNormalColor:_define_white_color WithSelectedTitle:@"" WithSelectedColor:nil];;
            [goods addSubview:pricebtn];
            pricebtn.titleLabel.font=[regular getSemiboldFont:12.0f];
            pricebtn.userInteractionEnabled=NO;
            [pricebtn setBackgroundImage:[UIImage imageNamed:@"Item_PriceFrame"] forState:UIControlStateNormal];
            [pricebtn setTitle:[[NSString alloc] initWithFormat:@"￥%@",item.price] forState:UIControlStateNormal];
            [pricebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(18);
            }];
            _x_p+=CGRectGetWidth(goods.frame)+20;
        }
    }
    
    conentLabel.text=_circleModel.remark;
}
-(void)itemAction:(UIGestureRecognizer *)ges
{
    DD_CricleChooseItemModel *item=_circleModel.chooseItem[ges.view.tag-100];
    DD_ItemsModel *_item=[[DD_ItemsModel alloc] init];
    _item.g_id=item.g_id;
    _item.colorCode=item.colorCode;
    DD_GoodsDetailViewController *_GoodsDetail=[[DD_GoodsDetailViewController alloc] initWithModel:_item WithBlock:^(DD_ItemsModel *model, NSString *type) {
        //        if(type)
    }];
    [self.navigationController pushViewController:_GoodsDetail animated:YES];
}
/**
 * 点击头像
 */
-(void)headClick
{
    if([_usermodel.userType integerValue]==2)
    {
        //                设计师
        DD_DesignerHomePageViewController *_DesignerHomePage=[[DD_DesignerHomePageViewController alloc] init];
        _DesignerHomePage.designerId=_usermodel.u_id;
        [self.navigationController pushViewController:_DesignerHomePage animated:YES];
    }else if([_usermodel.userType integerValue]==4)
    {
        //                达人
        [self.navigationController pushViewController:[[DD_TarentoHomePageViewController alloc] initWithUserId:_usermodel.u_id] animated:YES];
    }else
    {
        [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"no_homepage", @"")] animated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
