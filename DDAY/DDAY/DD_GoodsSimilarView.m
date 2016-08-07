//
//  DD_GoodsSimilarView.m
//  YCO SPACE
//
//  Created by yyj on 16/8/3.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_GoodsSimilarView.h"

@implementation DD_GoodsSimilarView
-(instancetype)initWithGoodsSimilarArr:(NSArray *)similarArr WithBlock:(void (^)(NSString *type,DD_OrderItemModel *itemModel))block
{
    self=[super init];
    if(self)
    {
        _similarArr=similarArr;
        _block=block;
        [self UIConfig];
    }
    return self;
}
-(void)UIConfig
{
    self.backgroundColor=_define_white_color;
    UILabel *SimilarTitleLabel=[UILabel getLabelWithAlignment:1 WithTitle:@"相似款式" WithFont:13.0f WithTextColor:_define_white_color WithSpacing:0];
    [self addSubview:SimilarTitleLabel];
    SimilarTitleLabel.backgroundColor=_define_black_color;
    [SimilarTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(self).with.offset(22);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(23);
        if(!_similarArr.count)
        {
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(-20);
        }
    }];
    
    UIImageView *lastView=nil;
    CGFloat _width=(ScreenWidth-kEdge*2-kEdge)/2.0f;
    for (int i=0; i<_similarArr.count; i++) {
        DD_OrderItemModel *model=[_similarArr objectAtIndex:i];
        UIImageView *img=[UIImageView getCustomImg];
        [self addSubview:img];
        img.tag=100+i;
        img.userInteractionEnabled=YES;
        [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)]];
        [img JX_loadImageUrlStr:model.pic WithSize:800 placeHolderImageName:nil radius:0];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastView)
            {
                make.left.mas_equalTo(lastView.mas_right).with.offset(kEdge);
            }else
            {
                make.left.mas_equalTo(kEdge);
                make.bottom.mas_equalTo(self.mas_bottom).with.offset(-20);
            }
            make.top.mas_equalTo(SimilarTitleLabel.mas_bottom).with.offset(11);
            make.width.mas_equalTo(_width);
            make.height.mas_equalTo(IsPhone6_gt?205:178);
        }];
        lastView=img;
    }
}
-(void)imgClick:(UIGestureRecognizer *)ges
{
    
    NSInteger index=ges.view.tag-100;
    DD_OrderItemModel *itemModel=[_similarArr objectAtIndex:index];
    
    _block(@"img_click",itemModel);
}
@end
