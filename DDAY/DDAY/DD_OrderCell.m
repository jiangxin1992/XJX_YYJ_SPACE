//
//  DD_OrderCell.m
//  DDAY
//
//  Created by yyj on 16/6/6.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderCell.h"

@implementation DD_OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
#pragma mark - Setter
-(void)setOrderModel:(DD_OrderModel *)OrderModel
{
    _OrderModel=OrderModel;
    if(_OrderModel.itemList.count)
    {
        DD_OrderItemModel *_itemModel=[_OrderModel.itemList objectAtIndex:0];
        [_itemImg JX_loadImageUrlStr:_itemModel.pic WithSize:800 placeHolderImageName:nil radius:0];
        _brandName.text=_itemModel.brand;
        _itemName.text=_itemModel.itemName;
        _sizeName.text=_itemModel.sizeName;
        
        if([_itemModel.price floatValue]<[_itemModel.originalPrice floatValue])
        {
            _pricelabel.text=[[NSString alloc] initWithFormat:@"￥%@ 原价￥%@",_itemModel.price,_itemModel.originalPrice];
        }else
        {
            _pricelabel.text=[[NSString alloc] initWithFormat:@"￥%@",_itemModel.price];
        }
        
        _itemCountLabel.text=[[NSString alloc] initWithFormat:@"共%ld件商品",_itemModel.itemCount];
        _numberLabel.text=[[NSString alloc] initWithFormat:@"×%ld",_itemModel.itemCount];
        _totalAmountLabel.text=[[NSString alloc] initWithFormat:@"总计￥%.1lf",[_itemModel.price floatValue]*_itemModel.itemCount];
        
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
