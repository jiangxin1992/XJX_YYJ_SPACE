//
//  DD_ShowRoomDetailViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/9/12.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShowRoomDetailViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "MyPoint.h"

#import "DD_ShowRoomModel.h"
#import "DD_ImageModel.h"

@interface DD_ShowRoomDetailViewController ()<MKMapViewDelegate>

@end

@implementation DD_ShowRoomDetailViewController
{
    DD_ShowRoomModel *_showRoomModel;
    UIScrollView *_scrollView;
    UIView *container;
    MKMapView *_mapView;
    UIView *mengban;
    UIButton *contactPhoneBtn;
    
    UIImageView *lastView;
    UIImageView *firstView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - 初始化
-(instancetype)initWithShowRoomID:(NSString *)showRoom_ID
{
    self=[super init];
    if(self)
    {
        _showRoom_ID=showRoom_ID;
        [self SomePrepare];
        [self UIConfig];
        [self RequestData];
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
-(void)PrepareUI{}
-(void)setTitle:(NSString *)title
{
    UIView *returnView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 40)];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(returnView.frame), CGRectGetHeight(returnView.frame))];
    titleLabel.font =  [regular getSemiboldFont:IsPhone6_gt?18.0f:15.0f];
    titleLabel.textAlignment=1;
    titleLabel.text=title;
    [returnView addSubview:titleLabel];
    self.navigationItem.titleView=returnView;
}
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"physicalStore/queryPhysicalStoreDetail.do" parameters:@{@"token":[DD_UserModel getToken],@"storeId":_showRoom_ID} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _showRoomModel=[DD_ShowRoomModel getShowRoomModel:[data objectForKey:@"storeInfo"]];
            [self CreateContent];
            [self CreateTabbar];
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
    [self CreateScrollView];
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
-(void)CreateContent
{
    UIImageView *_head=[UIImageView getImgWithImageStr:@"User_ShowRoom"];
    [container addSubview:_head];
    [_head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.top.mas_equalTo(25);
        make.width.height.mas_equalTo(23);
    }];
    
    UILabel *_address=[UILabel getLabelWithAlignment:0 WithTitle:_showRoomModel.address WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [container addSubview:_address];
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_head.mas_right).with.offset(10);
        make.bottom.mas_equalTo(_head);
    }];
//    [_address sizeToFit];
    
    UILabel *businessHoursLabel=[UILabel getLabelWithAlignment:0 WithTitle:[[NSString alloc] initWithFormat:@"商店营业时间：%@",_showRoomModel.businessHours] WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [container addSubview:businessHoursLabel];
    businessHoursLabel.lineBreakMode=NSLineBreakByCharWrapping;
    businessHoursLabel.numberOfLines=0;
    [businessHoursLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(_head.mas_bottom).with.offset(6);
    }];
    
    contactPhoneBtn=[UIButton getCustomTitleBtnWithAlignment:1 WithFont:13.0f WithSpacing:0 WithNormalTitle:[[NSString alloc] initWithFormat:@"联系方式：%@",_showRoomModel.contactPhone] WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
    [container addSubview:contactPhoneBtn];
    [contactPhoneBtn addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
    [contactPhoneBtn setEnlargeEdgeWithTop:15 right:0 bottom:15 left:0];
    CGFloat _height=floor([regular getHeightWithContent:[[NSString alloc] initWithFormat:@"联系方式：+86 %@",_showRoomModel.contactPhone] WithWidth:ScreenWidth-2*kEdge WithFont:13.0f]);
    [contactPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(businessHoursLabel.mas_bottom).with.offset(6);
        make.height.mas_equalTo(_height);
    }];
    
    _mapView=[[MKMapView alloc] init];
    [container addSubview:_mapView];
    [_mapView setShowsUserLocation:YES];
    _mapView.delegate = self;
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contactPhoneBtn.mas_bottom).with.offset(18);
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(202);
    }];
    
    UIButton *locationBtn=[UIButton getCustomImgBtnWithImageStr:@"System_Location" WithSelectedImageStr:nil];
    [_mapView addSubview:locationBtn];
    [locationBtn setEnlargeEdge:20];
    [locationBtn addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-18);
        make.height.width.mas_equalTo(25);
    }];
    
    [self locationAction];
    
    firstView=nil;
    lastView=nil;
    [_showRoomModel.pics enumerateObjectsUsingBlock:^(DD_ImageModel *imgModel, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *img=[UIImageView getCustomImg];
        [container addSubview:img];
        [img JX_ScaleAspectFill_loadImageUrlStr:imgModel.pic WithSize:800 placeHolderImageName:nil radius:0];
        CGFloat _height=floor(([imgModel.height floatValue]/[imgModel.width floatValue])*(ScreenWidth-2*kEdge));
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            if(!lastView)
            {
                make.top.mas_equalTo(_mapView.mas_bottom).with.offset(15);
            }else
            {
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(15);
            }
            make.left.mas_equalTo(kEdge);
            make.right.mas_equalTo(-kEdge);
            make.height.mas_equalTo(_height);
            
        }];
        if(idx==0)
        {
            firstView=img;
        }
        lastView=img;
    }];
