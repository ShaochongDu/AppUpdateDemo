# AppUpdateDemo
app更新检测

     
![image](https://github.com/ShaochongDu/AppUpdateDemo/raw/master/DemoScreenShot.gif)

### 版本更新逻辑

     *  1. 判断当前是否WIFI网络，非WIFI网络下不进行更新请求 （暂时未处理）
     *  2. 请求苹果服务器查看iTunes最新版本
     *  3. 取当前应用版本跟iTunes版本比对（有可能系统默认对应用进行了更新操作）
     3.1 相同，则结束
     3.2 不同，取本地记录上次版本信息进行比较，若无将iTunes版本记录本地（以便进行下一次比较），并记录本地版本已提醒过，下次不再提醒，否则弹出对话框，提醒用户版本更新
     *  4. 不论用户同意或拒绝，都记录本次iTunes版本已经被处理过，下次进入应用不对用户进行提示
     *      4.1 同意则跳转AppStore进行更新
     *      4.2 拒绝则隐藏页面

### 使用方法
```
CSVersionCheckViewController *versionsCheckVC = [[CSVersionCheckViewController alloc] initWithAppId:@"1110238123"];
[versionsCheckVC versionsCheck];
//  防止CSVersionCheckViewController自动释放 内部会对controller释放
[self.window.rootViewController addChildViewController:versionsCheckVC];
```
