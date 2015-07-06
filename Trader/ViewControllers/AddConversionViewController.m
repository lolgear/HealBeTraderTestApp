//
//  AddConversionViewController.m
//  Trader
//
//  Created by Lobanov Dmitry on 05.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import "AddConversionViewController.h"
#import "CurrenciesTableViewController.h"
#import "CurrenciesBackProtocol.h"
#import "HBTDatabaseManager.h"
#import "NSFoundationExtendedMethods.h"

NSString * destinationTypeFrom = @"destinationTypeFrom";
NSString * destinationTypeTo = @"destinationTypeTo";


@interface AddConversionViewController () <CurrenciesBackProtocol>

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *fromCurrencyCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *toCurrencyCodeButton;
@property (assign, nonatomic) BOOL saveAvailable;

@end

@implementation AddConversionViewController

#pragma mark - Getters
- (NSString *) saveErrors {
    return [self.toCurrencyCode isVisible] && [self.fromCurrencyCode isVisible] ? @"pair already exists" : @"currency not chosen";
}

- (void) updateSave {
    self.saveAvailable = [self.toCurrencyCode isVisible] && [self.fromCurrencyCode isVisible] && [HBTDatabaseManager conversionBySource:self.fromCurrencyCode andTarget:self.toCurrencyCode];
}

- (void) setCurrencyCode:(NSString *)code forDesination:(NSString *)destination {
    if ([destination isEqualToString:destinationTypeFrom]) {
        self.fromCurrencyCode = code;
    }
    else if ([destination isEqualToString:destinationTypeTo]) {
        self.toCurrencyCode = code;
        }
    else {
        // nothing?
    }
}

- (void) setFromCurrencyCode:(NSString *)fromCurrencyCode {
    _fromCurrencyCode = fromCurrencyCode;
    [self.fromCurrencyCodeButton setTitle:fromCurrencyCode forState:UIControlStateNormal];
    [self updateSave];
}

- (void) setToCurrencyCode:(NSString *)toCurrencyCode {
    _toCurrencyCode = toCurrencyCode;
    [self.toCurrencyCodeButton setTitle:toCurrencyCode forState:UIControlStateNormal];
    [self updateSave];
}

#pragma mark - Setup
- (void) setupElements {
    self.fromCurrencyCodeButton.titleLabel.text = nil;
    self.toCurrencyCodeButton.titleLabel.text = nil;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self setupElements];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideNotifications];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *controller = [segue destinationViewController];
    if ([controller isKindOfClass:[CurrenciesTableViewController class]]) {
        CurrenciesTableViewController *currenciesController = (CurrenciesTableViewController *)controller;
        NSString *currencyDestination = nil;
        if (sender == self.fromCurrencyCodeButton) {
            currencyDestination = destinationTypeFrom;
        }
        else if (sender == self.toCurrencyCodeButton) {
            currencyDestination = destinationTypeTo;
        }
        else {
            // hm
        }
        currenciesController.currencyDestination = currencyDestination;
        
        currenciesController.backDelegate = self;
    }
}

#pragma mark - Actions
- (IBAction)saveButtonPressed:(id)sender {
    // we should save this conversion somewhere
    if (!self.saveAvailable) {
        [self showNotificationError:[self saveErrors]];
        return;
    }
    NSNumber *timestamp = @([[NSDate date] timeIntervalSince1970]);
    NSDictionary *dictionary = @{
                                 @"source" : self.fromCurrencyCode,
                                 @"target" : self.toCurrencyCode,
                                 @"quote" : @(0),
                                 @"timestamp" : timestamp,
                                 @"added_at" : timestamp
                                 };
    [HBTDatabaseManager saveConversion:dictionary completion:^(BOOL contextDidSave, NSError *error) {
        if (error) {
            [self showNotificationError:error.localizedDescription];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
