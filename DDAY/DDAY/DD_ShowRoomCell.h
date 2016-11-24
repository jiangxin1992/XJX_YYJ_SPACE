//
//  DD_ShowRoomCell.h
//  YCO SPACE
//
//  Created by yyj on 16/8/19.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_BaseCell.h"

@class DD_ShowRoomModel;

@interface DD_ShowRoomCell : DD_BaseCell<MKMapViewDelegate>

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type))block;

+ (CGFloat)heightWithModel:(DD_ShowRoomModel *)model;

-(void)setCalShowRoomModel:(DD_ShowRoomModel *)showRoomModel;

@property (nonatomic,strong) DD_ShowRoomModel *showRoomModel;

__block_type(block, type);

@property (nonatomic,strong)MKMapView *mapView;

@end
