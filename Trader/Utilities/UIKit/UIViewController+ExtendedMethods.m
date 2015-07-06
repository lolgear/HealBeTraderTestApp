//
//  UIViewController+ExtendedMethods.m
//  Airkey
//
//  Created by Alexandr Novikov on 31.05.15.
//  Copyright (c) 2015 AirkeyTeam. All rights reserved.
//

#import "UIViewController+ExtendedMethods.h"
#import "UIColor+Resources.h"
#import "ILMStringsManager.h"

@implementation UIViewController (ExtendedMethods)

- (void)addCloseButton {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeButtonPressed:)];
}

- (void)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showProgressView {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)hideProgressView {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)showNotificationError:(NSString *)errorString {
    [TSMessage showNotificationInViewController:self title:[ILMStringsManager getGeneralErrorTitleString] subtitle:errorString type:TSMessageNotificationTypeError duration:3.0f canBeDismissedByUser:YES];
}

- (void)hideNotifications {
    [TSMessage dismissActiveNotification];
}

@end
