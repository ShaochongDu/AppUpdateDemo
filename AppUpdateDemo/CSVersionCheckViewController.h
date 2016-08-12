//
//  CSVersionCheckViewController.h
//  AppUpdateDemo
//
//  Created by Shaochong Du on 16/7/17.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSVersionCheckViewController : UIViewController

/**
 *  初始化
 *
 *  @param appId 应用id
 *
 *  @return 实例
 */
- (CSVersionCheckViewController *)initWithAppId:(NSString *)appId;

/**
 *  版本检测
 */
- (void)versionsCheck;

@end
