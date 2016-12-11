//
//  DD_CircleTagsView.m
//  DDAY
//
//  Created by yyj on 16/6/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CircleTagsView.h"

#import "DD_CircleTagModel.h"
#import "DD_CricleTagItemModel.h"
#import "DD_CircleModel.h"

@implementation DD_CircleTagsView
{
    UIView *_downView;
    
    CGFloat _width;
    
    UIButton *_addBtn;
    
    MASConstraint *_downView_h;
    
    NSMutableArray *backviewArr;
}
#pragma mark - 初始化
/**
 * 初始化
 */
-(instancetype)initWithCircleModel:(DD_CircleModel *)CircleModel WithBlock:(void (^)(NSString *type,long tag))block
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
    _width=(ScreenWidth-30-40)/4.0f;
    backviewArr=[[NSMutableArray alloc] init];
}
-(void)PrepareUI
{
    self.backgroundColor=_define_white_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    _downView=[[UIView alloc] init];
    [self addSubview:_downView];
    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.left.top.and.right.mas_equalTo(0);
        _downView_h=make.height.mas_equalTo(100);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
    }];
    
    _addBtn=[UIButton getCustomImgBtnWithImageStr:@"System_Add" WithSelectedImageStr:nil];
    [_downView addSubview:_addBtn];
    [_addBtn addTarget:self action:@selector(addCustomAction) forControlEvents:UIControlEventTouchUpInside];
    [_addBtn setEnlargeEdgeWithTop:0 right:100 bottom:0 left:0];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.width.height.mas_equalTo(20);
        make.top.mas_equalTo(10);
    }];
    
    UILabel *title=[UILabel getLabelWithAlignment:0 WithTitle:@"添加标签" WithFont:15.0f WithTextColor:_define_black_color WithSpacing:0];
    [_downView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_addBtn);
        make.left.mas_equalTo(_addBtn.mas_right).with.offset(5);
    }];
//    [title sizeToFit];
    
}


#pragma mark - setState
-(void)setState
{
    [backviewArr enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
//    for (UIView *view in backviewArr) {
//        [view removeFromSuperview];
//    }
    [_downView_h uninstall];
    __block UIView *lastView=nil;
    
    [_circleModel.shareTags enumerateObjectsUsingBlock:^(DD_CircleTagModel *_tagModel, NSUInteger idx, BOOL * _Nonnull stop) {
        //        子标签大于1的时候才添加
        if(_tagModel.tags.count)
        {
            UIView *backView=[[UIView alloc] init];
            [_downView addSubview:backView];
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                if(lastView)
                {
                    make.top.mas_equalTo(lastView.mas_bottom).with.offset(0);
                }else
                {
                    make.top.mas_equalTo(_addBtn.mas_bottom).with.offset(20);
                }
                make.left.mas_equalTo(kEdge);
                make.right.mas_equalTo(-kEdge);
            }];
            UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:_tagModel.CategoryName WithFont:14.0f WithTextColor:_define_black_color WithSpacing:0];
            [backView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.and.right.mas_equalTo(0);
                make.height.mas_equalTo(30);
            }];
            // 创建一个空view 代表上一个view
            __block UIButton *lastBtn = nil;
            // 间距为10
            __block int intes = 10;
            // 每行4个
            __block int num = 0;
            
            __block CGFloat _x_p=0;
            // 循环创建view
            
            [_tagModel.tags enumerateObjectsUsingBlock:^(DD_CricleTagItemModel *item, NSUInteger idx2, BOOL * _Nonnull stop2) {
                UIButton *btn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:13.0f WithSpacing:0 WithNormalTitle:item.tagName WithNormalColor:_define_black_color WithSelectedTitle:item.tagName WithSelectedColor:_define_white_color];
                [backView addSubview:btn];
                btn.tag=100*idx+idx2;
                [regular setBorder:btn];
                if(item.is_select)
                {
                    btn.selected=item.is_select;
                    btn.backgroundColor=_define_black_color;
                }else
                {
                    btn.selected=item.is_select;
                    btn.backgroundColor=_define_white_color;
                }
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                CGFloat __width=[regular getWidthWithHeight:28 WithContent:item.tagName WithFont:[regular getFont:13.0f]]+25;
                
                
                if((_x_p+__width+intes)>ScreenWidth-2*kEdge)
                {
                    num++;
                    _x_p=0;
                }
                
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(btn.superview).offset(40+35*num);
                    make.left.mas_equalTo(_x_p);
                    make.width.mas_equalTo(__width);
                    make.height.mas_equalTo(28);
                }];
                if((_x_p+__width+intes)>ScreenWidth-2*kEdge)
                {
                }else
                {
                    _x_p+=__width+intes;
                }
                // 每次循环结束 此次的View为下次约束的基准
                lastBtn = btn;
            }];
