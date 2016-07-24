//
//  DD_DesignerCell.m
//  DDAY
//
//  Created by yyj on 16/5/22.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_DesignerCell.h"

@implementation DD_DesignerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)followAction:(id)sender {
    if(_followBtn.selected)
    {
        _followblock(_index,@"unfollow");
    }else
    {
        _followblock(_index,@"follow");
    }
}
-(void)setDesigner:(DD_DesignerModel *)Designer
{
    _name_label.text=[[NSString alloc] initWithFormat:@"%@·%@",Designer.name,Designer.brandName];
    _followBtn.selected=Designer.guanzhu;
    [_headImge JX_loadImageUrlStr:Designer.head WithSize:200 placeHolderImageName:nil radius:CGRectGetWidth(_headImge.frame)/2.0f];
    if(Designer.items.count)
    {
        NSString *imgstr=[Designer.items objectAtIndex:0];
        [_item_image JX_loadImageUrlStr:imgstr WithSize:800 placeHolderImageName:nil radius:0];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
