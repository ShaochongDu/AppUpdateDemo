# AppUpdateDemo

app更新检测

     
![image](https://github.com/ShaochongDu/AppUpdateDemo/raw/master/AppUpdateDemo/DemoScreenShot.gif)
### 提示
```
由于苹果限制不允许在app内应用更新检测，可将CSVersionCheckViewController中versionsCheck方法改为请求自己服务器，并设置是否允许更新标识，提交AppStore审核时，标识为NO，审核通过后置为YES。
```

### 版本更新逻辑
```
     *  1. 判断当前是否WIFI网络，非WIFI网络下不进行更新请求 （暂时未处理）
     *  2. 请求苹果服务器查看iTunes最新版本
     *  3. 取当前应用版本跟iTunes版本比对（有可能系统默认对应用进行了更新操作）
     3.1 相同，则结束
     3.2 不同，取本地记录上次版本信息进行比较，若无将iTunes版本记录本地（以便进行下一次比较），并记录本地版本已提醒过，下次不再提醒，否则弹出对话框，提醒用户版本更新
     *  4. 不论用户同意或拒绝，都记录本次iTunes版本已经被处理过，下次进入应用不对用户进行提示
     *      4.1 同意则跳转AppStore进行更新
     *      4.2 拒绝则隐藏页面
```
### 使用方法
```
CSVersionCheckViewController *versionsCheckVC = [[CSVersionCheckViewController alloc] initWithAppId:@"1110238123"];
[versionsCheckVC versionsCheck];
//  防止CSVersionCheckViewController自动释放 内部会对controller释放
[self.window.rootViewController addChildViewController:versionsCheckVC];
```

### alert使用方法
```
//  注意：若在点击alertview消失时，返回根视图，请将duration时间大于hideAlertView方法中的隐藏时间（默认0.25），防止在tabbar中多出一个item显示空值，如：
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    });
CSAlertViewController *alertVC = [[CSAlertViewController alloc] init];
alertVC.alertTitle = title;
alertVC.alertMessage = message;
alertVC.buttonTitles = buttonTitles;
alertVC.delegate = self;
[alertVC show];
```
