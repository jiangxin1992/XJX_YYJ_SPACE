//
//  DD_OrderLogisticsCell.m
//  YCO SPACE
//
//  Created by yyj on 16/8/24.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_OrderLogisticsCell.h"

#import "TTTAttributedLabel.h"

#import "DD_OrderLogisticsModel.h"
#import "Tools.h"

#define PHONEREGULAR @"\\d{3,4}[- ]?\\d{7,8}"//匹配10到12位连续数字，或者带连字符/空格的固话号，空格和连字符可以省略。
@interface DD_OrderLogisticsCell ()<TTTAttributedLabelDelegate>

@end

@implementation DD_OrderLogisticsCell
{
    TTTAttributedLabel *contentlabel;
    UIView *circle;
    UILabel *timeLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - 初始化
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type,NSString *phoneNum))block
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _block=block;
        [self UIConfig];
    }
    return  self;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    contentlabel=[[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:contentlabel];
    contentlabel.textAlignment=0;
    contentlabel.numberOfLines=0;
    contentlabel.delegate=self;
    contentlabel.linkAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
    contentlabel.activeLinkAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
    contentlabel.inactiveLinkAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
    
    [contentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(54);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-38);
    }];
    
    circle=[UIView getCustomViewWithColor:_define_black_color];
    [self.contentView addSubview:circle];
    circle.layer.masksToBounds=YES;
    circle.layer.cornerRadius=4;
    [circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(contentlabel.mas_left).with.offset(-4);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(8);
    }];
    
    timeLabel=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12.0f WithTextColor:_define_light_gray_color1 WithSpacing:0];
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(54);
        make.top.mas_equalTo(contentlabel.mas_bottom).with.offset(10);
        make.right.mas_equalTo(-38);
    }];
    
    _downLine=[UIView getCustomViewWithColor:_define_black_color];
    [self.contentView addSubview:_downLine];
    [_downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(54);
        make.right.mas_equalTo(-kEdge);
        make.height.mas_equalTo(1);
    }];
}
#pragma mark - SomeAction
-(void)setLogisticsModel:(DD_OrderLogisticsModel *)logisticsModel IsFirst:(BOOL )isFirst IsLast:(BOOL )isLast
{
    
    _logisticsModel=logisticsModel;
    
    timeLabel.text=[regular getTimeStr:_logisticsModel.AcceptTime WithFormatter:@"YYYY-MM-dd HH:mm"];
    circle.hidden=!isFirst;
    _downLine.hidden=isLast;
    
    [contentlabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([regular getHeightWithWidth:ScreenWidth-54-38 WithContent:_logisticsModel.AcceptStation WithFont:[regular getFont:13.0f]]);
    }];
    
    //设置段落，文字样式
    NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
    paragraphstyle.lineSpacing = 0;
    NSDictionary *paragraphDic = @{NSFontAttributeName:[regular getFont:13.0f],NSParagraphStyleAttributeName:paragraphstyle};
    NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:_logisticsModel.AcceptStation  attributes:paragraphDic];
    
    [tempStr addAttribute:NSForegroundColorAttributeName value:_define_black_color range:NSMakeRange(0, _logisticsModel.AcceptStation.length)];
    
    contentlabel.text = tempStr;

    NSRange stringRange = NSMakeRange(0, _logisticsModel.AcceptStation.length);
    //正则匹配
    NSError *error;
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:PHONEREGULAR options:0 error:&error];
    if (!error && regexps != nil) {
        [regexps enumerateMatchesInString:_logisticsModel.AcceptStation options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            
            //添加链接
            NSString *actionString = [NSString stringWithFormat:@"%@",[_logisticsModel.AcceptStation substringWithRange:result.range]];
            
            if ([regular isMobilePhoneOrtelePhone:actionString] || [[actionString substringToIndex:3] isEqualToString:@"400"]) {
                [contentlabel addLinkToPhoneNumber:actionString withRange:result.range];
            }
        }];
    }
    
}

+ (CGFloat)heightWithModel:(DD_OrderLogisticsModel *)model
{
    DD_OrderLogisticsCell *cell = [[DD_OrderLogisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"" WithBlock:nil];
    [cell setLogisticsModel:model IsFirst:NO IsLast:NO];
    [cell.contentView layoutIfNeeded];
    CGRect frame =  cell.downLine.frame;
    return frame.origin.y + frame.size.height;
}
#pragma mark  ---------------TTTAttributedLabelDelegate--------------

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    //点击手机号
    _block(@"phone_click",phoneNumber);
}
//- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
//{
//    _block(@"phone_click",[url absoluteString]);
////    [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:self.view];
//    
//}


#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
