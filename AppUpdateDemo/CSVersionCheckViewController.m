//
//  CSVersionCheckViewController.m
//  AppUpdateDemo
//
//  Created by Shaochong Du on 16/7/17.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import "CSVersionCheckViewController.h"
#import "CSAlertViewController.h"
#import "CSNetWorkManager.h"

NSString *const kLastVersionKey = @"kLastVersionKey";   //  本地上一个版本号

@interface CSVersionCheckViewController ()<CSAlertViewControllerDelegate>
{
    NSString *_appId;
    NSDictionary *_releaseInfo;
}
@end

@implementation CSVersionCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"tip:%@ dealloc",[NSString stringWithUTF8String:object_getClassName(self)]);
}

-(CSVersionCheckViewController *)initWithAppId:(NSString *)appId
{
    if (self = [super init]) {
        _appId = appId;
    }
    return self;
}

#pragma mark - versions check
- (void)versionsCheck
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
    NSLog(@"当前版本:%@",currentVersion);
    
    /**
     *  版本检测逻辑
     *  1. 判断当前是否WIFI网络，非WIFI网络下不进行更新请求
     *  2. 请求苹果服务器查看iTunes最新版本
     *  3. 取当前应用版本跟iTunes版本比对（有可能系统默认对应用进行了更新操作）
     3.1 相同，则结束
     3.2 不同，取本地记录上次版本信息进行比较，若无将iTunes版本记录本地（以便进行下一次比较），并记录本地版本已提醒过，下次不再提醒，否则弹出对话框，提醒用户版本更新
     *  4. 不论用户同意或拒绝，都记录本次iTunes版本已经被处理过，下次进入应用不对用户进行提示
     *      4.1 同意则跳转AppStore进行更新
     *      4.2 拒绝则隐藏页面
     */
    //    http://itunes.apple.com/lookup?id=1110238123
    __weak CSVersionCheckViewController *weakSelf = self;
    //  id 对应应用的id
    NSString *appstoreUrlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",_appId];
    [[CSNetWorkManager shareManager] postWithUrlStr:appstoreUrlStr headerParameterDic:nil parameterDic:nil successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf parseResultDic:responseObject];
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf CSAlertBgViewClicked];
    } progressBlock:^(NSProgress *downloadProgress) {
        
    }];
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles
{
    CSAlertViewController *alertVC = [[CSAlertViewController alloc] init];
    alertVC.alertTitle = title;
    alertVC.alertMessage = message;
    alertVC.buttonTitles = buttonTitles;
    alertVC.delegate = self;
    [alertVC show];
}

- (void)parseResultDic:(NSDictionary *)resultDic
{
    NSArray *infoArray = [resultDic objectForKey:@"results"];
    _releaseInfo = infoArray[0];
    NSString *latestVersion = _releaseInfo[@"version"];
    NSString *releaseNotes = _releaseInfo[@"releaseNotes"];
    NSLog(@"\n\ntip:-------------- iTunes最新版本 %@ --------------\n",latestVersion);
    [self compareWithiTunesVersion:latestVersion andReleaseNotes:releaseNotes];
    /**
     //  介绍页面
     NSString *trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];
     UIApplication *application = [UIApplication sharedApplication];
     [application openURL:[NSURL URLWithString:trackViewUrl]];
     //  评论
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1110238123"]];
     //  下载页面
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1110238123"]];
     */
    
}

- (void)compareWithiTunesVersion:(NSString *)appStoreVersion andReleaseNotes:(NSString *)releaseNotes
{
    //  1. 使用此处调试代码 注释2
//    [self showAlertViewWithTitle:[NSString stringWithFormat:@"升级新版本 V%@",appStoreVersion] message:releaseNotes buttonTitles:@[@"下次再说",@"立即更新"]];
    
    //  2. 使用此处调试代码 注释1
    //  使用version比较 而非build的号
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"tip:当前版本号->%@",currentVersion);
    //  比对当前版本号 跟 iTunes应用版本号是否相同
    if (![appStoreVersion isEqualToString:currentVersion]) {
        //  比对iTunes版本号 跟 本地上次保存的版本号是否相同
        if (![appStoreVersion isEqualToString:[self getLocalLastVersion]]) {
            //  本地存储当前iTunes版本信息，表示已经提示过
            [self saveLocalLastVersion:appStoreVersion];
            [self showAlertViewWithTitle:[NSString stringWithFormat:@"升级新版本 V%@",appStoreVersion] message:releaseNotes buttonTitles:@[@"下次再说",@"立即更新"]];
        } else {
            [self CSAlertBgViewClicked];
            NSLog(@"tip:之前已经提示过，本版本以后不再提示");
        }
    } else {
        [self CSAlertBgViewClicked];
        NSLog(@"tip:应用已是最新版本->%@",currentVersion);
    }
}

- (NSString *)getLocalLastVersion
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *localVerson = [userDefault objectForKey:kLastVersionKey];
    NSLog(@"tip:上次保存版本号->%@",localVerson);
    return localVerson;
}

- (void)saveLocalLastVersion:(NSString *)appStoreVersion
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:appStoreVersion forKey:kLastVersionKey];
    BOOL result = [userDefault synchronize];
    NSLog(@"tip:版本->%@ 保存结果->%d",appStoreVersion,result);
}

#pragma mark - CSAlertViewControllerDelegate
-(void)CSAlertViewController:(CSAlertViewController *)alertViewController clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"tip:点击button索引->%ld",buttonIndex);
    
    if (buttonIndex == 1) {
        //  跳转AppStore下载
        NSString *trackViewUrl = [_releaseInfo objectForKey:@"trackViewUrl"];
        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
            trackViewUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",_appId];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
    }
    [self CSAlertBgViewClicked];
}

-(void)CSAlertBgViewClicked
{
    [self removeFromParentViewController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
