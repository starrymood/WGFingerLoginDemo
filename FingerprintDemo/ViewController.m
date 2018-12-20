//
//  ViewController.m
//  FingerprintDemo
//
//  Created by DY on 2018/12/18.
//  Copyright © 2018 MR.F. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import <LocalAuthentication/LocalAuthentication.h>

static NSString *const LoginStatus = @"IsLoginSuccess";
static NSString *const atomicFingerLogin = @"atomicFingerLogin";
//static NSString

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UISwitch *fingerLoginSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"指纹识别";
    self.accountTF.delegate = self;
    self.pwdTF.delegate = self;
    
    LAContext *context = [[LAContext alloc]init];
    NSError* error = nil;
    if (![context canEvaluatePolicy:(LAPolicyDeviceOwnerAuthenticationWithBiometrics) error:&error]) {
    }
}

#pragma Mark  UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {

}

- (IBAction)switchAction:(UISwitch *)sender {
    NSLog(@"开关状态: %d", sender.on);
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:atomicFingerLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (sender.on) {
        [self openAuthorFingerAction];
    }
    
}


#pragma Mark 确定登录
- (IBAction)ensureAction:(UIButton *)sender {
    
    if (![self.accountTF.text isEqualToString:@"admin"]) {
        NSLog(@"账号错误");
        return;
    }
    
    if (![self.pwdTF.text isEqualToString:@"123"]) {
        NSLog(@"密码错误");
        return;
    }

    [[NSUserDefaults standardUserDefaults] setObject:self.accountTF.text forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] setObject:self.pwdTF.text forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LoginStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIAlertController * alertVC= [UIAlertController alertControllerWithTitle:@"是否启用指纹识别" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"启用" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        [self openAuthorFingerAction];
    }];
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
         
         [[NSUserDefaults standardUserDefaults] setBool:NO forKey:atomicFingerLogin];
    }];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:nil];
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
