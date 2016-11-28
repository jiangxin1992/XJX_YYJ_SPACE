//
//  DD_ShareTool.m
//  YCO SPACE
//
//  Created by yyj on 16/8/23.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_ShareTool.h"

#import "DD_GoodsDetailModel.h"
#import "DD_ImageModel.h"
#import "DD_DDayDetailModel.h"
#import "DD_CircleListModel.h"
#import "DD_GoodsItemModel.h"
#import "DD_GoodsDesignerModel.h"
#import "DD_ColorsModel.h"

@implementation DD_ShareTool
+(NSDictionary *)getShareParamsWithType:(NSString *)type WithShareParams:(NSDictionary *)params
{
    if([type isEqualToString:@"goods_detail"])
    {
        
        DD_GoodsDetailModel *_DetailModel=[params objectForKey:@"detailModel"];
        return @{@"type":@"goodsDetail",@"itemId":_DetailModel.item.itemId,@"colorId":_DetailModel.item.colorId};
        
    }else if([type isEqualToString:@"dday_detail"])
    {
        
        DD_DDayDetailModel *_DetailModel=[params objectForKey:@"detailModel"];
        return @{@"type":@"ddayDetail",@"ddayId":_DetailModel.s_id};
        
    }else if([type isEqualToString:@"circle_detail"])
    {
        
        DD_CircleListModel *_DetailModel=[params objectForKey:@"detailModel"];
        return @{@"type":@"circleDetail",@"shareId":_DetailModel.shareId};
        
    }
    return @{};
}
+(NSMutableDictionary *)getShareParamsWithType:(NSString *)type WithShare_type:(SSDKPlatformType )platformType WithShareParams:(NSDictionary *)params
{
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if([type isEqualToString:@"goods_detail"])
    {
        DD_GoodsDetailModel *_DetailModel=[params objectForKey:@"detailModel"];
        NSString *url=[[NSString alloc] initWithFormat:@"%@%@",[regular getDNS],[[_DetailModel getAppUrl] stringByReplacingOccurrencesOfString:@"#" withString:@""]];
        
        DD_ColorsModel *colorModel=[_DetailModel getColorsModel];
        
        NSString *pic=nil;
        if(colorModel.pics.count)
        {
            DD_ImageModel *img=colorModel.pics[0];
            pic=[[NSString alloc] initWithFormat:@"%@-z400.jpg",img.pic];
        }
        
        if(platformType==SSDKPlatformSubTypeWechatSession)
        {
            //        微信
            // 定制微信好友的分享内容
            [shareParams SSDKSetupWeChatParamsByText:_DetailModel.designer.brandName title:_DetailModel.item.itemName url:[NSURL URLWithString:url] thumbImage:nil image:pic musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:platformType];// 微信好友子平台
        }else if(platformType==SSDKPlatformSubTypeWechatTimeline)
        {
            //        朋友圈
            // 定制微信好友的分享内容
            [shareParams SSDKSetupWeChatParamsByText:nil title:[[NSString alloc] initWithFormat:@"%@\n%@",_DetailModel.item.itemName,_DetailModel.designer.brandName] url:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",[regular getDNS],[[_DetailModel getAppUrl] stringByReplacingOccurrencesOfString:@"#" withString:@""]]] thumbImage:nil image:pic musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:platformType];// 微信好友子平台
        }else if(platformType==SSDKPlatformTypeSinaWeibo)
        {
            //        微博
            [shareParams SSDKSetupSinaWeiboShareParamsByText:[[NSString alloc] initWithFormat:@" / %@ @YCOSPACE，让设计步入日常。%@",_DetailModel.item.itemName,url] title:nil image:pic url:[NSURL URLWithString:url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
            
        }else if(platformType==SSDKPlatformSubTypeQQFriend)
        {
            //        QQ
            [shareParams SSDKSetupQQParamsByText:_DetailModel.designer.brandName title:_DetailModel.item.itemName url:[NSURL URLWithString:url] thumbImage:nil image:pic type:SSDKContentTypeAuto forPlatformSubType:platformType];
        }else if(platformType==SSDKPlatformTypeCopy)
        {
            //        复制
            [shareParams SSDKSetupCopyParamsByText:[[NSString alloc] initWithFormat:@"%@ @YCOSPACE,让设计步入日常。点击%@ 下载！",_DetailModel.item.itemName,_DetailModel.downLoadUrl] images:pic url:[NSURL URLWithString:url] type:SSDKContentTypeText];
        }
    }else if([type isEqualToString:@"dday_detail"])
    {
        DD_DDayDetailModel *_DetailModel=[params objectForKey:@"detailModel"];
        NSString *url=[[NSString alloc] initWithFormat:@"%@%@",[regular getDNS],[_DetailModel.appUrl stringByReplacingOccurrencesOfString:@"#" withString:@""]];
        NSString *pic=nil;
        if(_DetailModel.seriesFrontPic.pic)
        {
            pic=[[NSString alloc] initWithFormat:@"%@-z400.jpg",_DetailModel.seriesFrontPic.pic];
        }

        if(platformType==SSDKPlatformSubTypeWechatSession)
        {
            //        微信
            // 定制微信好友的分享内容
            [shareParams SSDKSetupWeChatParamsByText:[[NSString alloc] initWithFormat:@"%@ | %@",_DetailModel.designerName,_DetailModel.brandName] title:_DetailModel.name url:[NSURL URLWithString:url] thumbImage:nil image:pic musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:platformType];// 微信好友子平台
        }else if(platformType==SSDKPlatformSubTypeWechatTimeline)
        {
            //        朋友圈
            // 定制微信好友的分享内容
            [shareParams SSDKSetupWeChatParamsByText:nil title:[[NSString alloc] initWithFormat:@"%@\n%@ | %@",_DetailModel.name,_DetailModel.designerName,_DetailModel.brandName] url:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",[regular getDNS],[_DetailModel.appUrl stringByReplacingOccurrencesOfString:@"#" withString:@""]]] thumbImage:nil image:pic musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:platformType];// 微信好友子平台
        }else if(platformType==SSDKPlatformTypeSinaWeibo)
        {
            //        微博
            long nowTime=[NSDate nowTime];
            if(nowTime<_DetailModel.saleStartTime)
            {
                //        发布会开始之前;报名开始之前;报名结束之前
                [shareParams SSDKSetupSinaWeiboShareParamsByText:[[NSString alloc] initWithFormat:@" / %@ 即将发布，马上到YCO SPACE app中报名发布会,参与限时优惠,名额有限哦! @YCOSPACE,让设计步入日常。%@",_DetailModel.name,url] title:nil image:pic url:[NSURL URLWithString:url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
            }else if(nowTime<_DetailModel.saleEndTime)
            {
                //         发布中
                [shareParams SSDKSetupSinaWeiboShareParamsByText:[[NSString alloc] initWithFormat:@" / %@ 发布会正在进行中，报名发布会的用户可享限时优惠! 到YCO SPACE app中查看更多。@YCOSPACE,让设计步入日常。%@",_DetailModel.name,url] title:nil image:pic url:[NSURL URLWithString:url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
            }else if(nowTime>=_DetailModel.saleEndTime)
            {
                //        发布会结束
                [shareParams SSDKSetupSinaWeiboShareParamsByText:[[NSString alloc] initWithFormat:@" / %@，马上到 YCO SPACE app中查看! @YCOSPACE,让设计步入日常。%@",_DetailModel.name,url] title:nil image:pic url:[NSURL URLWithString:url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
            }
        }else if(platformType==SSDKPlatformSubTypeQQFriend)
        {
            //        QQ
            [shareParams SSDKSetupQQParamsByText:[[NSString alloc] initWithFormat:@"%@ | %@",_DetailModel.designerName,_DetailModel.brandName] title:_DetailModel.name url:[NSURL URLWithString:url] thumbImage:nil image:pic type:SSDKContentTypeAuto forPlatformSubType:platformType];
        }else if(platformType==SSDKPlatformTypeCopy)
        {
            //        复制
            [shareParams SSDKSetupCopyParamsByText:[[NSString alloc] initWithFormat:@"%@ @YCOSPACE,让设计步入日常。点击%@ 下载！",_DetailModel.name,_DetailModel.downLoadUrl] images:pic url:[NSURL URLWithString:url] type:SSDKContentTypeText];
        }
    }else if([type isEqualToString:@"circle_detail"])
    {
        DD_CircleListModel *_DetailModel=[params objectForKey:@"detailModel"];
        NSString *url=[[NSString alloc] initWithFormat:@"%@%@",[regular getDNS],[_DetailModel.appUrl stringByReplacingOccurrencesOfString:@"#" withString:@""]];
        NSString *pic=nil;
        if(_DetailModel.pics.count)
        {
            DD_ImageModel *img=_DetailModel.pics[0];
            pic=[[NSString alloc] initWithFormat:@"%@-z400.jpg",img.pic];
        }
        if(platformType==SSDKPlatformSubTypeWechatSession)
        {
            //        微信
            // 定制微信好友的分享内容
            [shareParams SSDKSetupWeChatParamsByText:[[NSString alloc] initWithFormat:@"from %@",_DetailModel.userName] title:_DetailModel.shareAdvise url:[NSURL URLWithString:url] thumbImage:nil image:pic musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:platformType];// 微信好友子平台
        }else if(platformType==SSDKPlatformSubTypeWechatTimeline)
        {
            //        朋友圈
            // 定制微信好友的分享内容
            [shareParams SSDKSetupWeChatParamsByText:nil title:[[NSString alloc] initWithFormat:@"%@\nfrom %@ @YCO SPACE",_DetailModel.shareAdvise,_DetailModel.userName] url:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",[regular getDNS],[_DetailModel.appUrl stringByReplacingOccurrencesOfString:@"#" withString:@""]]] thumbImage:nil image:pic musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:platformType];// 微信好友子平台
        }else if(platformType==SSDKPlatformTypeSinaWeibo)
        {
            //        微博
            [shareParams SSDKSetupSinaWeiboShareParamsByText:[[NSString alloc] initWithFormat:@" / %@：%@ @YCOSPACE，让设计步入日常。%@",_DetailModel.userName,_DetailModel.shareAdvise,url] title:nil image:pic url:[NSURL URLWithString:url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
            
        }else if(platformType==SSDKPlatformSubTypeQQFriend)
        {
            //        QQ
            [shareParams SSDKSetupQQParamsByText:[[NSString alloc] initWithFormat:@"from %@",_DetailModel.userName] title:_DetailModel.shareAdvise url:[NSURL URLWithString:url] thumbImage:nil image:pic type:SSDKContentTypeAuto forPlatformSubType:platformType];
        }else if(platformType==SSDKPlatformTypeCopy)
        {
            //        复制
            [shareParams SSDKSetupCopyParamsByText:[[NSString alloc] initWithFormat:@"%@的共享带 @YCOSPACE，让设计步入日常。点击%@ 下载！",_DetailModel.userName,_DetailModel.downLoadUrl] images:pic url:[NSURL URLWithString:url] type:SSDKContentTypeText];
        }
    }
    return shareParams;
}
+(NSDictionary *)getShareListMap
{
    return @{
             @"wechat":@"Share_Weixin"
             ,@"wechat_friend":@"Share_Friendcircle"
             ,@"sina":@"Share_Weibo"
             ,@"qq":@"Share_QQ"
             ,@"copy":@"Share_Copylink"
             };
}
+(NSArray *)getShareListArr
{
    BOOL _isInstallQQ=[self isInstallQQ];
    BOOL _isInstallWeChat=[self isInstallWeChat];
    JXLOG(@"%d %d",_isInstallQQ,_isInstallWeChat);
    if(_isInstallQQ&&_isInstallWeChat)
    {
        return @[@"wechat",@"wechat_friend",@"sina",@"qq",@"copy"];
    }else
    {
        if(_isInstallQQ)
        {
            return @[@"sina",@"qq",@"copy"];
        }else if(_isInstallWeChat)
        {
            return @[@"wechat",@"wechat_friend",@"sina",@"copy"];
        }else
        {
            return @[@"sina",@"copy"];
        }
    }
}

+(CGFloat)getHeight
{
    NSArray *arr=[self getShareListArr];
    if(arr.count>4)
    {
        return 250;
    }else
    {
        return 180;
    }
}
/**
 * 当前设备是否安装QQ
 */
+(BOOL)isInstallQQ
{
    return [ShareSDK isClientInstalled:SSDKPlatformSubTypeQQFriend];
}
/**
 * 当前设备是否安装微信
 */
+(BOOL)isInstallWeChat
{
    return [ShareSDK isClientInstalled:SSDKPlatformSubTypeWechatSession];
}

@end
