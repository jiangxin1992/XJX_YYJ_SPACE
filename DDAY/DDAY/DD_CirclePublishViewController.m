//
//  DD_CirclePublishViewController.m
//  DDAY
//
//  Created by yyj on 16/6/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_CirclePublishViewController.h"

#import "QiniuSDK.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#import "DD_CircleCustomTagViewController.h"
#import "DD_CricleShowViewController.h"
#import "DD_CirclePushlishPreViewController.h"

#import "DD_CircleInfoView.h"
#import "DD_CircleChooseDetailView.h"
#import "DD_CircleChooseStyleView.h"
#import "DD_CircleFitPersonView.h"
#import "DD_CircleTagsView.h"
#import "DD_CircleInfoImgView.h"

#import "DD_CirclePublishTool.h"
#import "DD_CricleChooseItemModel.h"
#import "DD_CircleModel.h"

@interface DD_CirclePublishViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation DD_CirclePublishViewController
{
    
    UIScrollView *_scrollView;
    DD_CircleModel *_CircleModel;//发布视图model
    
    DD_CircleInfoView *_infoView;//交互视图
    
    UIView *container;//_scrollView的view
    
    UIButton *_preView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}
#pragma mark - 初始化
-(instancetype)initWithBlock:(void (^)(NSString *))block
{
    self=[super init];
    if(self)
    {
        _block=block;
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData
{
//    获取初始化 搭配model
    _CircleModel=[DD_CircleModel getCircleModel];
    [regular UpdateRoot];
}
-(void)PrepareUI
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"circle_publish_title", @"") withmaxwidth:200];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateScrollView];
    [self CreateContentView];
    [self CreateTabbar];
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
-(void)CreateTabbar
{
    _preView=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:18.0f WithSpacing:0 WithNormalTitle:@"预览" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self.view addSubview:_preView];
    _preView.backgroundColor=_define_black_color;
    [_preView addTarget:self action:@selector(SubmitAction) forControlEvents:UIControlEventTouchUpInside];

    [_preView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ktabbarHeight);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}
-(void)CreateContentView
{
//    创建搭配界面
    [self CreateInforView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.left.mas_equalTo(0);
//        make.bottom.mas_equalTo(ktabbarHeight);
        make.edges.mas_equalTo(self.view);
        // 让scrollview的contentSize随着内容的增多而变化
        make.bottom.mas_equalTo(_infoView.mas_bottom).with.offset(0);
    }];
}

-(void)CreateInforView
{
    _infoView=[[DD_CircleInfoView alloc] initWithCircleModel:_CircleModel WithBlock:^(NSString *type,long index) {
//        if([type isEqualToString:@"suggest_remarks"])
//        {
////            跳转搭配建议界面
//            [self PushRemarksView];
//        }else
        if([type isEqualToString:@"chooseStyle"])
        {
//            款式选择
            [self PushChooseDetailView];
        }else if([type isEqualToString:@"choose_pic"])
        {
//            选择搭配图
            [self ChooseImg];
        }else if([type isEqualToString:@"show_pic"])
        {
//            显示搭配图
            [self ShowImgWithIndex:index];
        }else if([type isEqualToString:@"delete_pic"])
        {
            [self DeleteImgWithIndex:index];
        }else if([type isEqualToString:@"person_tag_delete"])
        {
//            适合人群标签删除
            [DD_CirclePublishTool TagDelete:index WithType:2 WithCircleModel:_CircleModel];
            [_infoView.fitPersonView setState];
        }else if([type isEqualToString:@"person_tag_add"])
        {
//            适合人群标签添加
            [DD_CirclePublishTool TagAdd:index WithType:2 WithCircleModel:_CircleModel];
            [_infoView.fitPersonView setState];
        }else if([type isEqualToString:@"circle_tag_delete"])
        {
//            标签删除
            [DD_CirclePublishTool TagDelete:index WithType:1 WithCircleModel:_CircleModel];
            [_infoView.tagsView setState];
        }else if([type isEqualToString:@"circle_tag_add"])
        {
//            标签添加
            [DD_CirclePublishTool TagAdd:index WithType:1 WithCircleModel:_CircleModel];
            [_infoView.tagsView setState];
        }else if([type isEqualToString:@"add_custom_tag"])
        {
//            添加自定义标签
            [self CustomTag];
        }else if([type isEqualToString:@"choose_item"])
        {
//            款式选择视图更新
            [_infoView.chooseStyleView updateImageView];
        }else if([type isEqualToString:@"delete_choose_item"])
        {
//            删除已选款式
            [self deleteChooseItem:index];
        }else if([type isEqualToString:@"num_limit"])
        {
            [self presentViewController:[regular alertTitle_Simple:@"搭配建议不能超过200字"] animated:YES completion:nil];
        }
    }];
    [container addSubview:_infoView];
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(container.mas_left).with.offset(0);
        make.right.mas_equalTo(container.mas_right).with.offset(0);
        make.top.mas_equalTo(container.mas_top).with.offset(0);
    }];
}
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"share/queryTags.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
//            更新_detailModel
            [DD_CirclePublishTool SetWithDict:data WithCircleModel:_CircleModel];