//    for (int i=0; i<_showRoomModel.pics.count; i++) {
//        DD_ImageModel *imgModel=_showRoomModel.pics[i];
//        UIImageView *img=[UIImageView getCustomImg];
//        [container addSubview:img];
//        [img JX_ScaleAspectFill_loadImageUrlStr:imgModel.pic WithSize:800 placeHolderImageName:nil radius:0];
//        CGFloat _height=floor(([imgModel.height floatValue]/[imgModel.width floatValue])*(ScreenWidth-2*kEdge));
//        [img mas_makeConstraints:^(MASConstraintMaker *make) {
//            if(!lastView)
//            {
//                make.top.mas_equalTo(_mapView.mas_bottom).with.offset(15);
//            }else
//            {
//                make.top.mas_equalTo(lastView.mas_bottom).with.offset(15);
//            }
//            make.left.mas_equalTo(kEdge);
//            make.right.mas_equalTo(-kEdge);
//            make.height.mas_equalTo(_height);
//
//        }];
//        if(i==0)
//        {
//            firstView=img;
//        }
//        lastView=img;
//    }
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        // 让scrollview的contentSize随着内容的增多而变化
        make.bottom.mas_equalTo(lastView.mas_bottom).with.offset(60);
    }];
}
-(void)CreateTabbar
{
    UIView *tabbar=[UIView getCustomViewWithColor:_define_black_color];
    [self.view addSubview:tabbar];
    [tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(ktabbarHeight);
    }];
    
    CGFloat _width=(ScreenWidth-2)/2.0f;
    
    UIButton *_navigationBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"导 航" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [tabbar addSubview:_navigationBtn];
    _navigationBtn.backgroundColor=_define_black_color;
    [_navigationBtn addTarget:self action:@selector(navigationAction) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(_width);
    }];
    
    UIButton *_zoomBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"放 大" WithNormalColor:_define_white_color WithSelectedTitle:@"缩 小" WithSelectedColor:_define_white_color];
    [tabbar addSubview:_zoomBtn];
    _zoomBtn.backgroundColor=_define_black_color;
    [_zoomBtn addTarget:self action:@selector(zoomAction:) forControlEvents:UIControlEventTouchUpInside];
    [_zoomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(_width);
    }];
    
    UIView *middleLine=[UIView getCustomViewWithColor:_define_white_color];
    [tabbar addSubview:middleLine];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_navigationBtn.mas_right);
        make.centerY.mas_equalTo(tabbar);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(30);
    }];
}
#pragma mark - SomeAction
-(void)phoneAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"") style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *PhoneAction = [UIAlertAction actionWithTitle:[[NSString alloc] initWithFormat:@"+86 %@",_showRoomModel.contactPhone] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"tel://%@",_showRoomModel.contactPhone]]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:PhoneAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)zoomAction:(UIButton *)btn
{
    [self locationAction];
    if(btn.selected)
    {
        btn.selected=NO;
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [container addSubview:_mapView];
        [_mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contactPhoneBtn.mas_bottom).with.offset(18);
            make.left.mas_equalTo(kEdge);
            make.height.mas_equalTo(202);
            make.right.mas_equalTo(-kEdge);
        }];
        
        if(firstView)
        {
            [firstView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_mapView.mas_bottom).with.offset(15);
            }];
        }
        
        [_scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
            // 让scrollview的contentSize随着内容的增多而变化
            make.bottom.mas_equalTo(lastView.mas_bottom).with.offset(60);
        }];
        [mengban removeFromSuperview];
        
    }else
    {
        btn.selected=YES;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        if(firstView)
        {
            [firstView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(contactPhoneBtn.mas_bottom).with.offset(18);
            }];
        }
        if(!mengban)
        {
            mengban=[UIView getCustomViewWithColor:_define_white_color];
            
        }
        [self.view addSubview:mengban];
        [mengban mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-ktabbarHeight);
        }];
        [mengban addSubview:_mapView];
        [_mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(mengban);
        }];
        
    }
    
}
-(void)navigationAction
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"system_loc", @"") WithBlock:^{
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }] animated:YES completion:nil];
        
    }else
    {
        BOOL gaoDeMapCanOpen=[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]];
        BOOL baiduMapCanOpen=[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"") style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *iPhoneAction = [UIAlertAction actionWithTitle:@"用iPhone自带地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openAppleMap];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:iPhoneAction];
        if(baiduMapCanOpen)
        {
            UIAlertAction *baiduAction = [UIAlertAction actionWithTitle:@"用百度地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self openBaiDuMap];
            }];
            [alertController addAction:baiduAction];
        }
        if(gaoDeMapCanOpen)
        {
            UIAlertAction *gaoDeAction = [UIAlertAction actionWithTitle:@"用高德地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self openGaoDeMap];
            }];
            [alertController addAction:gaoDeAction];
        }
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
-(void)locationAction
{
//    double qdw=[_showRoomModel.latitude doubleValue];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:[_showRoomModel.latitude doubleValue] longitude:[_showRoomModel.longitude doubleValue]];
    CLLocationCoordinate2D coord = [loc coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 10000, 10000);
    [_mapView setRegion:region animated:YES];
    MyPoint *myPoint = [[MyPoint alloc] initWithCoordinate:coord andTitle:_showRoomModel.address];
    //添加标注
    [_mapView addAnnotation:myPoint];
}
//BOOL gaoDeMapCanOpen=[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]];
//        BOOL baiduMapCanOpen=[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]];
//打开高德地图导航

- (void)openGaoDeMap{
    
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%@&lon=%@&dev=1&style=2",@"YCO SPACE", @"YCO", _showRoomModel.storeName, _showRoomModel.latitude, _showRoomModel.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    
}

//打开百度地图导航

- (void)openBaiDuMap{
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    NSString *url=[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%@,%@|name:我的位置&destination=latlng:%f,%f|name:%@&mode=driving",_showRoomModel.latitude,_showRoomModel.longitude,currentLocation.placemark.location.coordinate.latitude,currentLocation.placemark.location.coordinate.longitude,_showRoomModel.baiduMapName];
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    
}
//打开苹果自带地图导航

- (void)openAppleMap{
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    
    //目的地的位置
    
    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake([_showRoomModel.latitude doubleValue], [_showRoomModel.longitude doubleValue]);
    
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]];
    
    toLocation.name =_showRoomModel.address;
    
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
    
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    
    //打开苹果自身地图应用，并呈现特定的item
    
    [MKMapItem openMapsWithItems:items launchOptions:options];
    
}
-(MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *newAnnotation=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
    newAnnotation.image = [UIImage imageNamed:@"System_Map_Pin"];
    newAnnotation.canShowCallout=YES;
    return newAnnotation;
}
#pragma mark - Other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
