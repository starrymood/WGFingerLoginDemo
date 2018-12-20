//
//  WGFingerViewController.m
//  FingerprintDemo
//
//  Created by DY on 2018/12/18.
//  Copyright © 2018 MR.F. All rights reserved.
//

#import "WGFingerViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "Masonry.h"

@interface WGFingerViewController ()

@end

@implementation WGFingerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"指纹登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setImage:[UIImage imageNamed:@"zhiwen"] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(clickAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    [self openAuthorFingerAction];
}

- (void)clickAction {
}

- (void)openAuthorFingerAction {
    LAContext * context = [[LAContext alloc] init];
    context.localizedFallbackTitle= @"密码登录";
    context.localizedCancelTitle = @"取消";
    if (@available(iOS 11.0, *)) {
        context.localizedReason = @"然而看看s这个什么鬼";
    } else {
        
    }
    NSError * error = nil;
    if ([context canEvaluatePolicy:(LAPolicyDeviceOwnerAuthenticationWithBiometrics) error:&error]) {
        [context evaluatePolicy:(LAPolicyDeviceOwnerAuthenticationWithBiometrics) localizedReason:@"这就是爱吧" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"哈哈哈, 看来这个问题解决了");
            } else {
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"Authentication was cancelled by the system");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"User selected to enter custom password");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                        }];
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        NSLog(@"Authentication Failed");
                        break;
                    }
                    case LAErrorTouchIDLockout:
                    {
                        NSLog(@"TOUCH ID is locked out");
                        break;
                    }
                    case LAErrorAppCancel:
                    {
                        NSLog(@"app cancle the authentication");
                        break;
                    }
                    case LAErrorInvalidContext:
                    {
                        NSLog(@"context is invalidated");
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    } else {
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                
                break;
            }
            default:
            {
                
                break;
            }
        }
    }
}








@end