//            更新标签和适合人群视图
            [_infoView.tagsView setState];
            [_infoView.fitPersonView setState];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - SomeAction
-(void)backAction
{
    [self presentViewController:[regular alertTitleCancel_Simple:@"放弃编辑？" WithBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }] animated:YES completion:nil];
}
/**
 * 跳转自定义标签界面
 */
-(void)CustomTag
{
    [self.navigationController pushViewController:[[DD_CircleCustomTagViewController alloc] initWithCircleModel:_CircleModel WithBlock:^(NSString *type, DD_CricleTagItemModel *tagModel) {
        //        添加新的标签
        if([type isEqualToString:@"add_new_tag"])
        {
            //            _detailModel中添加新的自定义tag
            [DD_CirclePublishTool addCustomModel:tagModel WithCircleModel:_CircleModel];
            //            tagsview更新
            [_infoView.tagsView setState];
        }
    }] animated:YES];
}
/**
 * 提交
 */
-(void)SubmitAction
{

    if([_CircleModel.remark isEqualToString:@""])
    {
        [self presentViewController:[regular alertTitle_Simple:@"请填写搭配建议"] animated:YES completion:nil];
    }else if(_CircleModel.chooseItem.count==0)
    {
        [self presentViewController:[regular alertTitle_Simple:@"请先选择款式"] animated:YES completion:nil];
    }else if(_CircleModel.picArr.count==0)
    {
        [self presentViewController:[regular alertTitle_Simple:@"请先上传搭配图"] animated:YES completion:nil];
    }else if([DD_CirclePublishTool getParameterTagsNumWithCircleModel:_CircleModel]==0)
    {
        [self presentViewController:[regular alertTitle_Simple:@"请先选择标签"] animated:YES completion:nil];
    }else
    {
        DD_CirclePushlishPreViewController *PreView=[[DD_CirclePushlishPreViewController alloc] initWithCircleModel:_CircleModel WithType:@"publish" WithBlock:^(NSString *type) {
            _block(type);
        }];
        [self.navigationController pushViewController:PreView animated:YES];

    }
    
}
/**
 * 跳转款式选择界面
 */
-(void)PushChooseDetailView
{
    [self.navigationController pushViewController:[[DD_CircleChooseDetailView alloc] initWithCircleModel:_CircleModel WithLimitNum:5 WithBlock:^(NSString *type,NSInteger index) {
        if([type isEqualToString:@"choose_item"])
        {
            //            款式选择视图更新
            [_infoView.chooseStyleView updateImageView];
        }else if([type isEqualToString:@"delete_choose_item"])
        {
            [_infoView.chooseStyleView updateImageView];
        }
        
    }] animated:YES];
}
/**
 * 删除已选款式
 */
-(void)deleteChooseItem:(NSInteger )index
{
    //            删除已选款式
    DD_CricleChooseItemModel *item=[_CircleModel.chooseItem objectAtIndex:index];
    //    删除item 对应的已选款式
    item.isSelect=NO;
    [DD_CirclePublishTool delChooseItemModel:item WithCircleModel:_CircleModel];
    [_infoView.chooseStyleView updateImageView];
}



/**
 * 选择搭配图
 */