//            for (int j=0; j<_tagModel.tags.count; j++) {
//                DD_CricleTagItemModel *item=_tagModel.tags[j];
//                //                25
//                UIButton *btn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:13.0f WithSpacing:0 WithNormalTitle:item.tagName WithNormalColor:_define_black_color WithSelectedTitle:item.tagName WithSelectedColor:_define_white_color];
//                [backView addSubview:btn];
//                btn.tag=100*idx+j;
//                [regular setBorder:btn];
//                if(item.is_select)
//                {
//                    btn.selected=item.is_select;
//                    btn.backgroundColor=_define_black_color;
//                }else
//                {
//                    btn.selected=item.is_select;
//                    btn.backgroundColor=_define_white_color;
//                }
//                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//                CGFloat __width=[regular getWidthWithHeight:28 WithContent:item.tagName WithFont:[regular getFont:13.0f]]+25;
//                
//                
//                if((_x_p+__width+intes)>ScreenWidth-2*kEdge)
//                {
//                    num++;
//                    _x_p=0;
//                }
//                
//                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.top.mas_equalTo(btn.superview).offset(40+35*num);
//                    make.left.mas_equalTo(_x_p);
//                    make.width.mas_equalTo(__width);
//                    make.height.mas_equalTo(28);
//                }];
//                if((_x_p+__width+intes)>ScreenWidth-2*kEdge)
//                {
//                }else
//                {
//                    _x_p+=__width+intes;
//                }
//                
//                
//                // 每次循环结束 此次的View为下次约束的基准
//                lastBtn = btn;
//            }
            if(lastBtn)
            {
                [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(-10);
                }];
            }else
            {
                [backView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
            }
            lastView=backView;
            [backviewArr addObject:backView];
        }
    }];
