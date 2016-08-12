//
//  CSAlertViewController.h
//  AppUpdateDemo
//
//  Created by Shaochong Du on 16/7/17.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//
/// 
#import <UIKit/UIKit.h>
@class CSAlertViewController;
@protocol CSAlertViewControllerDelegate <NSObject>

- (void)CSAlertViewController:(CSAlertViewController *)alertViewController clickedButtonAtIndex:(NSInteger)buttonIndex; //  点击button

- (void)CSAlertBgViewClicked;  //  点击背景

@end

@interface CSAlertViewController : UIViewController

@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *alertMessage;
@property (nonatomic, strong) NSArray *buttonTitles;    //  最后一个为取消或确定按钮样式
@property (nonatomic, assign) id<CSAlertViewControllerDelegate>delegate;


//  显示
- (void)show;

@end
