//
//  DD_CalendarTool.m
//  YCO SPACE
//
//  Created by yyj on 16/8/25.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CalendarTool.h"

#define cellWH floor((ScreenWidth-40)/7)

@implementation DD_CalendarTool
-(NSArray *)getPointArrWithType:(NSInteger )type WithColorOne:(NSString *)colorCode1 WithColorTwo:(NSString *)colorCode2
{

    CGFloat _jiange = cellWH*0.1;
    if(type==1)
    {
        return @[];
    }else if(type==2)
    {
        return @[@{
                     @"colorCode":colorCode1
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                        ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                       ,@"x_p":@"0"}
                                    
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":@"0"}
                                    
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                                         ]
                     }
                 ];
    }else if(type==3)
    {
        return @[@{
                     @"colorCode":colorCode1
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                      ,@"x_p":@"0"}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ]
                     }
                 ,@{
                     @"colorCode":colorCode1
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                      ,@"x_p":@"0"}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ]
                     }
                 ];
    }else if(type==4)
    {
        return @[@{
                     @"colorCode":colorCode1
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                      ,@"x_p":@"0"}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":@"0"}
                                    ]
                     }
                 ];
    }else if(type==5)
    {
        return @[@{
                     @"colorCode":colorCode1
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                      ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                       ,@"x_p":@"0"}
                                    
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":@"0"}
                                    
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ]
                     }
                 ,@{
                     @"colorCode":colorCode2
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                      ,@"x_p":@"0"}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                       ,@"x_p":@"0"}
                                    
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ]
                     }
                 ];
    }else if(type==6)
    {
        return @[@{
                     @"colorCode":colorCode1
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                      ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                       ,@"x_p":@"0"}
                                    
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":@"0"}
                                    
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ]
                     }
                 ,@{
                     @"colorCode":colorCode2
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                       ,@"x_p":@"0"}
                                    
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ]
                     }
                 ];
    }else if(type==7)
    {
        return @[@{
                     @"colorCode":colorCode1
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                      ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                       ,@"x_p":@"0"}
                                    
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":@"0"}
                                    
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ]
                     }
                 ,@{
                     @"colorCode":colorCode2
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                      ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                       ,@"x_p":@"0"}
                                    ]
                     }
                 ];
    }else if(type==8)
    {
        return @[@{
                     @"colorCode":colorCode1
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                      ,@"x_p":@"0"}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ]
                     }
                 ,@{
                     @"colorCode":colorCode1
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                      ,@"x_p":@"0"}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ]
                     }
                 ,@{
                     @"colorCode":colorCode2
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                      ,@"x_p":@"0"}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                       ,@"x_p":@"0"}
                                    
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ]
                     }
                 
                 ];
    }else if(type==9)
    {
        return @[@{
                     @"colorCode":colorCode1
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                      ,@"x_p":@"0"}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ]
                     }
                 ,@{
                     @"colorCode":colorCode1
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                      ,@"x_p":@"0"}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ]
                     }
                 ,@{
                     @"colorCode":colorCode2
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                      ,@"x_p":@"0"}
                                    
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ]
                     }
                 ];
    }else if(type==10)
    {
        return @[@{
                     @"colorCode":colorCode1
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                      ,@"x_p":@"0"}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ]
                     }
                 ,@{
                     @"colorCode":colorCode1
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                      ,@"x_p":@"0"}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ]
                     }
                 ,@{
                     @"colorCode":colorCode2
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                      ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                       ,@"x_p":@"0"}
                                    ]
                     }
                 ];
    }else if(type==11)
    {
        return @[@{
                     @"colorCode":colorCode1
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                      ,@"x_p":@"0"}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":@"0"}
                                    ]
                     }
                 ,@{
                     @"colorCode":colorCode2
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                      ,@"x_p":@"0"}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                       ,@"x_p":@"0"}
                                    
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ]
                     }
                 
                 ];
    }else if(type==12)
    {
        return @[@{
                     @"colorCode":colorCode1
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                      ,@"x_p":@"0"}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":@"0"}
                                    ]
                     }
                 ,@{
                     @"colorCode":colorCode2
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                      ,@"x_p":@"0"}
                                    
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ]
                     }
                 
                 ];
    }else if(type==13)
    {
        return @[@{
                     @"colorCode":colorCode1
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                      ,@"x_p":@"0"}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",_jiange+3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                       ,@"x_p":@"0"}
                                    ]
                     }
                 ,@{
                     @"colorCode":colorCode2
                     ,@"pointarr":@[@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange-3]
                                      ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                       ,@"x_p":[[NSString alloc] initWithFormat:@"%lf",cellWH]}
                                    ,@{@"y_p":[[NSString alloc] initWithFormat:@"%lf",cellWH-_jiange]
                                       ,@"x_p":@"0"}
                                    ]
                     }
                 
                 ];
    }
    return @[];
}
@end