-(void)ChooseImg
{
    if(_CircleModel.picArr.count<8)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"") style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *take_photosAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"take_photos", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                //打开相机
                [self loadImageWithType:UIImagePickerControllerSourceTypeCamera];
            }
            else
            {
                JXLOG(@"不能打开相机");
            }
        }];
        
        UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"open_album", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                [self loadImageWithType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
            else
            {
                JXLOG(@"无法打开相册");
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:take_photosAction];
        [alertController addAction:archiveAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else
    {
        [self presentViewController:[regular alertTitle_Simple:@"最多可上传8张搭配图"] animated:YES completion:nil];
    }
    
}
/**
 * 跳转搭配图放大视图
 */
-(void)ShowImgWithIndex:(long )index
{

    [self.navigationController pushViewController:[[DD_CricleShowViewController alloc] initWithCircleModel:_CircleModel WithIndex:index WithBlock:^(NSString *type) {
        if([type isEqualToString:@"delete"])
        {
            [_CircleModel.picArr removeObjectAtIndex:index];
            [_infoView.imgView setState];
        }
    }] animated:YES];
}
-(void)DeleteImgWithIndex:(long )index
{
    NSDictionary *_parameters=@{@"token":[DD_UserModel getToken],@"key":[[_CircleModel.picArr objectAtIndex:index] objectForKey:@"key"]};
    [[JX_AFNetworking alloc] GET:@"file/deleteQiNiuFile.do" parameters:_parameters success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            [_CircleModel.picArr removeObjectAtIndex:index];
            [_infoView.imgView setState];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
    
}
#pragma mark - 打开相册
/**
 * 创建Alertview
 */
-(void)ShowAlertview:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [regular pushSystem];
    }];
    [alertController addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
/**
 * 弹出相机/相册
 */
-(void)pushPickerWithType:(UIImagePickerControllerSourceType)type
{
    //创建图片选取器
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    //设置选取器类型
    picker.sourceType = type;
    //编辑
    picker.allowsEditing = NO;
    if ([picker.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
    //弹出
    [self presentViewController:picker animated:YES completion:nil];
}
/**
 * 打开相机/相册
 */
-(void)loadImageWithType:(UIImagePickerControllerSourceType)type
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
        
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"system_album", @"") WithBlock:^{
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }] animated:YES completion:nil];
    }else if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied)
    {
        [self presentViewController:[regular alertTitleCancel_Simple:NSLocalizedString(@"system_camera", @"") WithBlock:^{
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }] animated:YES completion:nil];
    }else
    {
        if(kIOSVersions_v9)
        {
            PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
            if (author == PHAuthorizationStatusDenied) {
                //无权限
                [self ShowAlertview:NSLocalizedString(@"system_album_no_root", @"")];
            }else{
                [self pushPickerWithType:type];
            }
            
        }else
        {
            //        相册
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
                //无权限
                [self ShowAlertview:NSLocalizedString(@"system_album_no_root", @"")];
            }else
            {
                [self pushPickerWithType:type];
            }
        }
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //    获取选择图片
    UIImage *originImage = info[UIImagePickerControllerOriginalImage];
    //    压缩比例0.5
    NSData *data1 = UIImageJPEGRepresentation(originImage, 0.8f);
    //    获取七牛上传文件所需的token
    [[JX_AFNetworking alloc] GET:@"user/getQiNiuToken.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            NSString *upLoadToken=[data objectForKey:@"upLoadToken"];
            
            //            上传qiniu
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            [upManager putData:data1 key:nil token:upLoadToken
                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          if(info.statusCode==200)
                          {
                              [_CircleModel.picArr addObject:@{
                                                               @"key":resp[@"key"]
                                                               ,@"data":originImage}];
                              [_infoView.imgView setState];
                          }else
                          {
                              [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(@"system_img_upload_fail", @"")] animated:YES completion:nil];
                          }
                           
                      } option:nil];
            
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}
#pragma mark - Others
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 * 跳转填写备注界面
 */
//-(void)PushRemarksView
//{
//    [self.navigationController pushViewController:[[DD_RemarksViewController alloc] initWithRemarks:_CircleModel.remark WithLimit:200 WithTitle:@"搭配建议" WithBlock:^(NSString *type, NSString *content) {
////        备注界面点击完成
//        if([type isEqualToString:@"done"])
//        {
//            if(_infoView)
//            {
////                remarksview中更新内容
//                [_infoView.remarksView setRemarksWithWebView:content];
////                _detailModel中更新备注内容
//                _CircleModel.remark=content;
//            }
//        }
//    }] animated:YES];
//}
@end
