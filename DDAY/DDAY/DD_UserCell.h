//
//  DD_UserCell.h
//  DDAY
//
//  Created by yyj on 16/5/21.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_UserCell : UITableViewCell

-(id)initWithImageStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(id)initWithF_titleStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(id)initWithTitleStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(id)initWithNotF_titleStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

__bool(hasNewFans);

__string(image);

__string(f_title);

__string(title);

@end
