//
//  ViewController.m
//  AppUpdateDemo
//
//  Created by Shaochong Du on 16/7/14.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import "ViewController.h"
#import "CSAlertViewController.h"


@interface ViewController () <CSAlertViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
//    [self addChildViewController:versionsCheckVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)singleBtn:(id)sender
{
    [self showAlertViewWithTitle:@"升级新版本" message:@"~~亲爱的小伙伴，优活动2.1.0版本发布啦，更多优质活动期待您的参与！\n·活动报名流程更加完善\n·闪退及其他bug修复" buttonTitles:@[@"立即更新"]];
}

- (IBAction)doubleBtn:(id)sender
{
    [self showAlertViewWithTitle:@"升级新版本" message:nil buttonTitles:@[@"下次再说",@"立即更新"]];
}

- (IBAction)mutiBtn:(id)sender
{
    [self showAlertViewWithTitle:@"升级新版本" message:@"~~亲爱的小伙伴，优活动2.1.0版本发布啦，更多优质活动期待您的参与！\n·活动报名流程更加完善\n·闪退及其他bug修复" buttonTitles:@[@"下次再说",@"立即更新",@"当没看见",@"立即更新",@"当没看见"]];
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

#pragma mark - CSAlertViewControllerDelegate
-(void)CSAlertViewController:(CSAlertViewController *)alertViewController clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"tip:点击button索引->%ld",buttonIndex);
}




@end
