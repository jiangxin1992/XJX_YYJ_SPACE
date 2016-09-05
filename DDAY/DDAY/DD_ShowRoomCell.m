//
//  DD_ShowRoomCell.m
//  YCO SPACE
//
//  Created by yyj on 16/8/19.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShowRoomCell.h"

#import "DD_ImageModel.h"
#import "MyPoint.h"

@implementation DD_ShowRoomCell
{
    UILabel *_store_name;
    UILabel *_address;
    UIView *_img_back_view;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - 初始化
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type))block
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.block=block;
        [self UIConfig];
    }
    return  self;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    UIView *rightLine=[UIView getCustomViewWithColor:_define_black_color];
    [self.contentView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(15);
    }];
    
    
    _store_name=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_store_name];
    [_store_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(rightLine.mas_right).with.offset(12);
        make.centerY.mas_equalTo(rightLine);
        make.right.mas_equalTo(-48);
    }];
    [_store_name sizeToFit];
    
    
    
    _address=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_address];
    _address.numberOfLines=2;
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_store_name);
        make.right.mas_equalTo(_store_name);
        make.top.mas_equalTo(_store_name.mas_bottom).with.offset(16);
    }];
    [_address sizeToFit];
    
    UIView *middleLine=[UIView getCustomViewWithColor:_define_black_color];
    [self.contentView addSubview:middleLine];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(33);
        make.right.mas_equalTo(-33);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(_address.mas_bottom).with.offset(16);
    }];
    
    _img_back_view=[UIView getCustomViewWithColor:nil];
    [self.contentView addSubview:_img_back_view];
    [_img_back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(middleLine.mas_bottom).with.offset(0);
        make.left.mas_equalTo(33);
        make.right.mas_equalTo(-33);
        make.height.mas_equalTo(0);
    }];
    
    
    _mapView=[[MKMapView alloc] init];
    [self.contentView addSubview:_mapView];
    [_mapView setShowsUserLocation:YES];
    _mapView.delegate = self;
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_img_back_view.mas_bottom).with.offset(24);
        make.left.mas_equalTo(33);
        make.height.mas_equalTo(IsPhone6_gt?200:180);
        make.right.mas_equalTo(-33);
    }];
    
}
#pragma mark - Setter
-(void)setShowRoomModel:(DD_ShowRoomModel *)showRoomModel
{
    _showRoomModel=showRoomModel;

    [self SetData];
    [self setMap];
}
-(void)setCalShowRoomModel:(DD_ShowRoomModel *)showRoomModel
{
    _showRoomModel=showRoomModel;
    
    [self SetData];
}
-(void)SetData
{
    _store_name.text=_showRoomModel.storeName;
    _address.text=_showRoomModel.address;
    
    for (UIView *view in _img_back_view.subviews) {
        [view removeFromSuperview];
    }
    
    UIView *lastView=nil;
    CGFloat _y_p=20;
    for (int i=0; i<_showRoomModel.pics.count; i++) {
        DD_ImageModel *imgModel=[_showRoomModel.pics objectAtIndex:i];
        UIImageView *img=[UIImageView getCustomImg];
        [_img_back_view addSubview:img];
        img.contentMode=2;
        [regular setZeroBorder:img];
        CGFloat _height=(ScreenWidth-33*2)*([imgModel.height floatValue]/[imgModel.width floatValue]);
        [img JX_ScaleAspectFill_loadImageUrlStr:imgModel.pic WithSize:800 placeHolderImageName:nil radius:0];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            if(lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(20);
            }else
            {
                make.top.mas_equalTo(20);
            }
            make.height.mas_equalTo(_height);
        }];
        lastView=img;
        _y_p+=20+_height;
    }
    if(lastView)
    {
        
        [_img_back_view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_y_p);
        }];
    }else
    {
        [_img_back_view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}
-(void)setMap
{
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:[_showRoomModel.latitude doubleValue] longitude:[_showRoomModel.longitude doubleValue]];
    CLLocationCoordinate2D coord = [loc coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 10000, 10000);
    [_mapView setRegion:region animated:YES];
    MyPoint *myPoint = [[MyPoint alloc] initWithCoordinate:coord andTitle:_showRoomModel.address];
    //添加标注
    [_mapView addAnnotation:myPoint];
}

#pragma mark - SomeAction
+ (CGFloat)heightWithModel:(DD_ShowRoomModel *)model{
    DD_ShowRoomCell *cell = [[DD_ShowRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"" WithBlock:nil];
    [cell setCalShowRoomModel:model];
    [cell.contentView layoutIfNeeded];
    CGRect frame =  cell.mapView.frame;
    CGFloat _height=frame.origin.y + frame.size.height+20;
    return _height;
}
#pragma mark-大头针
-(MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *newAnnotation=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
    newAnnotation.image = [UIImage imageNamed:@"System_Map_pin"];
    newAnnotation.canShowCallout=YES;
    return newAnnotation;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