//    for (int i=0; i<_circleModel.shareTags.count; i++)
//    {
//        DD_CircleTagModel *_tagModel=_circleModel.shareTags[i];
////        子标签大于1的时候才添加
//        if(_tagModel.tags.count)
//        {
//            UIView *backView=[[UIView alloc] init];
//            [_downView addSubview:backView];
//            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
//                if(lastView)
//                {
//                    make.top.mas_equalTo(lastView.mas_bottom).with.offset(0);
//                }else
//                {
//                    make.top.mas_equalTo(_addBtn.mas_bottom).with.offset(20);
//                }
//                make.left.mas_equalTo(kEdge);
//                make.right.mas_equalTo(-kEdge);
//            }];
//            UILabel *titleLabel=[UILabel getLabelWithAlignment:0 WithTitle:_tagModel.CategoryName WithFont:14.0f WithTextColor:_define_black_color WithSpacing:0];
//            [backView addSubview:titleLabel];
//            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.top.and.right.mas_equalTo(0);
//                make.height.mas_equalTo(30);
//            }];
//            // 创建一个空view 代表上一个view
//            UIButton *lastBtn = nil;
//            // 间距为10
//            int intes = 10;
//            // 每行4个
//            int num = 0;
//            CGFloat _x_p=0;
//            // 循环创建view
//            for (int j=0; j<_tagModel.tags.count; j++) {
//                DD_CricleTagItemModel *item=_tagModel.tags[j];
////                25
//                UIButton *btn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:13.0f WithSpacing:0 WithNormalTitle:item.tagName WithNormalColor:_define_black_color WithSelectedTitle:item.tagName WithSelectedColor:_define_white_color];
//                [backView addSubview:btn];
//                btn.tag=100*i+j;
//                [regular setBorder:btn];
//                if(item.is_select)
//                {
//                    btn.selected=item.is_select;
//                    btn.backgroundColor=_define_black_color;
//                }else
//                {
//                    btn.selected=item.is_select;
//                    btn.backgroundColor=_define_white_color;
//                }
//                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//                CGFloat __width=[regular getWidthWithHeight:28 WithContent:item.tagName WithFont:[regular getFont:13.0f]]+25;
//                
//                
//                if((_x_p+__width+intes)>ScreenWidth-2*kEdge)
//                {
//                    num++;
//                    _x_p=0;
//                }
//                
//                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.top.mas_equalTo(btn.superview).offset(40+35*num);
//                    make.left.mas_equalTo(_x_p);
//                    make.width.mas_equalTo(__width);
//                    make.height.mas_equalTo(28);
//                }];
//                if((_x_p+__width+intes)>ScreenWidth-2*kEdge)
//                {
//                }else
//                {
//                    _x_p+=__width+intes;
//                }
//                
//                
//                // 每次循环结束 此次的View为下次约束的基准
//                lastBtn = btn;
//            }
//            if(lastBtn)
//            {
//                [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.bottom.mas_equalTo(-10);
//                }];
//            }else
//            {
//                [backView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.mas_equalTo(0);
//                }];
//            }
//            lastView=backView;
//            [backviewArr addObject:backView];
//        }
//    }
    if(lastView)
    {
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
    }else
    {
        [_downView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}
#pragma mark - SomeAction

/**
 * 标签点击
 */
-(void)btnAction:(UIButton *)btn
{
    NSInteger _index=btn.tag/100;
    NSInteger _row=btn.tag%100;
    DD_CircleTagModel *_tagModel=_circleModel.shareTags[_index];
    DD_CricleTagItemModel *item=_tagModel.tags[_row];
    
    if(btn.selected)
    {
        item.is_select=NO;
        if(![_tagModel.parameterName isEqualToString:@"customTags"])
        {
            [_tagModel updateLastSelect];
        }
        _block(@"circle_tag_delete",btn.tag);
    }else
    {
        if([_tagModel.parameterName isEqualToString:@"customTags"])
        {
            [_tagModel.tags enumerateObjectsUsingBlock:^(DD_CricleTagItemModel *__item, NSUInteger idx, BOOL * _Nonnull stop) {
                __item.is_select=NO;
            }];
//            for (DD_CricleTagItemModel *__item in _tagModel.tags) {
//                __item.is_select=NO;
//            }
        }else
        {
            if(!_tagModel.lastItem)
            {
                _tagModel.lastItem=item;
                [_tagModel.tags enumerateObjectsUsingBlock:^(DD_CricleTagItemModel *__item, NSUInteger idx, BOOL * _Nonnull stop) {
                    __item.is_select=NO;
                }];
//                for (DD_CricleTagItemModel *__item in _tagModel.tags) {
//                    __item.is_select=NO;
//                }
            }else
            {
                [_tagModel.tags enumerateObjectsUsingBlock:^(DD_CricleTagItemModel *__item, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([_tagModel.lastItem.t_id longLongValue]==[__item.t_id longLongValue])
                    {
                        __item.is_select=YES;
                    }else
                    {
                        __item.is_select=NO;
                    }
                }];
//                for (DD_CricleTagItemModel *__item in _tagModel.tags) {
//                    if([_tagModel.lastItem.t_id longLongValue]==[__item.t_id longLongValue])
//                    {
//                        __item.is_select=YES;
//                    }else
//                    {
//                        __item.is_select=NO;
//                    }
//                }
            }
        }
        item.is_select=YES;
        _block(@"circle_tag_add",btn.tag);
    }

}

/**
 * 添加自定义标签
 */
-(void)addCustomAction
{
    _block(@"add_custom_tag",0);
}
@end
