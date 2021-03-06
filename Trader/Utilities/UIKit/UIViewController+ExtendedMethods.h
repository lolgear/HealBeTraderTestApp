//
//  UIViewController+ExtendedMethods.h
//  Airkey
//
//  Created by Alexandr Novikov on 31.05.15.
//  Copyright (c) 2015 AirkeyTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <TSMessages/TSMessage.h>

@interface UIViewController (ExtendedMethods)

- (void)addCloseButton;

- (void)showProgressHud;

- (void)hideProgressHud;

- (void)showNotificationError:(NSString *)errorString;

- (void)hideNotifications;

@end
