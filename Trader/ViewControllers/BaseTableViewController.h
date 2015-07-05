//
//  BaseTableViewController.h
//  Trader
//
//  Created by Lobanov Dmitry on 04.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MagicalRecord/MagicalRecord.h>
#import "UIKitExtendedMethods.h"

@interface BaseTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

#pragma mark - Setup
- (void) setupUIElements;

#pragma mark - Refresh
- (void)refresh:(id)sender;

#pragma mark - Fetched Results Controller
- (NSFetchedResultsController *)createFetchedResultsController;

@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

@end
