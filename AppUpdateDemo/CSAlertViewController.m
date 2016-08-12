//
//  CSAlertViewController.m
//  AppUpdateDemo
//
//  Created by Shaochong Du on 16/7/17.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#define CSAppDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define kTipColorWithRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

#define kMsgTextColor kTipColorWithRGBA(165,165,165,1)  //  mesage颜色
#define kTipViewGrayColor kTipColorWithRGBA(105,105,105,1)  //  其他按钮背景色
#define kTipViewRedColor kTipColorWithRGBA(255,86,64,1) //  最后一个按钮背景色

#import "CSAlertViewController.h"
#import "SDAutoLayout.h"
#import "AppDelegate.h"

typedef NS_ENUM(NSInteger, CSButtonType)
{
    CSButtonTypeNormal ,    //  普通button
    CSButtonTypeHighlight   //  高亮button
};

@interface CSAlertViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgContentView;


@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;

@end

@implementation CSAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self setupViews];
    
    [self setupLayout];
    
    [_titleLabel setMaxNumberOfLinesToShow:1];
    [_messageLabel setMaxNumberOfLinesToShow:5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"tip:%@ dealloc",[NSString stringWithUTF8String:object_getClassName(self)]);
}

#pragma mark -  init something
//  初始化部分视图
- (void)setupViews
{
    self.bgContentView.layer.masksToBounds = YES;
    self.bgContentView.layer.cornerRadius = 5.0;
    self.bgContentView.backgroundColor = [UIColor whiteColor];
    
    if (self.alertTitle) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = self.alertTitle;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kTipViewRedColor;
        [self.bgContentView addSubview:_titleLabel];
//        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    }
    
    if (self.alertMessage) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = self.alertMessage;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = kMsgTextColor;
        _messageLabel.font = [UIFont systemFontOfSize:18.0];
        [self.bgContentView addSubview:_messageLabel];
    }
    
}

//  设置layout
- (void)setupLayout
{
    self.bgContentView.sd_layout
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view);
    
    UIView *lastView = self.bgContentView;
    
    if (self.alertTitle) {
        _titleLabel.sd_layout
        .topSpaceToView(lastView, 20)
        .leftSpaceToView(self.bgContentView, 10)
        .rightSpaceToView(self.bgContentView, 10)
        .heightIs(30);
        
        lastView = _titleLabel;
    } else {
        _titleLabel.hidden = YES;
        _titleLabel = nil;
    }
    
    if (self.alertMessage) {
        _messageLabel.sd_layout
        .topSpaceToView(lastView, 20)
        .leftSpaceToView(self.bgContentView, 10)
        .rightSpaceToView(self.bgContentView, 10)
        .autoHeightRatio(0);
        
        lastView = _messageLabel;
    } else {
        _messageLabel.hidden = YES;
        _messageLabel = nil;
    }
    
    if (self.buttonTitles.count == 1) {
        UIButton *btn = [self getButtonWithType:CSButtonTypeHighlight title:self.buttonTitles[0] tag:100];
        [self.bgContentView addSubview:btn];
        
        btn.sd_layout
        .topSpaceToView(lastView, 20)
        .leftSpaceToView(self.bgContentView, 0)
        .rightSpaceToView(self.bgContentView, 0)
        .heightIs(44);
        
        [self.bgContentView setupAutoHeightWithBottomView:btn bottomMargin:0];
    } else if (self.buttonTitles.count == 2) {
        UIView *_contentView;
        _contentView = [[UIView alloc] init];
        
        UIButton *cancelBtn = [self getButtonWithType:CSButtonTypeNormal title:self.buttonTitles[0] tag:100];
        UIButton *sureBtn = [self getButtonWithType:CSButtonTypeHighlight title:self.buttonTitles[1] tag:101];
        [_contentView sd_addSubviews:@[cancelBtn,sureBtn]];
        [self.bgContentView addSubview:_contentView];
        
        cancelBtn.sd_layout
        .autoHeightRatio(0.3);
        
        sureBtn.sd_layout
        .autoHeightRatio(0.3);
        
        _contentView.sd_layout
        .topSpaceToView(lastView, 20)
        .leftSpaceToView(self.bgContentView, 0)
        .rightSpaceToView(self.bgContentView, 0);
        
        // 设置一排固定间距自动宽度子view
        [_contentView setupAutoWidthFlowItems:@[cancelBtn,sureBtn] withPerRowItemsCount:2 verticalMargin:0 horizontalMargin:0 verticalEdgeInset:0 horizontalEdgeInset:0];
        
        [self.bgContentView setupAutoHeightWithBottomView:_contentView bottomMargin:0];
    } else if (self.buttonTitles.count > 2) {
        for (int i = 0; i < self.buttonTitles.count; i++) {
            if (i == self.buttonTitles.count - 1) {
                UIButton *sureBtn = [self getButtonWithType:CSButtonTypeHighlight title:self.buttonTitles[i] tag:100 + i];
                [self.bgContentView addSubview:sureBtn];
                
                sureBtn.sd_layout
                .topSpaceToView(lastView, 0)
                .leftSpaceToView(self.bgContentView, 0)
                .rightSpaceToView(self.bgContentView, 0)
                .heightIs(44);
                
                lastView = sureBtn;
                
                [self.bgContentView setupAutoHeightWithBottomView:lastView bottomMargin:0];
            } else {
                UIButton *otherBtn = [self getButtonWithType:CSButtonTypeNormal title:self.buttonTitles[i] tag:100 + i];
                [self.bgContentView addSubview:otherBtn];
                
                CGFloat topSpace = 0;
                if (i == 0) {
                    topSpace = 20;
                } else {
                    //  添加横线
                    UIView *seperateLine = [[UIView alloc] init];
                    seperateLine.backgroundColor = kTipColorWithRGBA(128,128,128, 1.0);
                    [self.bgContentView addSubview:seperateLine];
                    
                    seperateLine.sd_layout
                    .topSpaceToView(lastView, 0)
                    .leftSpaceToView(self.bgContentView, 0)
                    .rightSpaceToView(self.bgContentView, 0)
                    .heightIs(0.5);
                    lastView = seperateLine;
                }
                otherBtn.sd_layout
                .topSpaceToView(lastView, topSpace)
                .leftSpaceToView(self.bgContentView, 0)
                .rightSpaceToView(self.bgContentView, 0)
                .heightIs(44);
                
                lastView = otherBtn;
            }
        }
    } else {
        NSLog(@"error:必须传入按钮数组");
        return;
    }
}

