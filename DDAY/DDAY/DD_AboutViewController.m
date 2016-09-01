//
//  DD_AboutViewController.m
//  YCO SPACE
//
//  Created by yyj on 16/8/19.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "DD_AboutViewController.h"

#import "DrawView.h"

#import "DD_ImageModel.h"

@interface DD_AboutViewController ()

@end

@implementation DD_AboutViewController
{
    UIScrollView *_scrollView;
    UIView *container;
    NSDictionary *_data_dict;
    
    UIImageView *headIcon;
    UILabel *brief;
    UILabel *version;
    UIView *version_back;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData
{
    self.navigationItem.titleView=[regular returnNavView:NSLocalizedString(@"user_set_about", @"") withmaxwidth:200];//设置标题
}
-(void)PrepareUI{}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateScrollView];
    [self CreateUI];

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
-(void)CreateUI
{
    headIcon=[UIImageView getCustomImg];
    [container addSubview:headIcon];
    headIcon.contentMode=0;
    [headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(85);
        make.width.mas_equalTo(74);
        make.centerX.mas_equalTo(container);
        make.height.mas_equalTo(0);
    }];
    
    brief=[UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:12 WithTextColor:nil WithSpacing:0];
    [container addSubview:brief];
    brief.numberOfLines=0;
    [brief mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdge);
        make.right.mas_equalTo(-kEdge);
        make.top.mas_equalTo(headIcon.mas_bottom).with.offset(60);
    }];
    [brief sizeToFit];
    
    DrawView *draw=[[DrawView alloc] initWithStartP:CGPointMake(1, 43) WithEndP:CGPointMake(42, 1) WithLineWidth:3 WithColorType:1];
    [container addSubview:draw];
    [draw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(brief.mas_bottom).with.offset(35);
        make.centerX.mas_equalTo(container);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(43);
    }];
    
    version_back=[UIView getCustomViewWithColor:nil];
    [container addSubview:version_back];
    version_back.layer.masksToBounds=YES;
    version_back.layer.cornerRadius=75;
    version_back.layer.borderColor=[_define_black_color CGColor];
    version_back.layer.borderWidth=1;
    [version_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(draw.mas_bottom).with.offset(39);
        make.centerX.mas_equalTo(container);
        make.width.height.mas_equalTo(150);
    }];
    
    version=[UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [version_back addSubview:version];
    [version mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(version_back);
    }];
}
#pragma mark - RequestData
-(void)RequestData
{
    [[JX_AFNetworking alloc] GET:@"physicalStore/aboutYcoSpace.do" parameters:@{@"token":[DD_UserModel getToken]} success:^(BOOL success, NSDictionary *data, UIAlertController *successAlert) {
        if(success)
        {
            _data_dict=data;
            [self setData];
        }else
        {
            [self presentViewController:successAlert animated:YES completion:nil];
        }
    } failure:^(NSError *error, UIAlertController *failureAlert) {
        [self presentViewController:failureAlert animated:YES completion:nil];
    }];
}

#pragma mark - SetData
-(void)setData
{
    DD_ImageModel *imgModel=[DD_ImageModel getImageModel:[_data_dict objectForKey:@"pic"]];
    CGFloat _height=([imgModel.height floatValue]/[imgModel.width floatValue])*74;
    [headIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_height);
    }];
    [headIcon JX_ScaleToFill_loadImageUrlStr:imgModel.pic WithSize:800 placeHolderImageName:nil radius:0];
    
    brief.text=[_data_dict objectForKey:@"brief"];
