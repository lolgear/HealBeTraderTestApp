//
//  CurrenciesTableViewController.h
//  Trader
//
//  Created by Lobanov Dmitry on 04.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "CurrenciesBackProtocol.h"

@interface CurrenciesTableViewController : BaseTableViewController

@property (strong, nonatomic) NSString *currencyDestination;
@property (weak, nonatomic) id<CurrenciesBackProtocol> backDelegate;

@end
