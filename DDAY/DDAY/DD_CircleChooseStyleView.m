//
//  DD_CircleChooseStyleView.m
//  DDAY
//
//  Created by yyj on 16/6/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleChooseStyleView.h"

#import "UIButton+WebCache.h"

#import "DD_CricleChooseItemModel.h"

@implementation DD_CircleChooseStyleView
{
    UIView *_upView;
    UIView *_downView;
    CGFloat _width;
    
    NSMutableArray *btnArr;

    UIScrollView *_scrollView;
    
    CGFloat intes;

}

#pragma mark - 初始化
/**
 * 初始化
 */

-(instancetype)initWithCircleModel:(DD_CircleModel *)CircleModel WithBlock:(void (^)(NSString *type,NSInteger index))block
{
    self=[super init];
    if(self)
    {
        _circleModel=CircleModel;
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
-(void)PrepareData
{
    btnArr=[[NSMutableArray alloc] init];
    intes=12;//间距为12
    _width=(ScreenWidth-intes*2-kEdge*2)/3.0f;
}
-(void)PrepareUI
{
    self.userInteractionEnabled=YES;
    self.backgroundColor=_define_white_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateUpView];
    [self CreateDownView];
}
-(void)CreateUpView
{
    _upView=[UIView getCustomViewWithColor:nil];
    [self addSubview:_upView];
    [_upView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseStyle)]];
    [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.left.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *leftLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"款式选择" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [_upView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.centerY.mas_equalTo(_upView);
    }];
    [leftLabel sizeToFit];

    UIImageView *rightImg=[UIImageView getImgWithImageStr:@"System_Arrow"];
    [_upView addSubview:rightImg];
    
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_upView);
        make.right.mas_equalTo(-kEdge);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(25);
        
    }];
    
//    //            删除已选款式
//    DD_CricleChooseItemModel *item=[_circleModel.chooseItem objectAtIndex:btn.tag-150];
//    item.isSelect=NO;
//    //    删除item 对应的已选款式
//    [DD_CirclePublishTool delChooseItemModel:item WithCircleModel:_circleModel];
//    
//    _block(@"delete_choose_item",btn.tag-150);
//    [self UpdateImgView];
//    [mywaterflow reloadData];
}
-(void)CreateDownView
{
    _downView=[[UIView alloc] init];
    [self addSubview:_downView];
    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(_upView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
    }];
}

-(void)CreateScrollView
{
    if(_circleModel.chooseItem.count)
    {
        [_downView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(_width+32));
        }];
        NSLog(@"1111");
        _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(kEdge, 0, ScreenWidth-kEdge*2, _width)];
        [_downView addSubview:_scrollView];
        _scrollView.contentSize=CGSizeMake((_circleModel.chooseItem.count-1)*intes+_width*_circleModel.chooseItem.count, _width);
        
        CGFloat _x_p=0;
        for (int i=0; i<_circleModel.chooseItem.count; i++) {
            DD_CricleChooseItemModel *item=[_circleModel.chooseItem objectAtIndex:i];
            
            UIView *backView=[UIView getCustomViewWithColor:nil];
            [_scrollView addSubview:backView];
            backView.frame=CGRectMake(_x_p, 0, _width, _width);
            
            UIImageView *imgView=[UIImageView getCustomImg];
            [backView addSubview:imgView];
            imgView.contentMode=2;
            [regular setZeroBorder:imgView];
            imgView.userInteractionEnabled=YES;
            imgView.frame=CGRectMake(0, 16, _width-16, _width-16);
            [imgView JX_ScaleAspectFill_loadImageUrlStr:item.pic.pic WithSize:400 placeHolderImageName:nil radius:0];
            
            UIButton *deleteBtn=[UIButton getCustomImgBtnWithImageStr:@"System_Delete" WithSelectedImageStr:nil];
            [backView addSubview:deleteBtn];
            deleteBtn.tag=150+i;
            [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [deleteBtn setEnlargeEdge:10];
            deleteBtn.frame=CGRectMake(CGRectGetWidth(backView.frame)-25-3.5, 3.5, 25, 25);
            
            _x_p+=_width+intes;
            
            [btnArr addObject:backView];
        }
    }else
    {
        [_downView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0);
        }];
        NSLog(@"1111");
    }
    
}
#pragma mark - SomeAction
/**
 * 更新款式界面
 */
-(void)updateImageView
{
    for (UIView *view in btnArr) {
        [view removeFromSuperview];
    }
    [self CreateScrollView];
}
/**
 * 删除已选款式
 */
-(void)deleteAction:(UIButton *)btn
{
    NSInteger _index=btn.tag-150;
    _block(@"delete_choose_item",_index);
}
/**
 * 款式选择
 */
-(void)chooseStyle
{
    _block(@"chooseStyle",0);
}
//-(void)CreateScrollView
//{
//    //    110
//    
//    NSInteger _count=_circleModel.chooseItem.count;
//    CGFloat _h=0;
//    if(_circleModel.chooseItem.count)
//    {
//        _h=(_width+10)*(((_count-1)/4)+1);
//    }else
//    {
//        _h=0;
//    }
//    [_downView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(_h);
//    }];
//    
//    // 创建一个空view 代表上一个view
//    __block UIView *lastView = nil;
//    // 间距为10
//    int intes = 10;
//    // 每行4个
//    int num = 4;
//    // 循环创建view
//    
//    for (int i = 0; i < _circleModel.chooseItem.count; i++) {
//        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
//        view.tag=100+i;
//        [_downView addSubview:view];
//        
//        
//        DD_CricleChooseItemModel *item=[_circleModel.chooseItem objectAtIndex:i];
//        
//        [view sd_setImageWithURL:[NSURL URLWithString:[regular getImgUrl:item.pic WithSize:200]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headImg_login1"]];
//        
//        [view addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        //        view.backgroundColor = [UIColor colorWithHue:(arc4random() % 256 / 256.0 ) saturation:( arc4random() % 128 / 256.0 ) + 0.5
//        //                                          brightness:( arc4random() % 128 / 256.0 ) + 0.5 alpha:0.2];
//        
//        // 添加约束
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            // 给个高度约束
//            make.height.and.width.mas_equalTo(_width);
//            // 2. 判断是否是第一列
//            if (i % num == 0) {
//                // 一：是第一列时 添加左侧与父视图左侧约束
//                make.left.mas_equalTo(view.superview).offset(intes);
//            } else {
//                // 二： 不是第一列时 添加左侧与上个view左侧约束
//                make.left.mas_equalTo(lastView.mas_right).offset(intes);
//            }
//            // 3. 判断是否是最后一列 给最后一列添加与父视图右边约束
//            if (i % num == (num - 1)) {
//                make.right.mas_equalTo(view.superview).offset(-intes);
//            }
//            // 4. 判断是否为第一列
//            if (i / num == 0) {
//                // 第一列添加顶部约束
//                make.top.mas_equalTo(view.superview).offset(0);
//            } else {
//                // 其余添加顶部约束 intes*10 是我留出的距顶部高度
//                make.top.mas_equalTo( ( i / num )* (_width + intes));
//            }
//        }];
//        // 每次循环结束 此次的View为下次约束的基准
//        lastView = view;
//        [btnArr addObject:view];
//    }
//    if(lastView)
//    {
//        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(-10);
//        }];
//    }
//}

@end