//    brief.text=@"龙山历9616年，冬。安阳行省，青河郡，仪水县城境内。一名穿着剪裁精致的白色毛皮衣的唇红齿白的约莫八九岁的男孩，背着一矛囊，正灵活的飞窜在山林间，右手也持着一根黑色木柄短矛，追逐着前方的一头仓皇逃窜的野鹿，周围的树叶震动积雪簌簌而落。“着！”飞窜中的男孩猛然高举短矛，身体微微往后仰，腰腹力量传递到右臂，猛然一甩！刷！手中短矛破空飞出，擦着一些树叶，穿过三十余米距离，从野鹿背部边缘一擦而过，而后扎入雪地深处，仅仅在野鹿背部留下一道血痕，野鹿顿时更加拼命跑，朝山林深处钻去，眼看着就要跑丢。忽然嗖的一声，一颗石头飞出。石头化作流光穿行在山林间，飞过上百米距离，砰的声，贯穿了一株大树的树干，精准的射入了那头野鹿的头颅内，那野鹿坚硬的头骨也抵挡不住，踉跄着靠着惯性飞奔出十余米便轰然倒地，震的周围的无数积雪簌簌而落。　“父亲。”男孩转头看向远处，有些无奈道，“你别出手啊，我差点就能射中它了。”“我不出手，那野鹿就跑没了。高速飞奔中你的短矛准头还差些，今天傍晚回去加练五百次短矛。”声音雄浑，远远传来，远处两道身影正并肩走来。一名是颇为壮硕的黑发黑眼中年男子，身后背负着一兵器箱。另外一道身影却是更加魁梧壮硕，高过两米，手臂比常人大腿还粗，可他却有着狮子般的脑袋，正是狮首人躯！凌乱的黄色头发披散着，这赫然便是颇为少见的兽人中的‘狮人’，他同样背着一兵器箱。“铜三老弟，你看我儿子厉害吧，今年才八岁，已经有寻常成年男子的力气了。”中年男子笑道。“嗯，雪鹰是不错，将来比你强是没问题的。”狮人壮汉打趣道。“当然比我厉害，我八岁的时候还穷哈哈的和村里小孩玩闹，啥都不懂呢，还是后来进入军队才有机会修炼斗气！”中年男子感慨道，“我这个当父亲的，给不了儿子太过好的条件，不过能给的，我都会倾力给他，好好栽培他。”“东伯，你能从一个平民，成为一名天阶骑士，更能买下领地成为一名贵族，已经很厉害了。”狮人壮汉笑道。这中年男子正是周围过百里领地的领主——男爵东伯烈！男爵是夏族帝国‘龙山帝国’最低的一个贵族爵位，在帝国建国时，贵族爵位授予还很严格，如今帝国建立至今已经九千多年，这个庞然大物开始腐朽，一些低爵位买卖甚至都是官方允许。当初东伯烈和妻子因为有了孩子，才定买下贵族爵位，买下一块领地，这块领地更是起名为——雪鹰领！和他们的儿子同名，可见对这儿子的疼爱。【爱去小说网.】当然这仅仅只是仪水县内的一块小领地。“我二十岁才修炼出斗气，可我儿子不同，他今年才八岁，我估摸着十岁左右就能修炼出斗气，哈哈，肯定比我强多了。”东伯烈看着那男孩，眼中满是父亲对儿子的宠溺和期待。“看他的力气，十岁左右是差不多了。”狮人壮汉也赞同。他们经历的太多太多了，眼光自然很准。“父亲，你在那么远，扔的石头都能贯穿这么粗的大树？”男孩正站在那一株大树旁，双手去抱，竟然都无法完全抱住，这大树的树干上却被贯穿出一个大窟窿，“这么粗的大树啊，让我慢慢砍，都要砍上好久好久。”“知道天阶骑士的厉害了吧。”狮人壮汉说道，旁边东伯烈也得意一笑，在儿子面前当父亲的还是喜欢显摆显摆的。“有神厉害吗？”男孩故意撇嘴。“神？”东伯烈、狮人铜三顿时无语。龙山帝国的开创者‘龙山大帝’就是一位强大的神灵，这是这个世界几乎所有子民都知道的，东伯烈在军队中也算一员猛将了，可和神灵相比？根本没法比啊。“看来今天傍晚加练五百次短矛，还是少了，嗯，就加练一千次吧。”东伯烈砸着嘴巴说道。“父亲！”男孩瞪大眼睛，“你，你……”";
    NSString *time=[regular getTimeStr:[[_data_dict objectForKey:@"time"] longValue]/1000 WithFormatter:@"YYYY.MM"];
    version.text=[[NSString alloc] initWithFormat:@"%@   V%@",time,[_data_dict objectForKey:@"version"]];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(ktabbarHeight);
        // 让scrollview的contentSize随着内容的增多而变化
        make.bottom.mas_equalTo(version_back.mas_bottom).with.offset(40);
    }];
}
#pragma mark - Other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