- (UIButton *)getButtonWithType:(CSButtonType)buttonType title:(NSString *)title tag:(NSInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    if (buttonType == CSButtonTypeNormal) {
        [btn setBackgroundColor:kTipViewGrayColor];
    } else {
        [btn setBackgroundColor:kTipViewRedColor];
    }
    [btn setTintColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(btnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

#pragma mark - show
//  显示
- (void)show
{
    //  使用present方法弹出页面时
    UIViewController *topVC = CSAppDelegate.window.rootViewController;
    if (CSAppDelegate.window.rootViewController.presentedViewController) {
        topVC = CSAppDelegate.window.rootViewController.presentedViewController;
    }
    
    [topVC addChildViewController:self];
    [topVC.view addSubview:self.view];
    
    self.view.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    //    NSLog(@"presentedViewController - >%@",CSAppDelegate.window.rootViewController.presentedViewController);
    //    NSLog(@"presentingViewController - >%@",CSAppDelegate.window.rootViewController.presentingViewController);
    //    NSLog(@"parentViewController - >%@",CSAppDelegate.window.rootViewController.parentViewController);
    //    NSLog(@"modalViewController - >%@",CSAppDelegate.window.rootViewController.modalViewController);
    
    self.bgContentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.25f, 0.25f);
    self.bgContentView.alpha = 0;
    
    [UIView animateWithDuration:.25 animations:^{
        self.bgContentView.alpha = 1;
        self.bgContentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
    } completion:^(BOOL finished) {

    }];
}

#pragma mark - gesture
- (IBAction)bgViewTapGesture:(id)sender
{
    [self hideAlertView];
    if ([self.delegate respondsToSelector:@selector(CSAlertBgViewClicked)]) {
        [self.delegate CSAlertBgViewClicked];
    }
}

- (IBAction)contentViewTapGesture:(id)sender
{
    NSLog(@"tip:点击承载视图");
}


#pragma mark - 
- (void)btnClickedAction:(UIButton *)btn
{
    [self hideAlertView];
    if ([self.delegate respondsToSelector:@selector(CSAlertViewController:clickedButtonAtIndex:)]) {
        [self.delegate CSAlertViewController:self clickedButtonAtIndex:(btn.tag - 100)];
    }
}

- (void)hideAlertView
{
    //  注意：若在点击alertview消失时，返回根视图，请将duration时间大于alertview隐藏时间，防止在tabbar中多出一个item显示空值，如：
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC));
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //        [self.navigationController popToRootViewControllerAnimated:YES];
    //    });
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bgContentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.25f, 0.25f);
        self.bgContentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromParentViewController];
        [self.view removeFromSuperview];;
    }];
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
