//
//  AddConversionViewController.h
//  Trader
//
//  Created by Lobanov Dmitry on 05.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * destinationTypeFrom;
extern NSString * destinationTypeTo;

@interface AddConversionViewController : UIViewController

@property (strong, nonatomic) NSString *fromCurrencyCode;
@property (strong, nonatomic) NSString *toCurrencyCode;

@end
