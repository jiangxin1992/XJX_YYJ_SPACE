//
//  DD_OrderMoreCell.m
//  DDAY
//
//  Created by yyj on 16/6/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderMoreCell.h"

@implementation DD_OrderMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
#pragma mark - Setter
-(void)setOrderModel:(DD_OrderModel *)OrderModel
{
    _OrderModel=OrderModel;
    if(_OrderModel.itemList.count)
    {
        _itemCountLabel.text=[[NSString alloc] initWithFormat:@"共%ld件商品",OrderModel.itemCount];
        _totalAmountLabel.text=[[NSString alloc] initWithFormat:@"总计￥%.1lf",[OrderModel.totalAmount floatValue]];
        
        for (UIView *_view in _scrollView.subviews) {
            [_view removeFromSuperview];
        }
        CGFloat _x_p=5;
        CGFloat _width=90;
        for (int i=0; i<_OrderModel.itemList.count; i++) {
            DD_OrderItemModel *_item=[_OrderModel.itemList objectAtIndex:i];
            UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(_x_p, 5, _width, _width)];
            [_scrollView addSubview:img];
            [img JX_loadImageUrlStr:_item.pic WithSize:800 placeHolderImageName:nil radius:0];
            _x_p+=_width+5;
        }
        _scrollView.contentSize=CGSizeMake(_x_p, 100);
        
        if(_OrderModel.orderStatus==0)
        {
            //待付款
            _leftBtn.hidden=NO;
            _rightBtn.hidden=NO;
            [_leftBtn setTitle:@"继续支付" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        }else if(_OrderModel.orderStatus==1)
        {
            //待发货
            _leftBtn.hidden=YES;
            _rightBtn.hidden=YES;
        }else if(_OrderModel.orderStatus==2)
        {
            //待收货
            _leftBtn.hidden=NO;
            _rightBtn.hidden=NO;
            [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            //                确认收货
        }else if(_OrderModel.orderStatus==3)
        {
            //交易成功
            _leftBtn.hidden=NO;
            _rightBtn.hidden=NO;
            [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }else if(_OrderModel.orderStatus==4)
        {
            
            //申请退款
            _leftBtn.hidden=NO;
            _rightBtn.hidden=YES;
            [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        }else if(_OrderModel.orderStatus==5)
        {
            //退款处理中
            _leftBtn.hidden=NO;
            _rightBtn.hidden=YES;
            [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        }else if(_OrderModel.orderStatus==6)
        {
            
            //已退款
            _leftBtn.hidden=NO;
            _rightBtn.hidden=NO;
            [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }else if(_OrderModel.orderStatus==7)
        {
            
            //拒绝退款
            _leftBtn.hidden=NO;
            _rightBtn.hidden=NO;
            [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }
    }
    
}
#pragma mark - SomeAction
- (IBAction)rightBtnAction:(id)sender {
    if(_OrderModel.orderStatus==0)
    {
        //取消订单
        _cellblock(@"cancel",_index);
        
    }else if(_OrderModel.orderStatus==2)
    {
        //确认收货
        _cellblock(@"confirm",_index);
    }else if(_OrderModel.orderStatus==3||_OrderModel.orderStatus==6||_OrderModel.orderStatus==7)
    {
        //删除订单
        _cellblock(@"delect",_index);
    }
}
- (IBAction)leftBtnAction:(id)sender {
    if(_OrderModel.orderStatus==0)
    {
        //支付
        _cellblock(@"pay",_index);
    }else if(_OrderModel.orderStatus==1)
    {
        //        提醒卖家发货
    }else if(_OrderModel.orderStatus==2||_OrderModel.orderStatus==3||_OrderModel.orderStatus==4||_OrderModel.orderStatus==5||_OrderModel.orderStatus==6||_OrderModel.orderStatus==7)
    {
        //查看物流
        _cellblock(@"logistics",_index);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
